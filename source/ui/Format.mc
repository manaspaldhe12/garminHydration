using Toybox.Graphics as Gfx;

// Small text-formatting/drawing helpers shared by views.
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
        if (dayStartEpoch == Clock.dayStartOffset(todayStart, -1)) {
            return "Yesterday";
        }
        var info = Clock.infoFor(dayStartEpoch);
        return monthAbbreviation(info.month) + " " + info.day.toString();
    }

    // Draws one row of a selectable list, highlighting it with a
    // filled rounded rectangle when selected instead of relying only
    // on a "> " text prefix, so the current selection reads clearly
    // at a glance.
    function drawMenuRow(dc, centerX, y, rowWidth, rowHeight, text, selected) {
        if (selected) {
            dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(centerX - (rowWidth / 2), y - (rowHeight / 2), rowWidth, rowHeight, 6);
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_DK_BLUE);
        } else {
            dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        }

        dc.drawText(centerX, y, Gfx.FONT_XTINY, text,
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

    // Same as drawMenuRow, but with a distinct highlight color for a
    // row that's actively being edited (value changes with UP/DOWN)
    // rather than merely selected, so the two modes are visibly
    // different instead of both showing as "> selected".
    function drawEditableRow(dc, centerX, y, rowWidth, rowHeight, text, selected, editing) {
        if (editing) {
            dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(centerX - (rowWidth / 2), y - (rowHeight / 2), rowWidth, rowHeight, 6);
            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_ORANGE);
            dc.drawText(centerX, y, Gfx.FONT_XTINY, text,
                Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        } else {
            drawMenuRow(dc, centerX, y, rowWidth, rowHeight, text, selected);
        }
    }

}
