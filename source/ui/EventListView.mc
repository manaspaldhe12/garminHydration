using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

// Individual logged events for a single day, most recent first.
class HydrationEventListView extends Ui.View {

    var dayStart;
    var events;
    var cursor;

    function initialize(dayStartEpoch) {
        View.initialize();
        dayStart = dayStartEpoch;
        events = HistoryAggregator.eventsForDay(dayStartEpoch);
        // Most recent first.
        var reversed = [];
        for (var i = events.size() - 1; i >= 0; i -= 1) {
            reversed.add(events[i]);
        }
        events = reversed;
        cursor = 0;
    }

    function moveNext() {
        if (events.size() == 0) {
            return;
        }
        cursor = (cursor + 1) % events.size();
        Ui.requestUpdate();
    }

    function movePrev() {
        if (events.size() == 0) {
            return;
        }
        cursor -= 1;
        if (cursor < 0) {
            cursor = events.size() - 1;
        }
        Ui.requestUpdate();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.drawText(width / 2, 22, Gfx.FONT_SMALL, Format.dayLabel(dayStart),
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        var total = HydrationEvents.totalAmount(events);
        dc.drawText(width / 2, 46, Gfx.FONT_XTINY, Format.amountText(total) + " total",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        if (events.size() == 0) {
            dc.drawText(width / 2, height / 2, Gfx.FONT_XTINY, "No events logged",
                Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        } else {
            var visibleCount = 4;
            var total_rows = events.size();
            var firstVisible = cursor - 1;
            if (firstVisible < 0) {
                firstVisible = 0;
            }
            if (firstVisible + visibleCount > total_rows) {
                firstVisible = total_rows - visibleCount;
            }
            if (firstVisible < 0) {
                firstVisible = 0;
            }

            var rowHeight = 30;
            var startY = 78;

            for (var row = 0; row < visibleCount; row += 1) {
                var i = firstVisible + row;
                if (i >= total_rows) {
                    break;
                }

                var event = events[i];
                var info = Clock.infoFor(event.get("ts"));
                var y = startY + (row * rowHeight);
                var text = Format.hm(info.hour, info.min) + "  " + Format.amountText(event.get("amt")) + "  " + Format.yesNo(event.get("elec"));

                Format.drawMenuRow(dc, width / 2, y, width - 40, rowHeight - 8, text, i == cursor);
            }
        }

        dc.drawText(width / 2, height - 14, Gfx.FONT_XTINY, "BACK",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
