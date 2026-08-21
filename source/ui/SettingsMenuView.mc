using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class HydrationSettingsMenuView extends Ui.View {

    const ITEMS = [ "Reminders", "Default Amount", "Default Electrolytes", "History" ];

    var cursor;

    function initialize() {
        View.initialize();
        cursor = 0;
    }

    function moveNext() {
        cursor = (cursor + 1) % ITEMS.size();
        Ui.requestUpdate();
    }

    function movePrev() {
        cursor -= 1;
        if (cursor < 0) {
            cursor = ITEMS.size() - 1;
        }
        Ui.requestUpdate();
    }

    function selectedIndex() {
        return cursor;
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.drawText(width / 2, 30, Gfx.FONT_SMALL, "Hydration",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        var rowHeight = 30;
        var startY = height / 2 - rowHeight;

        for (var i = 0; i < ITEMS.size(); i += 1) {
            var y = startY + (i * rowHeight);
            Format.drawMenuRow(dc, width / 2, y, width - 40, rowHeight - 6, ITEMS[i], i == cursor);
        }

        dc.drawText(width / 2, height - 20, Gfx.FONT_XTINY, "UP/DOWN  SELECT: open  BACK",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
