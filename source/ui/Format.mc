// Small text-formatting helpers shared by views.
module Format {

    function pad2(n) {
        if (n < 10) {
            return "0" + n.toString();
        }
        return n.toString();
    }

    function hm(hour, minute) {
        return pad2(hour) + ":" + pad2(minute);
    }

    function amountText(ml) {
        return ml.toString() + " ml";
    }

}
