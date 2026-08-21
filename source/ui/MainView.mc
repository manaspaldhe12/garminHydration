using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

// Placeholder home screen for the v0.0 app shell. Real hydration
// functionality (menu, logging, history) lands in later milestones.
class HydrationMainView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.drawText(width / 2, height / 2 - 30, Gfx.FONT_MEDIUM, "Hydration",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height / 2, Gfx.FONT_SMALL, "App running.",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height - 20, Gfx.FONT_XTINY, "SELECT: info",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
