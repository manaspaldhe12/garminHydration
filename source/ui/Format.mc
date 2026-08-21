// Small text-formatting helpers shared by views.
module Format {

    function pad2(n) {
        if (n < 10) {
            return "0" + n.toString();
        }
        return n.toString();
    }

    function hm(hour, minute) {
        return pad2(hour) + ":" + pad2(minute);
    }

    function amountText(ml) {
        return ml.toString() + " ml";
    }

    function onOff(enabled) {
        return enabled ? "ON" : "OFF";
    }

    function yesNo(value) {
        return value ? "Yes" : "No";
    }

    function daysLabel(mask) {
        if (mask == Days.ALL) {
            return "Every day";
        }
        if (mask == Days.WEEKDAYS) {
            return "Weekdays";
        }
        return "Custom";
    }

    const MONTH_ABBREVIATIONS = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    function monthAbbreviation(month) {
        return MONTH_ABBREVIATIONS[month - 1];
    }

    // dayStartEpoch must be a local-midnight epoch, e.g. from
    // Clock.startOfDayEpoch().
    function dayLabel(dayStartEpoch) {
        var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
        if (dayStartEpoch == todayStart) {
            return "Today";
        }
        if (dayStartEpoch == todayStart - 86400) {
            return "Yesterday";
        }
        var info = Clock.infoFor(dayStartEpoch);
        return monthAbbreviation(info.month) + " " + info.day.toString();
    }

}
