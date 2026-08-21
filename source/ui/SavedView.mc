using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;

// Brief confirmation shown after a hydration event is logged, so
// pressing SELECT twice always gives clear feedback instead of
// silently landing back on the home screen. Auto-dismisses so it
// never costs the user an extra button press.
class HydrationSavedView extends Ui.View {

    const AUTO_DISMISS_MS = 900;

    var amount;
    var electrolytes;
    var dismissTimer;

    function initialize(amountMl, withElectrolytes) {
        View.initialize();
        amount = amountMl;
        electrolytes = withElectrolytes;
    }

    function onShow() {
        dismissTimer = new Timer.Timer();
        dismissTimer.start(method(:dismiss), AUTO_DISMISS_MS, false);
    }

    function onHide() {
        if (dismissTimer != null) {
            dismissTimer.stop();
            dismissTimer = null;
        }
    }

    function dismiss() {
        Ui.switchToView(new HydrationMainView(), new HydrationMainDelegate(), Ui.SLIDE_DOWN);
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
        dc.drawText(width / 2, height / 2 - 30, Gfx.FONT_MEDIUM, "Saved",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        var detail = Format.amountText(amount) + (electrolytes ? " + electrolytes" : "");
        dc.drawText(width / 2, height / 2 + 15, Gfx.FONT_SMALL, detail,
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
