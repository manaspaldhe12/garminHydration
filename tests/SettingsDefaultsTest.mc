using Toybox.Test as Test;

(:test)
function testSettingsDefaultsBuildMatchesGoals(logger) {
    var defaults = SettingsDefaults.build();
    Test.assert(defaults.get("amt") == 250);
    Test.assert(defaults.get("elec") == true);
    return true;
}
