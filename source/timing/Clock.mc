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
        var info = infoFor(epoch);
        var midnight = Gregorian.moment({
            :year => info.year,
            :month => info.month,
            :day => info.day,
            :hour => 0,
            :minute => 0,
            :second => 0
        });
        return midnight.value();
    }

}
