using Toybox.Application.Storage as Storage;

// Tracks reminder(s) that have fired (from the background service)
// but have not yet been shown/dismissed in the foreground app. Holds
// a list of ids rather than a single id so two reminders firing at
// the same moment are both preserved instead of one silently
// overwriting the other.
module PendingReminderStore {

    const KEY = "pendingReminder";

    // A pending reminder older than this is treated as missed rather
    // than shown as a "DRINK WATER" alert - by the time the watch is
    // opened again it's no longer useful to interrupt with a stale
    // prompt for a time that's long past.
    const STALE_SECONDS = 6 * 60 * 60;

    function setPending(reminderIds, dueEpoch) {
        try {
            Storage.setValue(KEY, { "rids" => reminderIds, "due" => dueEpoch });
        } catch (ex) {
        }
    }

    function clear() {
        Storage.deleteValue(KEY);
    }

    function get() {
        var pending = Storage.getValue(KEY);
        if (pending == null || pending.get("due") == null) {
            return null;
        }
        return pending;
    }

    function isStale(pending) {
        return (Clock.nowEpoch() - pending.get("due")) > STALE_SECONDS;
    }

    // Reads a pending reminder, transparently discarding (and
    // clearing) it if it's stale. Callers should treat a null result
    // as "nothing to show".
    function getIfFresh() {
        var pending = get();
        if (pending == null) {
            return null;
        }
        if (isStale(pending)) {
            clear();
            return null;
        }
        return pending;
    }

}
