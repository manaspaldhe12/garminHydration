using Toybox.WatchUi as Ui;

class HydrationSavedDelegate extends Ui.BehaviorDelegate {

    var view;

    function initialize(v) {
        BehaviorDelegate.initialize();
        view = v;
    }

    // Any button dismisses immediately rather than waiting out the
    // auto-dismiss timer, for a user who's already moving on.
    function onSelect() {
        view.dismiss();
        return true;
    }

    function onBack() {
        view.dismiss();
        return true;
    }

}
