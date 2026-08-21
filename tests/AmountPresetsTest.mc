using Toybox.Test as Test;

(:test)
function testAmountPresetsIndexOfClosestExactMatch(logger) {
    Test.assert(AmountPresets.VALUES[AmountPresets.indexOfClosest(0)] == 0);
    Test.assert(AmountPresets.VALUES[AmountPresets.indexOfClosest(350)] == 350);
    Test.assert(AmountPresets.VALUES[AmountPresets.indexOfClosest(750)] == 750);
    return true;
}

(:test)
function testAmountPresetsIndexOfClosestBreaksTiesTowardLowerValue(logger) {
    // 300 is equidistant from 250 and 350; the scan order means the
    // first (lower) candidate found wins the tie.
    var idx = AmountPresets.indexOfClosest(300);
    Test.assert(AmountPresets.VALUES[idx] == 250);
    return true;
}

(:test)
function testAmountPresetsIndexOfClosestBelowRangeClampsToMin(logger) {
    Test.assert(AmountPresets.VALUES[AmountPresets.indexOfClosest(-500)] == 0);
    return true;
}

(:test)
function testAmountPresetsIndexOfClosestAboveRangeClampsToMax(logger) {
    Test.assert(AmountPresets.VALUES[AmountPresets.indexOfClosest(10000)] == 750);
    return true;
}
