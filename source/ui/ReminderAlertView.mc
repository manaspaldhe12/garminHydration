using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

// "DRINK WATER" alert shown when a reminder is pending, either
// because the background service just fired it or because it fired
// while the app was closed.
class HydrationReminderAlertView extends Ui.View {

    var pending;

    function initialize(p) {
        View.initialize();
        pending = p;
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.drawText(width / 2, height / 2 - 40, Gfx.FONT_MEDIUM, "DRINK WATER",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        var info = Clock.infoFor(pending.get("due"));
        dc.drawText(width / 2, height / 2 + 10, Gfx.FONT_NUMBER_MEDIUM, Format.hm(info.hour, info.min),
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height - 20, Gfx.FONT_XTINY, "SELECT: Dismiss  BACK: Later",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
