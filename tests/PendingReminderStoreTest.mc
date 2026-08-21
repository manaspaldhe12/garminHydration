using Toybox.Test as Test;

(:test)
function testPendingReminderStoreSetGetClear(logger) {
    PendingReminderStore.clear();
    Test.assert(PendingReminderStore.get() == null);

    var now = Clock.nowEpoch();
    PendingReminderStore.setPending([1, 2], now);

    var pending = PendingReminderStore.get();
    Test.assert(pending != null);
    Test.assert(pending.get("rids").size() == 2);
    Test.assert(pending.get("due") == now);

    PendingReminderStore.clear();
    Test.assert(PendingReminderStore.get() == null);
    return true;
}

(:test)
function testPendingReminderStoreIsStaleThreshold(logger) {
    var now = Clock.nowEpoch();

    var fresh = { "rids" => [1], "due" => now - 60 };
    Test.assert(!PendingReminderStore.isStale(fresh));

    var stale = { "rids" => [1], "due" => now - (7 * 3600) };
    Test.assert(PendingReminderStore.isStale(stale));
    return true;
}

(:test)
function testPendingReminderStoreGetIfFreshClearsStaleEntry(logger) {
    var now = Clock.nowEpoch();
    PendingReminderStore.setPending([1], now - (7 * 3600));

    var result = PendingReminderStore.getIfFresh();
    Test.assert(result == null);
    Test.assert(PendingReminderStore.get() == null); // cleared as a side effect

    PendingReminderStore.clear();
    return true;
}

(:test)
function testPendingReminderStoreGetIfFreshKeepsFreshEntry(logger) {
    var now = Clock.nowEpoch();
    PendingReminderStore.setPending([1], now);

    var result = PendingReminderStore.getIfFresh();
    Test.assert(result != null);
    Test.assert(result.get("rids").size() == 1);

    PendingReminderStore.clear();
    return true;
}
