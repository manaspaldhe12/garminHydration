// Builds reminder value objects (plain Dictionaries so they can be
// stored directly with Application.Storage) and the hard-coded v0.1
// defaults from goals.md.
module ReminderFactory {

    function build(id, hour, minute, enabled, days) {
        return {
            "id" => id,
            "hour" => hour,
            "min" => minute,
            "enabled" => enabled,
            "days" => days
        };
    }

    function defaults() {
        return [
            build(1, 8, 0, true, Days.ALL),
            build(2, 10, 0, true, Days.ALL),
            build(3, 12, 0, true, Days.ALL),
            build(4, 14, 0, true, Days.ALL),
            build(5, 16, 0, true, Days.ALL),
            build(6, 18, 0, true, Days.ALL)
        ];
    }

    // Guards against corrupted/partial storage (e.g. from an
    // interrupted write or a future format change) producing a
    // reminder with a missing or out-of-range field.
    function isValid(reminder) {
        if (reminder == null) {
            return false;
        }

        var id = reminder.get("id");
        var hour = reminder.get("hour");
        var minute = reminder.get("min");
        var enabled = reminder.get("enabled");
        var days = reminder.get("days");

        if (id == null || hour == null || minute == null || enabled == null || days == null) {
            return false;
        }
        if (hour < 0 || hour > 23) {
            return false;
        }
        if (minute < 0 || minute > 59) {
            return false;
        }
        if (days <= 0 || days > Days.ALL) {
            return false;
        }
        return true;
    }

}
