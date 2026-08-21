using Toybox.Test as Test;

(:test)
function testHydrationEventsBuildProducesExpectedFields(logger) {
    var e = HydrationEvents.build(1, 1000, 250, true, 3);
    Test.assert(e.get("id") == 1);
    Test.assert(e.get("ts") == 1000);
    Test.assert(e.get("amt") == 250);
    Test.assert(e.get("elec") == true);
    Test.assert(e.get("rid") == 3);
    return true;
}

(:test)
function testHydrationEventsBuildAllowsNullReminderId(logger) {
    var e = HydrationEvents.build(1, 1000, 250, false, null);
    Test.assert(e.get("rid") == null);
    return true;
}

(:test)
function testHydrationEventsTotalAmountSumsAllEvents(logger) {
    var events = [
        HydrationEvents.build(1, 0, 250, true, null),
        HydrationEvents.build(2, 0, 350, false, null),
        HydrationEvents.build(3, 0, 0, true, null)
    ];
    Test.assert(HydrationEvents.totalAmount(events) == 600);
    return true;
}

(:test)
function testHydrationEventsTotalAmountEmptyListIsZero(logger) {
    Test.assert(HydrationEvents.totalAmount([]) == 0);
    return true;
}

(:test)
function testHydrationEventsTotalByElectrolytesSplitsCorrectly(logger) {
    var events = [
        HydrationEvents.build(1, 0, 250, true, null),
        HydrationEvents.build(2, 0, 350, false, null),
        HydrationEvents.build(3, 0, 500, true, null)
    ];
    Test.assert(HydrationEvents.totalByElectrolytes(events, true) == 750);
    Test.assert(HydrationEvents.totalByElectrolytes(events, false) == 350);
    return true;
}

(:test)
function testHydrationEventsTotalByElectrolytesEmptyListIsZero(logger) {
    Test.assert(HydrationEvents.totalByElectrolytes([], true) == 0);
    Test.assert(HydrationEvents.totalByElectrolytes([], false) == 0);
    return true;
}
