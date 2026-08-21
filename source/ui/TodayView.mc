using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class HydrationTodayView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        var dayStart = Clock.startOfDayEpoch(Clock.nowEpoch());
        var dayEnd = Clock.dayStartOffset(dayStart, 1);
        var events = EventStore.eventsBetween(dayStart, dayEnd);

        var total = HydrationEvents.totalAmount(events);
        var withElectrolytes = HydrationEvents.totalByElectrolytes(events, true);
        var withoutElectrolytes = HydrationEvents.totalByElectrolytes(events, false);

        dc.drawText(width / 2, 30, Gfx.FONT_SMALL, "TODAY",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height / 2 - 20, Gfx.FONT_NUMBER_MEDIUM, Format.amountText(total),
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height / 2 + 25, Gfx.FONT_XTINY, "Electrolytes: " + Format.amountText(withElectrolytes),
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height / 2 + 45, Gfx.FONT_XTINY, "No electrolytes: " + Format.amountText(withoutElectrolytes),
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height - 20, Gfx.FONT_XTINY, "SELECT: events  BACK",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
