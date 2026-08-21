using Toybox.Test as Test;
using Toybox.Application.Storage as Storage;

// Exercises the modules the way the UI layer does, end to end,
// without needing the UI itself (views aren't unit-testable in
// isolation - see tests/README.md).

(:test)
function testLoggingWithDefaultsUpdatesTodaysTotal(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    Storage.deleteValue(SettingsStore.KEY);

    var settings = SettingsStore.load(); // defaults: 250 ml, electrolytes yes
    var now = Clock.nowEpoch();

    EventStore.add(now, settings.get("amt"), settings.get("elec"), null);

    var dayStart = Clock.startOfDayEpoch(now);
    var dayEnd = Clock.dayStartOffset(dayStart, 1);
    var todaysEvents = EventStore.eventsBetween(dayStart, dayEnd);

    Test.assert(HydrationEvents.totalAmount(todaysEvents) == 250);
    Test.assert(HydrationEvents.totalByElectrolytes(todaysEvents, true) == 250);
    Test.assert(HydrationEvents.totalByElectrolytes(todaysEvents, false) == 0);

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    Storage.deleteValue(SettingsStore.KEY);
    return true;
}

(:test)
function testReminderFiringThenLoggingClearsPendingState(logger) {
    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    PendingReminderStore.clear();

    var reminders = ReminderFactory.defaults();
    var todayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
    var fromEpoch = todayStart; // before every default reminder time

    // Simulate what the background service does when a reminder fires.
    var next = ReminderScheduler.findNextOccurrence(reminders, fromEpoch);
    Test.assert(next != null);
    PendingReminderStore.setPending(next.get("ids"), next.get("epoch"));

    Test.assert(PendingReminderStore.getIfFresh() != null);

    // Simulate the user dismissing the alert and logging the drink.
    var pending = PendingReminderStore.getIfFresh();
    var reminderId = (pending.get("rids").size() == 1) ? pending.get("rids")[0] : null;
    PendingReminderStore.clear();
    EventStore.add(next.get("epoch"), 350, true, reminderId);

    Test.assert(PendingReminderStore.get() == null);
    var stored = EventStore.load();
    Test.assert(stored.size() == 1);
    Test.assert(stored[0].get("rid") == reminderId);

    Storage.deleteValue(EventStore.KEY);
    Storage.deleteValue(EventStore.NEXT_ID_KEY);
    PendingReminderStore.clear();
    return true;
}
