using Toybox.WatchUi as Ui;

class HydrationEventListDelegate extends Ui.BehaviorDelegate {

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

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

}
