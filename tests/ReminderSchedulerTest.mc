using Toybox.Test as Test;

(:test)
function testFindNextOccurrenceReturnsNullWhenNoReminders(logger) {
    var result = ReminderScheduler.findNextOccurrence([], Clock.nowEpoch());
    Test.assert(result == null);
    return true;
}

(:test)
function testFindNextOccurrenceIgnoresDisabledReminders(logger) {
    var reminders = [ ReminderFactory.build(1, 8, 0, false, Days.ALL) ];
    var result = ReminderScheduler.findNextOccurrence(reminders, Clock.nowEpoch());
    Test.assert(result == null);
    return true;
}

(:test)
function testFindNextOccurrenceIgnoresInvalidReminders(logger) {
    var reminders = [ { "id" => 1, "hour" => 99, "min" => 0, "enabled" => true, "days" => Days.ALL } ];
    var result = ReminderScheduler.findNextOccurrence(reminders, Clock.nowEpoch());
    Test.assert(result == null);
    return true;
}

(:test)
function testFindNextOccurrenceFindsLaterTimeToday(logger) {
    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var fromEpoch = todayStart + (9 * 3600); // 09:00
    var reminders = [ ReminderFactory.build(1, 14, 0, true, Days.ALL) ]; // 14:00 today

    var result = ReminderScheduler.findNextOccurrence(reminders, fromEpoch);
    Test.assert(result != null);

    var info = Clock.infoFor(result.get("epoch"));
    Test.assert(info.hour == 14);
    Test.assert(info.min == 0);
    Test.assert(result.get("ids").size() == 1);
    Test.assert(result.get("ids")[0] == 1);
    return true;
}

(:test)
function testFindNextOccurrenceRollsOverToTomorrowWhenTimeHasPassed(logger) {
    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var fromEpoch = todayStart + (20 * 3600); // 20:00
    var reminders = [ ReminderFactory.build(1, 8, 0, true, Days.ALL) ]; // 08:00, already passed today

    var result = ReminderScheduler.findNextOccurrence(reminders, fromEpoch);
    Test.assert(result != null);

    var tomorrowStart = Clock.dayStartOffset(todayStart, 1);
    var expectedEpoch = tomorrowStart + (8 * 3600);
    Test.assert(result.get("epoch") == expectedEpoch);
    return true;
}

(:test)
function testFindNextOccurrenceTreatsExactCurrentMinuteAsAlreadyPassed(logger) {
    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var fromEpoch = todayStart + (8 * 3600); // exactly 08:00
    var reminders = [ ReminderFactory.build(1, 8, 0, true, Days.ALL) ];

    var result = ReminderScheduler.findNextOccurrence(reminders, fromEpoch);
    // occurrence must be strictly after fromEpoch, so this reminder
    // should roll to tomorrow rather than firing again immediately.
    var tomorrowStart = Clock.dayStartOffset(todayStart, 1);
    Test.assert(result.get("epoch") == tomorrowStart + (8 * 3600));
    return true;
}

(:test)
function testFindNextOccurrencePicksEarliestAcrossMultipleReminders(logger) {
    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var fromEpoch = todayStart + (1 * 3600); // 01:00
    var reminders = [
        ReminderFactory.build(1, 18, 0, true, Days.ALL),
        ReminderFactory.build(2, 8, 0, true, Days.ALL),
        ReminderFactory.build(3, 12, 0, true, Days.ALL)
    ];

    var result = ReminderScheduler.findNextOccurrence(reminders, fromEpoch);
    var info = Clock.infoFor(result.get("epoch"));
    Test.assert(info.hour == 8);
    Test.assert(result.get("ids").size() == 1);
    Test.assert(result.get("ids")[0] == 2);
    return true;
}

(:test)
function testFindNextOccurrenceCoalescesReminderIdsAtSameMoment(logger) {
    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var fromEpoch = todayStart + (1 * 3600);
    var reminders = [
        ReminderFactory.build(1, 8, 0, true, Days.ALL),
        ReminderFactory.build(2, 8, 0, true, Days.ALL),
        ReminderFactory.build(3, 9, 0, true, Days.ALL)
    ];

    var result = ReminderScheduler.findNextOccurrence(reminders, fromEpoch);
    var ids = result.get("ids");
    Test.assert(ids.size() == 2);
    Test.assert((ids[0] == 1 && ids[1] == 2) || (ids[0] == 2 && ids[1] == 1));
    return true;
}

(:test)
function testFindNextOccurrenceSkipsWeekendForWeekdaysOnlyReminder(logger) {
    // Walk forward from "now" to the next Saturday, so the test is
    // correct regardless of what day it's actually run on.
    var epoch = Clock.nowEpoch();
    var info = Clock.infoFor(epoch);
    var deltaToSaturday = (7 - info.day_of_week + 7) % 7;
    var saturdayStart = Clock.dayStartOffset(Clock.startOfDayEpoch(epoch), deltaToSaturday);
    var fromEpoch = saturdayStart + (10 * 3600); // Saturday 10:00

    var reminders = [ ReminderFactory.build(1, 12, 0, true, Days.WEEKDAYS) ];
    var result = ReminderScheduler.findNextOccurrence(reminders, fromEpoch);
    Test.assert(result != null);

    var resultInfo = Clock.infoFor(result.get("epoch"));
    Test.assert(resultInfo.day_of_week == 2); // Monday
    Test.assert(resultInfo.hour == 12);
    return true;
}

(:test)
function testFindNextOccurrenceHonorsSingleDayMask(logger) {
    // A reminder restricted to today only should not resurface
    // tomorrow.
    var epoch = Clock.nowEpoch();
    var todayStart = Clock.startOfDayEpoch(epoch);
    var info = Clock.infoFor(todayStart);
    var todayBit = Days.bitFor(info.day_of_week);

    var fromEpoch = todayStart; // start of today, before any reminder time
    var reminders = [ ReminderFactory.build(1, 23, 0, true, todayBit) ];

    var result = ReminderScheduler.findNextOccurrence(reminders, fromEpoch);
    Test.assert(result != null);

    var resultInfo = Clock.infoFor(result.get("epoch"));
    Test.assert(resultInfo.day == info.day);
    Test.assert(resultInfo.hour == 23);
    return true;
}
