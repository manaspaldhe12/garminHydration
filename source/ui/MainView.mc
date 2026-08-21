using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;

// Home screen: today's running total at a glance, plus quick access
// to manual logging, the today breakdown, and the about screen.
// Polls for a reminder that fired while this view is on screen (a
// reminder that fires while the app is closed is instead surfaced
// directly by HydrationApp.getInitialView()).
class HydrationMainView extends Ui.View {

    var pollTimer;

    function initialize() {
        View.initialize();
    }

    function onShow() {
        pollTimer = new Timer.Timer();
        pollTimer.start(method(:checkPending), 2000, true);
    }

    function onHide() {
        if (pollTimer != null) {
            pollTimer.stop();
            pollTimer = null;
        }
    }

    function checkPending() {
        var pending = PendingReminderStore.get();
        if (pending != null) {
            if (pollTimer != null) {
                pollTimer.stop();
                pollTimer = null;
            }
            Ui.switchToView(new HydrationReminderAlertView(pending), new HydrationReminderAlertDelegate(pending), Ui.SLIDE_IMMEDIATE);
        }
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        var dayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
        var dayEnd = dayStart + 86400;
        var total = HydrationEvents.totalAmount(EventStore.eventsBetween(dayStart, dayEnd));

        dc.drawText(width / 2, height / 2 - 40, Gfx.FONT_MEDIUM, "Hydration",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height / 2, Gfx.FONT_NUMBER_MEDIUM, Format.amountText(total),
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height / 2 + 40, Gfx.FONT_XTINY, "today",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height - 20, Gfx.FONT_XTINY, "SELECT: Log  DOWN: Today  UP: Info",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
