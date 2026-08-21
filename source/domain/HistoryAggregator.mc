// Computes per-day hydration totals from the raw event log, most
// recent day first (today is always index 0).
module HistoryAggregator {

    const DEFAULT_DAYS = 14;

    function dailyTotals(numDays) {
        var events = EventStore.load();
        var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
        var result = [];

        for (var d = 0; d < numDays; d += 1) {
            var dayStart = todayStart - (d * 86400);
            var dayEnd = dayStart + 86400;
            var dayEvents = [];

            for (var i = 0; i < events.size(); i += 1) {
                var ts = events[i].get("ts");
                if (ts >= dayStart && ts < dayEnd) {
                    dayEvents.add(events[i]);
                }
            }

            result.add({
                "dayStart" => dayStart,
                "total" => HydrationEvents.totalAmount(dayEvents),
                "withElectrolytes" => HydrationEvents.totalByElectrolytes(dayEvents, true),
                "withoutElectrolytes" => HydrationEvents.totalByElectrolytes(dayEvents, false),
                "count" => dayEvents.size()
            });
        }

        return result;
    }

    function eventsForDay(dayStartEpoch) {
        return EventStore.eventsBetween(dayStartEpoch, dayStartEpoch + 86400);
    }

}
