using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

// Minimal second screen so v0.0 demonstrates basic navigation between
// screens, as required by the app-shell milestone.
class HydrationAboutView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.drawText(width / 2, height / 2 - 20, Gfx.FONT_SMALL, "Hydration Reminder",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height / 2 + 10, Gfx.FONT_XTINY, "Forerunner 935",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height - 20, Gfx.FONT_XTINY, "BACK: return",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
