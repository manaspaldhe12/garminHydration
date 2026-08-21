using Toybox.Test as Test;

(:test)
function testReminderFactoryBuildProducesExpectedFields(logger) {
    var r = ReminderFactory.build(5, 14, 30, true, Days.ALL);
    Test.assert(r.get("id") == 5);
    Test.assert(r.get("hour") == 14);
    Test.assert(r.get("min") == 30);
    Test.assert(r.get("enabled") == true);
    Test.assert(r.get("days") == Days.ALL);
    return true;
}

(:test)
function testReminderFactoryDefaultsHasSixDailyEnabledReminders(logger) {
    var defaults = ReminderFactory.defaults();
    Test.assert(defaults.size() == 6);
    for (var i = 0; i < defaults.size(); i += 1) {
        Test.assert(defaults[i].get("enabled") == true);
        Test.assert(defaults[i].get("days") == Days.ALL);
        Test.assert(ReminderFactory.isValid(defaults[i]));
    }
    return true;
}

(:test)
function testReminderFactoryDefaultsCoverExpectedHours(logger) {
    var defaults = ReminderFactory.defaults();
    var hours = [];
    for (var i = 0; i < defaults.size(); i += 1) {
        hours.add(defaults[i].get("hour"));
    }
    Test.assert(hours.indexOf(8) >= 0);
    Test.assert(hours.indexOf(10) >= 0);
    Test.assert(hours.indexOf(12) >= 0);
    Test.assert(hours.indexOf(14) >= 0);
    Test.assert(hours.indexOf(16) >= 0);
    Test.assert(hours.indexOf(18) >= 0);
    return true;
}

(:test)
function testReminderFactoryIsValidAcceptsWellFormedReminder(logger) {
    Test.assert(ReminderFactory.isValid(ReminderFactory.build(1, 8, 0, true, Days.ALL)));
    Test.assert(ReminderFactory.isValid(ReminderFactory.build(1, 0, 0, false, Days.WEEKDAYS)));
    Test.assert(ReminderFactory.isValid(ReminderFactory.build(1, 23, 59, true, Days.SAT)));
    return true;
}

(:test)
function testReminderFactoryIsValidRejectsMissingReminderOrFields(logger) {
    Test.assert(!ReminderFactory.isValid(null));
    Test.assert(!ReminderFactory.isValid({ "id" => 1 }));
    Test.assert(!ReminderFactory.isValid({ "id" => 1, "hour" => 8, "min" => 0, "enabled" => true }));
    return true;
}

(:test)
function testReminderFactoryIsValidRejectsOutOfRangeHour(logger) {
    Test.assert(!ReminderFactory.isValid(ReminderFactory.build(1, 24, 0, true, Days.ALL)));
    Test.assert(!ReminderFactory.isValid(ReminderFactory.build(1, -1, 0, true, Days.ALL)));
    return true;
}

(:test)
function testReminderFactoryIsValidRejectsOutOfRangeMinute(logger) {
    Test.assert(!ReminderFactory.isValid(ReminderFactory.build(1, 8, 60, true, Days.ALL)));
    Test.assert(!ReminderFactory.isValid(ReminderFactory.build(1, 8, -1, true, Days.ALL)));
    return true;
}

(:test)
function testReminderFactoryIsValidRejectsInvalidDaysMask(logger) {
    Test.assert(!ReminderFactory.isValid(ReminderFactory.build(1, 8, 0, true, 0)));
    Test.assert(!ReminderFactory.isValid(ReminderFactory.build(1, 8, 0, true, Days.ALL + 1)));
    return true;
}
