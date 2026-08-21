using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class HydrationDefaultAmountView extends Ui.View {

    var index;

    function initialize() {
        View.initialize();
        var settings = SettingsStore.load();
        index = AmountPresets.indexOfClosest(settings.get("amt"));
    }

    function currentAmount() {
        return AmountPresets.VALUES[index];
    }

    function moveNext() {
        index = (index + 1) % AmountPresets.VALUES.size();
        Ui.requestUpdate();
    }

    function movePrev() {
        index -= 1;
        if (index < 0) {
            index = AmountPresets.VALUES.size() - 1;
        }
        Ui.requestUpdate();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.drawText(width / 2, 40, Gfx.FONT_SMALL, "Default Amount",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height / 2, Gfx.FONT_NUMBER_MEDIUM, Format.amountText(currentAmount()),
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(width / 2, height - 20, Gfx.FONT_XTINY, "UP/DOWN  SELECT: save  BACK",
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

}
