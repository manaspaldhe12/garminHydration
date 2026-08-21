using Toybox.WatchUi as Ui;

class HydrationReminderAlertDelegate extends Ui.BehaviorDelegate {

    var pending;

    function initialize(p) {
        BehaviorDelegate.initialize();
        pending = p;
    }

    // Dismiss -> go straight into the log-water flow, pre-filled with
    // this reminder's id so the resulting event references it. Main
    // is installed as the root first so backing out of the amount
    // picker returns to the home screen instead of exiting the app.
    function onSelect() {
        var reminderId = pending.get("rid");
        PendingReminderStore.clear();

        Ui.switchToView(new HydrationMainView(), new HydrationMainDelegate(), Ui.SLIDE_IMMEDIATE);

        var amountView = new HydrationAmountPickerView(reminderId);
        Ui.pushView(amountView, new HydrationAmountPickerDelegate(amountView, reminderId), Ui.SLIDE_UP);
        return true;
    }

    // Back -> dismiss the alert without logging anything right now.
    function onBack() {
        PendingReminderStore.clear();
        Ui.switchToView(new HydrationMainView(), new HydrationMainDelegate(), Ui.SLIDE_DOWN);
        return true;
    }

}
