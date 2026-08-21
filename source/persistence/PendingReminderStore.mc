using Toybox.Application.Storage as Storage;

// Tracks a reminder that has fired (from the background service) but
// has not yet been shown/dismissed in the foreground app.
module PendingReminderStore {

    const KEY = "pendingReminder";

    function setPending(reminderId, dueEpoch) {
        Storage.setValue(KEY, { "rid" => reminderId, "due" => dueEpoch });
    }

    function clear() {
        Storage.deleteValue(KEY);
    }

    function get() {
        return Storage.getValue(KEY);
    }

}
