using Toybox.WatchUi as Ui;

class HydrationMainDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        Ui.pushView(new HydrationAboutView(), new HydrationAboutDelegate(), Ui.SLIDE_UP);
        return true;
    }

}
