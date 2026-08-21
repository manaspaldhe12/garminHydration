using Toybox.Test as Test;

(:test)
function testDaysBitForMapsSundayThroughSaturday(logger) {
    Test.assert(Days.bitFor(1) == Days.SUN);
    Test.assert(Days.bitFor(2) == Days.MON);
    Test.assert(Days.bitFor(3) == Days.TUE);
    Test.assert(Days.bitFor(4) == Days.WED);
    Test.assert(Days.bitFor(5) == Days.THU);
    Test.assert(Days.bitFor(6) == Days.FRI);
    Test.assert(Days.bitFor(7) == Days.SAT);
    return true;
}

(:test)
function testDaysAllIncludesEveryBit(logger) {
    var combined = Days.SUN | Days.MON | Days.TUE | Days.WED | Days.THU | Days.FRI | Days.SAT;
    Test.assert(Days.ALL == combined);
    return true;
}

(:test)
function testDaysWeekdaysExcludesWeekend(logger) {
    Test.assert(!Days.isSet(Days.WEEKDAYS, 1)); // Sunday
    Test.assert(!Days.isSet(Days.WEEKDAYS, 7)); // Saturday
    Test.assert(Days.isSet(Days.WEEKDAYS, 2)); // Monday
    Test.assert(Days.isSet(Days.WEEKDAYS, 3)); // Tuesday
    Test.assert(Days.isSet(Days.WEEKDAYS, 4)); // Wednesday
    Test.assert(Days.isSet(Days.WEEKDAYS, 5)); // Thursday
    Test.assert(Days.isSet(Days.WEEKDAYS, 6)); // Friday
    return true;
}

(:test)
function testDaysIsSetChecksAllMask(logger) {
    for (var dow = 1; dow <= 7; dow += 1) {
        Test.assert(Days.isSet(Days.ALL, dow));
    }
    return true;
}
