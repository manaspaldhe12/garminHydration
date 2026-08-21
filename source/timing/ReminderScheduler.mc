using Toybox.Application.Storage as Storage;
using Toybox.Background as Background;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;

// Computes the next due reminder occurrence and keeps a single
// background temporal event registered for it. The background
// service delegate re-calls scheduleNext() after each firing so only
// one wakeup is ever pending at a time.
module ReminderScheduler {

    const SCHEDULED_ID_KEY = "scheduledReminderId";
    const LOOKAHEAD_DAYS = 8;

    // Finds the soonest enabled reminder occurrence strictly after
    // fromEpoch, scanning at most LOOKAHEAD_DAYS days ahead so a
    // reminder configured for a single day of the week is still found.
    function findNextOccurrence(reminders, fromEpoch) {
        var bestEpoch = null;
        var bestId = null;

        for (var d = 0; d < LOOKAHEAD_DAYS; d += 1) {
            var dayEpoch = fromEpoch + (d * 86400);
            var info = Clock.infoFor(dayEpoch);
            var bit = Days.bitFor(info.day_of_week);

            for (var i = 0; i < reminders.size(); i += 1) {
                var reminder = reminders[i];
                if (!reminder.get("enabled")) {
                    continue;
                }
                if ((reminder.get("days") & bit) == 0) {
                    continue;
                }

                var occurrence = Gregorian.moment({
                    :year => info.year,
                    :month => info.month,
                    :day => info.day,
                    :hour => reminder.get("hour"),
                    :minute => reminder.get("min"),
                    :second => 0
                }).value();

                if (occurrence > fromEpoch && (bestEpoch == null || occurrence < bestEpoch)) {
                    bestEpoch = occurrence;
                    bestId = reminder.get("id");
                }
            }

            // Any occurrence found on an earlier day is guaranteed to
            // be sooner than one on a later day, so once we have a
            // match there's no need to keep scanning ahead.
            if (bestEpoch != null) {
                break;
            }
        }

        if (bestEpoch == null) {
            return null;
        }
        return { "id" => bestId, "epoch" => bestEpoch };
    }

    function scheduleNext() {
        var reminders = ReminderStore.load();
        var next = findNextOccurrence(reminders, Clock.nowEpoch());

        try {
            if (next != null) {
                Storage.setValue(SCHEDULED_ID_KEY, next.get("id"));
                Background.registerForTemporalEvent(new Time.Moment(next.get("epoch")));
            } else {
                Storage.deleteValue(SCHEDULED_ID_KEY);
                if (Background has :deleteTemporalEvent) {
                    Background.deleteTemporalEvent();
                }
            }
        } catch (ex) {
            // Background registration can be unavailable in some
            // simulator/runtime configurations; reminders still work
            // while the app is open via the foreground poll in
            // HydrationMainView.
        }
    }

    function scheduledReminderId() {
        return Storage.getValue(SCHEDULED_ID_KEY);
    }

}
