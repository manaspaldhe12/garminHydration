using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

// Daily totals, most recent first, going back HistoryAggregator.DEFAULT_DAYS days.
class HydrationHistoryView extends Ui.View {

    var days;
    var cursor;

    function initialize() {
        View.initialize();
        days = HistoryAggregator.dailyTotals(HistoryAggregator.DEFAULT_DAYS);
        cursor = 0;
    }

    function moveNext() {
        cursor = (cursor + 1) % days.size();
        Ui.requestUpdate();
    }

    function movePrev() {
        cursor -= 1;
        if (cursor < 0) {
            cursor = days.size() - 1;
        }
        Ui.requestUpdate();
    }

    function selectedDay() {
        return days[cursor];
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.drawText(width / 2, 24, Gfx.FONT_SMALL, "History",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        var visibleCount = 4;
        var total = days.size();
        var firstVisible = cursor - 1;
        if (firstVisible < 0) {
            firstVisible = 0;
        }
        if (firstVisible + visibleCount > total) {
            firstVisible = total - visibleCount;
        }
        if (firstVisible < 0) {
            firstVisible = 0;
        }

        var rowHeight = 32;
        var startY = 58;

        for (var row = 0; row < visibleCount; row += 1) {
            var i = firstVisible + row;
            if (i >= total) {
                break;
            }

            var day = days[i];
            var y = startY + (row * rowHeight);
            var text = Format.dayLabel(day.get("dayStart")) + "  " + Format.amountText(day.get("total"));

            Format.drawMenuRow(dc, width / 2, y, width - 40, rowHeight - 8, text, i == cursor);
        }

        dc.drawText(width / 2, height - 16, Gfx.FONT_XTINY, "SELECT: details  BACK",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
