using Toybox.Test as Test;
using Toybox.Application.Storage as Storage;

(:test)
function testEventStoreAddAssignsUniqueIncrementingIds(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);

    var now = Clock.nowEpoch();
    var e1 = EventStore.add(now - 7200, 250, true, null);
    var e2 = EventStore.add(now - 3600, 350, false, null);

    Test.assert(e1.get("id") != e2.get("id"));
    Test.assert(e2.get("id") > e1.get("id"));

    var all = EventStore.load();
    Test.assert(all.size() == 2);

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    return true;
}

(:test)
function testEventStoreAddPreservesFields(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);

    var now = Clock.nowEpoch();
    var event = EventStore.add(now, 500, true, 7);

    Test.assert(event.get("ts") == now);
    Test.assert(event.get("amt") == 500);
    Test.assert(event.get("elec") == true);
    Test.assert(event.get("rid") == 7);

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    return true;
}

(:test)
function testEventStoreEventsBetweenFiltersByRange(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);

    var now = Clock.nowEpoch();
    EventStore.add(now - 7200, 250, true, null); // outside window
    EventStore.add(now - 1800, 350, false, null); // inside window

    var results = EventStore.eventsBetween(now - 3600, now);
    Test.assert(results.size() == 1);
    Test.assert(results[0].get("amt") == 350);

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    return true;
}

(:test)
function testEventStoreLoadFiltersInvalidEntries(logger) {
    Storage.deleteValue(EventStore.KEY);

    var now = Clock.nowEpoch();
    Storage.setValue(EventStore.KEY, [
        HydrationEvents.build(1, now, 250, true, null),
        { "id" => 2 }, // missing required fields
        null
    ]);

    var loaded = EventStore.load();
    Test.assert(loaded.size() == 1);
    Test.assert(loaded[0].get("id") == 1);

    Storage.deleteValue(EventStore.KEY);
    return true;
}

(:test)
function testEventStoreLoadHandlesMissingKey(logger) {
    Storage.deleteValue(EventStore.KEY);
    var loaded = EventStore.load();
    Test.assert(loaded.size() == 0);
    return true;
}

(:test)
function testEventStoreNextIdGuardsAgainstResetCounter(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);

    var now = Clock.nowEpoch();
    Storage.setValue(EventStore.KEY, [ HydrationEvents.build(50, now, 250, true, null) ]);
    Storage.setValue(EventStore.NEXT_ID_KEY, 1); // simulates a corrupted/reset counter

    var id = EventStore.nextId();
    Test.assert(id > 50);

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    return true;
}

(:test)
function testEventStorePrunesEventsOlderThanRetentionWindow(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);

    var now = Clock.nowEpoch();
    var oldTs = now - ((EventStore.RETENTION_DAYS + 5) * 86400);
    var recentTs = now - 3600;

    Storage.setValue(EventStore.KEY, [
        HydrationEvents.build(1, oldTs, 250, true, null),
        HydrationEvents.build(2, recentTs, 250, true, null)
    ]);
    Storage.setValue(EventStore.NEXT_ID_KEY, 3);

    // Any add() runs prune() as a side effect.
    EventStore.add(now, 100, false, null);

    var all = EventStore.load();
    var stillHasOldEvent = false;
    for (var i = 0; i < all.size(); i += 1) {
        if (all[i].get("id") == 1) {
            stillHasOldEvent = true;
        }
    }

    Test.assert(!stillHasOldEvent);
    Test.assert(all.size() == 2); // the recent seed event + the newly added one

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    return true;
}

(:test)
function testEventStoreKeepsEventsInsideRetentionWindow(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);

    var now = Clock.nowEpoch();
    var withinWindowTs = now - ((EventStore.RETENTION_DAYS - 1) * 86400);

    EventStore.add(withinWindowTs, 250, true, null);
    var all = EventStore.load();
    Test.assert(all.size() == 1);

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    return true;
}
