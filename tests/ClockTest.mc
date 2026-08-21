using Toybox.Test as Test;
using Toybox.Time.Gregorian as Gregorian;

(:test)
function testClockStartOfDayEpochZeroesTimeOfDay(logger) {
    var mid = Gregorian.moment({ :year => 2024, :month => 6, :day => 15, :hour => 14, :minute => 37, :second => 21 }).value();
    var dayStart = Clock.startOfDayEpoch(mid);
    var info = Clock.infoFor(dayStart);

    Test.assert(info.year == 2024);
    Test.assert(info.month == 6);
    Test.assert(info.day == 15);
    Test.assert(info.hour == 0);
    Test.assert(info.min == 0);
    return true;
}

(:test)
function testClockStartOfDayEpochIsIdempotent(logger) {
    var mid = Gregorian.moment({ :year => 2024, :month => 6, :day => 15, :hour => 14, :minute => 0, :second => 0 }).value();
    var once = Clock.startOfDayEpoch(mid);
    var twice = Clock.startOfDayEpoch(once);
    Test.assert(once == twice);
    return true;
}

(:test)
function testClockDayStartOffsetZeroReturnsSameDayMidnight(logger) {
    var mid = Gregorian.moment({ :year => 2024, :month => 6, :day => 15, :hour => 14, :minute => 0, :second => 0 }).value();
    var offsetZero = Clock.dayStartOffset(mid, 0);
    Test.assert(offsetZero == Clock.startOfDayEpoch(mid));
    return true;
}

(:test)
function testClockDayStartOffsetCrossesMonthBoundary(logger) {
    var jan31 = Gregorian.moment({ :year => 2024, :month => 1, :day => 31, :hour => 10, :minute => 0, :second => 0 }).value();
    var next = Clock.dayStartOffset(jan31, 1);
    var info = Clock.infoFor(next);

    Test.assert(info.year == 2024);
    Test.assert(info.month == 2);
    Test.assert(info.day == 1);
    return true;
}

(:test)
function testClockDayStartOffsetCrossesYearBoundary(logger) {
    var dec31 = Gregorian.moment({ :year => 2024, :month => 12, :day => 31, :hour => 10, :minute => 0, :second => 0 }).value();
    var next = Clock.dayStartOffset(dec31, 1);
    var info = Clock.infoFor(next);

    Test.assert(info.year == 2025);
    Test.assert(info.month == 1);
    Test.assert(info.day == 1);
    return true;
}

(:test)
function testClockDayStartOffsetHandlesLeapDay(logger) {
    // 2024 is a leap year, so Feb has 29 days.
    var feb28 = Gregorian.moment({ :year => 2024, :month => 2, :day => 28, :hour => 10, :minute => 0, :second => 0 }).value();
    var next = Clock.dayStartOffset(feb28, 1);
    var info = Clock.infoFor(next);

    Test.assert(info.year == 2024);
    Test.assert(info.month == 2);
    Test.assert(info.day == 29);
    return true;
}

(:test)
function testClockDayStartOffsetSkipsNonLeapFeb29(logger) {
    // 2023 is not a leap year, so Feb has 28 days.
    var feb28 = Gregorian.moment({ :year => 2023, :month => 2, :day => 28, :hour => 10, :minute => 0, :second => 0 }).value();
    var next = Clock.dayStartOffset(feb28, 1);
    var info = Clock.infoFor(next);

    Test.assert(info.year == 2023);
    Test.assert(info.month == 3);
    Test.assert(info.day == 1);
    return true;
}

(:test)
function testClockDayStartOffsetNegativeGoesBackward(logger) {
    var mar1 = Gregorian.moment({ :year => 2024, :month => 3, :day => 1, :hour => 10, :minute => 0, :second => 0 }).value();
    var prev = Clock.dayStartOffset(mar1, -1);
    var info = Clock.infoFor(prev);

    Test.assert(info.year == 2024);
    Test.assert(info.month == 2);
    Test.assert(info.day == 29); // leap year
    return true;
}

(:test)
function testClockDayStartOffsetRoundTripsBackAndForth(logger) {
    var start = Gregorian.moment({ :year => 2024, :month => 7, :day => 10, :hour => 9, :minute => 0, :second => 0 }).value();
    var dayStart = Clock.startOfDayEpoch(start);
    var forward = Clock.dayStartOffset(dayStart, 10);
    var back = Clock.dayStartOffset(forward, -10);
    Test.assert(back == dayStart);
    return true;
}
