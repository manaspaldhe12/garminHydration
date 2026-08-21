using Toybox.Application.Storage as Storage;

// Persists the reminder list. Seeds the hard-coded v0.1 defaults on
// first run.
module ReminderStore {

    const KEY = "reminders";
    const NEXT_ID_KEY = "nextReminderId";

    function load() {
        var reminders = Storage.getValue(KEY);
        if (reminders == null) {
            reminders = ReminderFactory.defaults();
            Storage.setValue(KEY, reminders);
            Storage.setValue(NEXT_ID_KEY, reminders.size() + 1);
        }
        return reminders;
    }

    function save(reminders) {
        Storage.setValue(KEY, reminders);
    }

    function nextId() {
        var id = Storage.getValue(NEXT_ID_KEY);
        if (id == null) {
            id = 1;
        }
        Storage.setValue(NEXT_ID_KEY, id + 1);
        return id;
    }

}
