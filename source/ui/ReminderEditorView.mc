using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

// Field order: Enabled, Hour, Minute, Days, Save, [Delete when editing
// an existing reminder]. UP/DOWN move the cursor between fields;
// SELECT toggles Enabled/Days directly, or enters "adjusting" mode for
// Hour/Minute (where UP/DOWN change the value instead of the cursor).
class HydrationReminderEditorView extends Ui.View {

    const FIELD_ENABLED = 0;
    const FIELD_HOUR = 1;
    const FIELD_MINUTE = 2;
    const FIELD_DAYS = 3;
    const FIELD_SAVE = 4;
    const FIELD_DELETE = 5;

    var reminder;
    var isNew;
    var cursor;
    var adjusting;
    var confirmDelete;

    function initialize(r, isNewReminder) {
        View.initialize();
        // Work on a copy so backing out without saving leaves the
        // stored reminder untouched.
        reminder = {
            "id" => r.get("id"),
            "hour" => r.get("hour"),
            "min" => r.get("min"),
            "enabled" => r.get("enabled"),
            "days" => r.get("days")
        };
        isNew = isNewReminder;
        cursor = 0;
        adjusting = false;
        confirmDelete = false;
    }

    function fieldCount() {
        return isNew ? 5 : 6;
    }

    function reminderData() {
        return reminder;
    }

    function toggleEnabled() {
        reminder.put("enabled", !reminder.get("enabled"));
        Ui.requestUpdate();
    }

    function toggleDays() {
        var current = reminder.get("days");
        reminder.put("days", current == Days.ALL ? Days.WEEKDAYS : Days.ALL);
        Ui.requestUpdate();
    }

    function toggleAdjusting() {
        adjusting = !adjusting;
        Ui.requestUpdate();
    }

    function moveCursor(delta) {
        confirmDelete = false;

        if (adjusting) {
            adjustValue(delta);
            return;
        }

        cursor += delta;
        var count = fieldCount();
        if (cursor < 0) {
            cursor = count - 1;
        } else if (cursor >= count) {
            cursor = 0;
        }
        Ui.requestUpdate();
    }

    function adjustValue(delta) {
        if (cursor == FIELD_HOUR) {
            var hour = reminder.get("hour") + delta;
            if (hour < 0) {
                hour = 23;
            } else if (hour > 23) {
                hour = 0;
            }
            reminder.put("hour", hour);
        } else if (cursor == FIELD_MINUTE) {
            var minute = reminder.get("min") + delta;
            if (minute < 0) {
                minute = 59;
            } else if (minute > 59) {
                minute = 0;
            }
            reminder.put("min", minute);
        }
        Ui.requestUpdate();
    }

    function rowLabel(field) {
        if (field == FIELD_ENABLED) {
            return "Enabled     " + Format.onOff(reminder.get("enabled"));
        }
        if (field == FIELD_HOUR) {
            return "Hour        " + Format.pad2(reminder.get("hour"));
        }
        if (field == FIELD_MINUTE) {
            return "Minute      " + Format.pad2(reminder.get("min"));
        }
        if (field == FIELD_DAYS) {
            return "Days   " + Format.daysLabel(reminder.get("days"));
        }
        if (field == FIELD_SAVE) {
            return "Save";
        }
        return "Delete";
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.drawText(width / 2, 22, Gfx.FONT_SMALL, isNew ? "New Reminder" : "Edit Reminder",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        var rowHeight = 24;
        var startY = 55;
        var count = fieldCount();

        for (var field = 0; field < count; field += 1) {
            var y = startY + (field * rowHeight);
            var isCursor = (field == cursor);
            var isAdjustingThisField = isCursor && adjusting && (field == FIELD_HOUR || field == FIELD_MINUTE);
            var isConfirmingDelete = isCursor && confirmDelete && field == FIELD_DELETE;
            Format.drawEditableRow(dc, width / 2, y, width - 40, rowHeight - 4, rowLabel(field), isCursor, isAdjustingThisField || isConfirmingDelete);
        }

        var hint = "SELECT  UP/DOWN  BACK";
        if (confirmDelete) {
            hint = "SELECT again to delete";
        } else if (adjusting) {
            hint = "UP/DOWN adjust, SELECT done";
        }
        dc.drawText(width / 2, height - 14, Gfx.FONT_XTINY, hint,
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
