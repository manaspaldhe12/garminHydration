using Toybox.WatchUi as Ui;

class HydrationMainDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Manual logging: not tied to any reminder.
    function onSelect() {
        var amountView = new HydrationAmountPickerView(null);
        Ui.pushView(amountView, new HydrationAmountPickerDelegate(amountView, null), Ui.SLIDE_UP);
        return true;
    }

    function onNextPage() {
        Ui.pushView(new HydrationTodayView(), new HydrationTodayDelegate(), Ui.SLIDE_LEFT);
        return true;
    }

    function onPreviousPage() {
        Ui.pushView(new HydrationAboutView(), new HydrationAboutDelegate(), Ui.SLIDE_UP);
        return true;
    }

}
