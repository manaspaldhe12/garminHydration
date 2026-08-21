using Toybox.WatchUi as Ui;

class HydrationSettingsMenuDelegate extends Ui.BehaviorDelegate {

    var view;

    function initialize(v) {
        BehaviorDelegate.initialize();
        view = v;
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
        var index = view.selectedIndex();
        if (index == 0) {
            var listView = new HydrationReminderListView();
            Ui.pushView(listView, new HydrationReminderListDelegate(listView), Ui.SLIDE_LEFT);
        } else if (index == 1) {
            var amountView = new HydrationDefaultAmountView();
            Ui.pushView(amountView, new HydrationDefaultAmountDelegate(amountView), Ui.SLIDE_LEFT);
        } else if (index == 2) {
            var elecView = new HydrationDefaultElectrolytesView();
            Ui.pushView(elecView, new HydrationDefaultElectrolytesDelegate(elecView), Ui.SLIDE_LEFT);
        } else {
            var historyView = new HydrationHistoryView();
            Ui.pushView(historyView, new HydrationHistoryDelegate(historyView), Ui.SLIDE_LEFT);
        }
        return true;
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

}
