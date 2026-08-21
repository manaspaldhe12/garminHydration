using Toybox.WatchUi as Ui;

class HydrationElectrolytePickerDelegate extends Ui.BehaviorDelegate {

    var view;
    var reminderId;
    var amount;

    function initialize(v, rid, amountMl) {
        BehaviorDelegate.initialize();
        view = v;
        reminderId = rid;
        amount = amountMl;
    }

    function onNextPage() {
        view.toggle();
        return true;
    }

    function onPreviousPage() {
        view.toggle();
        return true;
    }

    function onSelect() {
        var electrolytes = view.electrolytes;
        EventStore.add(Clock.nowEpoch(), amount, electrolytes, reminderId);
        HapticService.confirmVibration();

        var savedView = new HydrationSavedView(amount, electrolytes);
        Ui.switchToView(savedView, new HydrationSavedDelegate(savedView), Ui.SLIDE_UP);
        return true;
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

}
