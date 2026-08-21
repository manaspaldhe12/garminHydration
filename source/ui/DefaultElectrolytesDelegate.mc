using Toybox.WatchUi as Ui;

class HydrationDefaultElectrolytesDelegate extends Ui.BehaviorDelegate {

    var view;

    function initialize(v) {
        BehaviorDelegate.initialize();
        view = v;
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
        var settings = SettingsStore.load();
        settings.put("elec", view.electrolytes);
        SettingsStore.save(settings);
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

}
