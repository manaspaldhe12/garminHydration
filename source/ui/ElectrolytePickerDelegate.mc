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
        EventStore.add(Clock.nowEpoch(), amount, view.electrolytes, reminderId);
        HapticService.confirmVibration();
        Ui.switchToView(new HydrationMainView(), new HydrationMainDelegate(), Ui.SLIDE_DOWN);
        return true;
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

}
