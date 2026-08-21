// Selectable water amounts, in ml.
module AmountPresets {

    const VALUES = [0, 250, 350, 500, 750];

    function indexOfClosest(amount) {
        var bestIndex = 0;
        var bestDiff = -1;

        for (var i = 0; i < VALUES.size(); i += 1) {
            var diff = VALUES[i] - amount;
            if (diff < 0) {
                diff = -diff;
            }
            if (bestDiff == -1 || diff < bestDiff) {
                bestDiff = diff;
                bestIndex = i;
            }
        }

        return bestIndex;
    }

}
