using Toybox.Test as Test;

(:test)
function testFormatPad2AddsLeadingZeroBelowTen(logger) {
    Test.assert(Format.pad2(0).equals("00"));
    Test.assert(Format.pad2(5).equals("05"));
    Test.assert(Format.pad2(9).equals("09"));
    return true;
}

(:test)
function testFormatPad2LeavesTwoDigitValuesAlone(logger) {
    Test.assert(Format.pad2(10).equals("10"));
    Test.assert(Format.pad2(59).equals("59"));
    return true;
}

(:test)
function testFormatHmCombinesHourAndMinute(logger) {
    Test.assert(Format.hm(8, 5).equals("08:05"));
    Test.assert(Format.hm(0, 0).equals("00:00"));
    Test.assert(Format.hm(23, 59).equals("23:59"));
    return true;
}

(:test)
function testFormatAmountText(logger) {
    Test.assert(Format.amountText(250).equals("250 ml"));
    Test.assert(Format.amountText(0).equals("0 ml"));
    return true;
}

(:test)
function testFormatOnOff(logger) {
    Test.assert(Format.onOff(true).equals("ON"));
    Test.assert(Format.onOff(false).equals("OFF"));
    return true;
}

(:test)
function testFormatYesNo(logger) {
    Test.assert(Format.yesNo(true).equals("Yes"));
    Test.assert(Format.yesNo(false).equals("No"));
    return true;
}

(:test)
function testFormatDaysLabelRecognizesPresets(logger) {
    Test.assert(Format.daysLabel(Days.ALL).equals("Every day"));
    Test.assert(Format.daysLabel(Days.WEEKDAYS).equals("Weekdays"));
    return true;
}

(:test)
function testFormatDaysLabelFallsBackToCustom(logger) {
    Test.assert(Format.daysLabel(Days.SUN | Days.MON).equals("Custom"));
    return true;
}

(:test)
function testFormatMonthAbbreviationCoversFullYear(logger) {
    Test.assert(Format.monthAbbreviation(1).equals("Jan"));
    Test.assert(Format.monthAbbreviation(6).equals("Jun"));
    Test.assert(Format.monthAbbreviation(12).equals("Dec"));
    return true;
}

(:test)
function testFormatDayLabelToday(logger) {
    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    Test.assert(Format.dayLabel(todayStart).equals("Today"));
    return true;
}

(:test)
function testFormatDayLabelYesterday(logger) {
    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var yesterdayStart = Clock.dayStartOffset(todayStart, -1);
    Test.assert(Format.dayLabel(yesterdayStart).equals("Yesterday"));
    return true;
}

(:test)
function testFormatDayLabelOlderDateUsesMonthAndDay(logger) {
    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var olderStart = Clock.dayStartOffset(todayStart, -5);
    var info = Clock.infoFor(olderStart);
    var expected = Format.monthAbbreviation(info.month) + " " + info.day.toString();
    Test.assert(Format.dayLabel(olderStart).equals(expected));
    return true;
}
