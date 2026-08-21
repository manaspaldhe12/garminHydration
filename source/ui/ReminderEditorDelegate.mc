using Toybox.WatchUi as Ui;

class HydrationReminderEditorDelegate extends Ui.BehaviorDelegate {

    // Mirrors HydrationReminderEditorView's field order.
    const FIELD_ENABLED = 0;
    const FIELD_HOUR = 1;
    const FIELD_MINUTE = 2;
    const FIELD_DAYS = 3;
    const FIELD_SAVE = 4;

    var view;

    function initialize(v) {
        BehaviorDelegate.initialize();
        view = v;
    }

    function onNextPage() {
        view.moveCursor(1);
        return true;
    }

    function onPreviousPage() {
        view.moveCursor(-1);
        return true;
    }

    function onSelect() {
        var field = view.cursor;

        if (field == FIELD_ENABLED) {
            view.toggleEnabled();
        } else if (field == FIELD_HOUR || field == FIELD_MINUTE) {
            view.toggleAdjusting();
        } else if (field == FIELD_DAYS) {
            view.toggleDays();
        } else if (field == FIELD_SAVE) {
            saveReminder();
        } else {
            if (view.confirmDelete) {
                deleteReminder();
            } else {
                view.confirmDelete = true;
                Ui.requestUpdate();
            }
        }

        return true;
    }

    function onBack() {
        if (view.confirmDelete) {
            view.confirmDelete = false;
            Ui.requestUpdate();
            return true;
        }
        if (view.adjusting) {
            view.adjusting = false;
            Ui.requestUpdate();
            return true;
        }
        Ui.popView(Ui.SLIDE_DOWN);
        return true;
    }

    function saveReminder() {
        var data = view.reminderData();
        var list = ReminderStore.load();

        if (view.isNew) {
            data.put("id", ReminderStore.nextId());
            list.add(data);
        } else {
            for (var i = 0; i < list.size(); i += 1) {
                if (list[i].get("id") == data.get("id")) {
                    list[i] = data;
                    break;
                }
            }
        }

        ReminderStore.save(list);
        ReminderScheduler.scheduleNext();
        Ui.popView(Ui.SLIDE_DOWN);
    }

    function deleteReminder() {
        var id = view.reminderData().get("id");
        var list = ReminderStore.load();
        var kept = [];

        for (var i = 0; i < list.size(); i += 1) {
            if (list[i].get("id") != id) {
                kept.add(list[i]);
            }
        }

        ReminderStore.save(kept);
        ReminderScheduler.scheduleNext();
        Ui.popView(Ui.SLIDE_DOWN);
    }

}
