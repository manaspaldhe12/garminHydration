using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class HydrationDefaultElectrolytesView extends Ui.View {

    var electrolytes;

    function initialize() {
        View.initialize();
        var settings = SettingsStore.load();
        electrolytes = settings.get("elec");
    }

    function toggle() {
        electrolytes = !electrolytes;
        Ui.requestUpdate();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.drawText(width / 2, 40, Gfx.FONT_SMALL, "Default Electrolytes",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.setColor(electrolytes ? Gfx.COLOR_GREEN : Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        dc.drawText(width / 2, height / 2 - 20, Gfx.FONT_MEDIUM, electrolytes ? "> Yes" : "  Yes",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.setColor(electrolytes ? Gfx.COLOR_LT_GRAY : Gfx.COLOR_RED, Gfx.COLOR_BLACK);
        dc.drawText(width / 2, height / 2 + 20, Gfx.FONT_MEDIUM, electrolytes ? "  No" : "> No",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(width / 2, height - 20, Gfx.FONT_XTINY, "UP/DOWN  SELECT: save  BACK",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
