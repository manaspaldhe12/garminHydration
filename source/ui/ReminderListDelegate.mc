using Toybox.WatchUi as Ui;

class HydrationReminderListDelegate extends Ui.BehaviorDelegate {

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
        if (view.isAddRowSelected()) {
            var newReminder = ReminderFactory.build(null, 12, 0, true, Days.ALL);
            var editorView = new HydrationReminderEditorView(newReminder, true);
            Ui.pushView(editorView, new HydrationReminderEditorDelegate(editorView), Ui.SLIDE_LEFT);
        } else {
            var editorView = new HydrationReminderEditorView(view.selectedReminder(), false);
            Ui.pushView(editorView, new HydrationReminderEditorDelegate(editorView), Ui.SLIDE_LEFT);
        }
        return true;
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

}
