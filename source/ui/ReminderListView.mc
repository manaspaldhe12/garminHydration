using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

// Lists all reminders plus a trailing "Add Reminder" row. Reloads
// from storage on every draw so edits made in the editor screen show
// up immediately when popping back.
class HydrationReminderListView extends Ui.View {

    var cursor;

    function initialize() {
        View.initialize();
        cursor = 0;
    }

    function reminders() {
        return ReminderStore.load();
    }

    function rowCount() {
        return reminders().size() + 1;
    }

    function moveNext() {
        cursor = (cursor + 1) % rowCount();
        Ui.requestUpdate();
    }

    function movePrev() {
        cursor -= 1;
        if (cursor < 0) {
            cursor = rowCount() - 1;
        }
        Ui.requestUpdate();
    }

    function resetCursor() {
        var count = rowCount();
        if (cursor >= count) {
            cursor = count > 0 ? count - 1 : 0;
        }
    }

    function isAddRowSelected() {
        return cursor == reminders().size();
    }

    function selectedReminder() {
        return reminders()[cursor];
    }

    function onUpdate(dc) {
        resetCursor();

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var list = reminders();

        dc.drawText(width / 2, 26, Gfx.FONT_SMALL, "Reminders",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        // Show up to 4 rows centered around the cursor so longer
        // lists still work on the small round display.
        var visibleCount = 4;
        var total = list.size() + 1;
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

        var rowHeight = 34;
        var startY = 60;

        for (var row = 0; row < visibleCount; row += 1) {
            var i = firstVisible + row;
            if (i >= total) {
                break;
            }

            var y = startY + (row * rowHeight);
            var prefix = (i == cursor ? "> " : "  ");
            var text;

            if (i < list.size()) {
                var reminder = list[i];
                text = prefix + Format.hm(reminder.get("hour"), reminder.get("min")) + "  " + Format.onOff(reminder.get("enabled"));
            } else {
                text = prefix + "[Add Reminder]";
            }

            dc.drawText(width / 2, y, Gfx.FONT_XTINY, text,
                Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        }

        dc.drawText(width / 2, height - 16, Gfx.FONT_XTINY, "SELECT: open  BACK",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
