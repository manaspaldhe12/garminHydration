using Toybox.WatchUi as Ui;

class HydrationHistoryDelegate extends Ui.BehaviorDelegate {

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
        var dayStart = view.selectedDay().get("dayStart");
        var eventListView = new HydrationEventListView(dayStart);
        Ui.pushView(eventListView, new HydrationEventListDelegate(eventListView), Ui.SLIDE_LEFT);
        return true;
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

}
