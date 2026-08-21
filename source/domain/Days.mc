// Bitmask helpers for "days of week" reminder scheduling.
// Bit position matches Toybox.Time.Gregorian's day_of_week (1 = Sunday .. 7 = Saturday).
module Days {

    const SUN = 0x01;
    const MON = 0x02;
    const TUE = 0x04;
    const WED = 0x08;
    const THU = 0x10;
    const FRI = 0x20;
    const SAT = 0x40;

    const ALL = 0x7F;
    const WEEKDAYS = MON | TUE | WED | THU | FRI;

    function bitFor(dayOfWeek) {
        return 1 << (dayOfWeek - 1);
    }

    function isSet(mask, dayOfWeek) {
        return (mask & bitFor(dayOfWeek)) != 0;
    }

}
