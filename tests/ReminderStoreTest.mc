using Toybox.Test as Test;
using Toybox.Application.Storage as Storage;

(:test)
function testReminderStoreSeedsDefaultsWhenMissing(logger) {
    Storage.deleteValue(ReminderStore.KEY);
    Storage.deleteValue(ReminderStore.NEXT_ID_KEY);

    var loaded = ReminderStore.load();
    Test.assert(loaded.size() == 6);

    Storage.deleteValue(ReminderStore.KEY);
    Storage.deleteValue(ReminderStore.NEXT_ID_KEY);
    return true;
}

(:test)
function testReminderStoreKeepsIntentionallyEmptyList(logger) {
    Storage.setValue(ReminderStore.KEY, []);

    var loaded = ReminderStore.load();
    Test.assert(loaded.size() == 0);

    Storage.deleteValue(ReminderStore.KEY);
    return true;
}

(:test)
function testReminderStoreFiltersInvalidEntriesButKeepsValidOnes(logger) {
    Storage.setValue(ReminderStore.KEY, [
        ReminderFactory.build(1, 8, 0, true, Days.ALL),
        { "id" => 2, "hour" => 99, "min" => 0, "enabled" => true, "days" => Days.ALL } // invalid hour
    ]);

    var loaded = ReminderStore.load();
    Test.assert(loaded.size() == 1);
    Test.assert(loaded[0].get("id") == 1);

    Storage.deleteValue(ReminderStore.KEY);
    return true;
}

(:test)
function testReminderStoreResetsToDefaultsWhenEveryEntryIsCorrupt(logger) {
    Storage.setValue(ReminderStore.KEY, [
        { "id" => 1, "hour" => 99, "min" => 0, "enabled" => true, "days" => Days.ALL }
    ]);

    var loaded = ReminderStore.load();
    Test.assert(loaded.size() == 6); // fell back to defaults rather than staying corrupt

    Storage.deleteValue(ReminderStore.KEY);
    Storage.deleteValue(ReminderStore.NEXT_ID_KEY);
    return true;
}

(:test)
function testReminderStoreSaveAndReloadRoundTrips(logger) {
    Storage.deleteValue(ReminderStore.KEY);

    var reminders = [ ReminderFactory.build(1, 9, 15, false, Days.WEEKDAYS) ];
    ReminderStore.save(reminders);

    var loaded = ReminderStore.load();
    Test.assert(loaded.size() == 1);
    Test.assert(loaded[0].get("hour") == 9);
    Test.assert(loaded[0].get("min") == 15);
    Test.assert(loaded[0].get("enabled") == false);
    Test.assert(loaded[0].get("days") == Days.WEEKDAYS);

    Storage.deleteValue(ReminderStore.KEY);
    return true;
}

(:test)
function testReminderStoreNextIdGuardsAgainstResetCounter(logger) {
    Storage.setValue(ReminderStore.KEY, [ ReminderFactory.build(20, 8, 0, true, Days.ALL) ]);
    Storage.setValue(ReminderStore.NEXT_ID_KEY, 1); // simulates a corrupted/reset counter

    var id = ReminderStore.nextId();
    Test.assert(id > 20);

    Storage.deleteValue(ReminderStore.KEY);
    Storage.deleteValue(ReminderStore.NEXT_ID_KEY);
    return true;
}
