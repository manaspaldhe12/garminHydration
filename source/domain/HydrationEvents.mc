// Hydration event value objects (plain Dictionaries) and aggregation
// helpers shared by the today/history views.
module HydrationEvents {

    function build(id, timestampEpoch, amountMl, electrolytes, reminderId) {
        return {
            "id" => id,
            "ts" => timestampEpoch,
            "amt" => amountMl,
            "elec" => electrolytes,
            "rid" => reminderId
        };
    }

    function totalAmount(events) {
        var total = 0;
        for (var i = 0; i < events.size(); i += 1) {
            total += events[i].get("amt");
        }
        return total;
    }

    function totalByElectrolytes(events, wantElectrolytes) {
        var total = 0;
        for (var i = 0; i < events.size(); i += 1) {
            var event = events[i];
            if (event.get("elec") == wantElectrolytes) {
                total += event.get("amt");
            }
        }
        return total;
    }

}
