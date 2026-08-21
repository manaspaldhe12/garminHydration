using Toybox.Application.Storage as Storage;
using Toybox.Background as Background;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;

// Computes the next due reminder occurrence(s) and keeps a single
// background temporal event registered for it. The background
// service delegate re-calls scheduleNext() after each firing so only
// one wakeup is ever pending at a time.
module ReminderScheduler {

    const SCHEDULED_IDS_KEY = "scheduledReminderIds";
    const LOOKAHEAD_DAYS = 8;

    // Finds the soonest enabled reminder occurrence strictly after
    // fromEpoch, scanning at most LOOKAHEAD_DAYS calendar days ahead
    // so a reminder configured for a single day of the week is still
    // found. If more than one reminder is due at exactly the same
    // moment, all of their ids are returned together rather than
    // silently dropping all but one.
    function findNextOccurrence(reminders, fromEpoch) {
        var bestEpoch = null;
        var bestIds = [];
        var todayStart = Clock.startOfDayEpoch(fromEpoch);

        for (var d = 0; d < LOOKAHEAD_DAYS; d += 1) {
            var dayStart = Clock.dayStartOffset(todayStart, d);
            var info = Clock.infoFor(dayStart);
            var bit = Days.bitFor(info.day_of_week);

            for (var i = 0; i < reminders.size(); i += 1) {
                var reminder = reminders[i];
                if (!ReminderFactory.isValid(reminder)) {
                    continue;
                }
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

                if (occurrence <= fromEpoch) {
                    continue;
                }

                if (bestEpoch == null || occurrence < bestEpoch) {
                    bestEpoch = occurrence;
                    bestIds = [ reminder.get("id") ];
                } else if (occurrence == bestEpoch) {
                    bestIds.add(reminder.get("id"));
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
        return { "ids" => bestIds, "epoch" => bestEpoch };
    }

    function scheduleNext() {
        var reminders = ReminderStore.load();
        var next = findNextOccurrence(reminders, Clock.nowEpoch());

        try {
            if (next != null) {
                Storage.setValue(SCHEDULED_IDS_KEY, next.get("ids"));
                Background.registerForTemporalEvent(new Time.Moment(next.get("epoch")));
            } else {
                Storage.deleteValue(SCHEDULED_IDS_KEY);
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

    function scheduledReminderIds() {
        var ids = Storage.getValue(SCHEDULED_IDS_KEY);
        if (ids == null) {
            return [];
        }
        return ids;
    }

}
