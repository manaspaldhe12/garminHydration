using Toybox.Background as Background;

// Runs in the background process when a registered reminder time is
// reached. Marks the reminder pending (so the foreground app shows
// the alert next time it's opened or polled), vibrates, and schedules
// the following occurrence.
class HydrationServiceDelegate extends Background.ServiceDelegate {

    function initialize() {
        Background.ServiceDelegate.initialize();
    }

    function onTemporalEvent() {
        var reminderId = ReminderScheduler.scheduledReminderId();
        if (reminderId != null) {
            PendingReminderStore.setPending(reminderId, Clock.nowEpoch());
            HapticService.reminderVibration();
        }

        ReminderScheduler.scheduleNext();
        Background.exit(null);
    }

}
