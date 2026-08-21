using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;

// Small wrapper around Toybox time APIs so the rest of the app deals
// in plain epoch-second Numbers (which are what get persisted).
module Clock {

    function nowEpoch() {
        return Time.now().value();
    }

    function infoFor(epoch) {
        return Gregorian.info(new Time.Moment(epoch), Time.FORMAT_SHORT);
    }

    function startOfDayEpoch(epoch) {
        return dayStartOffset(epoch, 0);
    }

    // Local midnight of (the calendar day containing epoch) + days.
    // Built from calendar fields (via Gregorian.moment's normalization
    // of out-of-range day values) rather than epoch + days*86400, so
    // it stays correct across month/year rollovers and DST transitions
    // (where a local day isn't exactly 86400 seconds).
    function dayStartOffset(epoch, days) {
        var info = infoFor(epoch);
        var moment = Gregorian.moment({
            :year => info.year,
            :month => info.month,
            :day => info.day + days,
            :hour => 0,
            :minute => 0,
            :second => 0
        });
        return moment.value();
    }

}
