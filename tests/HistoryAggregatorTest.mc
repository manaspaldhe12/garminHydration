using Toybox.Test as Test;
using Toybox.Application.Storage as Storage;

(:test)
function testHistoryAggregatorGroupsEventsByDay(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);

    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var yesterdayStart = Clock.dayStartOffset(todayStart, -1);

    EventStore.add(todayStart + 3600, 250, true, null);
    EventStore.add(todayStart + 7200, 350, false, null);
    EventStore.add(yesterdayStart + 3600, 500, true, null);

    var days = HistoryAggregator.dailyTotals(3);

    Test.assert(days.size() == 3);

    Test.assert(days[0].get("dayStart") == todayStart);
    Test.assert(days[0].get("total") == 600);
    Test.assert(days[0].get("withElectrolytes") == 250);
    Test.assert(days[0].get("withoutElectrolytes") == 350);
    Test.assert(days[0].get("count") == 2);

    Test.assert(days[1].get("dayStart") == yesterdayStart);
    Test.assert(days[1].get("total") == 500);
    Test.assert(days[1].get("count") == 1);

    Test.assert(days[2].get("total") == 0);
    Test.assert(days[2].get("count") == 0);

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    return true;
}

(:test)
function testHistoryAggregatorEventsForDayMatchesOnlyThatDay(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);

    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var yesterdayStart = Clock.dayStartOffset(todayStart, -1);

    EventStore.add(todayStart + 100, 250, true, null);
    EventStore.add(yesterdayStart + 100, 500, false, null);

    var todaysEvents = HistoryAggregator.eventsForDay(todayStart);
    Test.assert(todaysEvents.size() == 1);
    Test.assert(todaysEvents[0].get("amt") == 250);

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    return true;
}
