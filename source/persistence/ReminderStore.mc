using Toybox.Application.Storage as Storage;

// Persists the reminder list. Seeds the hard-coded v0.1 defaults on
// first run, and self-heals if stored data is missing or corrupt.
module ReminderStore {

    const KEY = "reminders";
    const NEXT_ID_KEY = "nextReminderId";

    function load() {
        try {
            var reminders = Storage.getValue(KEY);
            if (reminders == null) {
                var seeded = ReminderFactory.defaults();
                Storage.setValue(KEY, seeded);
                Storage.setValue(NEXT_ID_KEY, seeded.size() + 1);
                return seeded;
            }

            var valid = [];
            for (var i = 0; i < reminders.size(); i += 1) {
                if (ReminderFactory.isValid(reminders[i])) {
                    valid.add(reminders[i]);
                }
            }

            // Only fall back to defaults if every stored reminder was
            // corrupt - an intentionally empty list (user deleted
            // them all) must stay empty.
            if (valid.size() == 0 && reminders.size() > 0) {
                valid = ReminderFactory.defaults();
                Storage.setValue(KEY, valid);
            }

            return valid;
        } catch (ex) {
            var defaults = ReminderFactory.defaults();
            Storage.setValue(KEY, defaults);
            return defaults;
        }
    }

    function save(reminders) {
        try {
            Storage.setValue(KEY, reminders);
        } catch (ex) {
        }
    }

    function nextId() {
        var candidate = Storage.getValue(NEXT_ID_KEY);
        if (candidate == null) {
            candidate = 1;
        }

        var reminders = load();
        for (var i = 0; i < reminders.size(); i += 1) {
            var existingId = reminders[i].get("id");
            if (existingId != null && existingId >= candidate) {
                candidate = existingId + 1;
            }
        }

        Storage.setValue(NEXT_ID_KEY, candidate + 1);
        return candidate;
    }

}
