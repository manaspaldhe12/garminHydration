using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class HydrationApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        ReminderScheduler.scheduleNext();
    }

    function onStop(state) {
    }

    function onBackgroundData(data) {
        Ui.requestUpdate();
    }

    function getServiceDelegate() {
        return [ new HydrationServiceDelegate() ];
    }

    function getInitialView() {
        var pending = PendingReminderStore.getIfFresh();
        if (pending != null) {
            return [ new HydrationReminderAlertView(pending), new HydrationReminderAlertDelegate(pending) ];
        }
        return [ new HydrationMainView(), new HydrationMainDelegate() ];
    }

}
