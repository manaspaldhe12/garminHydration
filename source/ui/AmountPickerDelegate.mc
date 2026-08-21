using Toybox.WatchUi as Ui;

class HydrationAmountPickerDelegate extends Ui.BehaviorDelegate {

    var view;
    var reminderId;

    function initialize(v, rid) {
        BehaviorDelegate.initialize();
        view = v;
        reminderId = rid;
    }

    function onNextPage() {
        view.moveNext();
        return true;
    }

    function onPreviousPage() {
        view.movePrev();
        return true;
    }

    function onSelect() {
        var amount = view.currentAmount();
        var settings = SettingsStore.load();

        var elecView = new HydrationElectrolytePickerView(reminderId, amount, settings.get("elec"));
        var elecDelegate = new HydrationElectrolytePickerDelegate(elecView, reminderId, amount);
        Ui.pushView(elecView, elecDelegate, Ui.SLIDE_UP);
        return true;
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

}
