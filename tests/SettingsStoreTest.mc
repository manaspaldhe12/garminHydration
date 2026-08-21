using Toybox.Test as Test;
using Toybox.Application.Storage as Storage;

(:test)
function testSettingsStoreSeedsDefaultsWhenMissing(logger) {
    Storage.deleteValue(SettingsStore.KEY);

    var settings = SettingsStore.load();
    Test.assert(settings.get("amt") == 250);
    Test.assert(settings.get("elec") == true);

    Storage.deleteValue(SettingsStore.KEY);
    return true;
}

(:test)
function testSettingsStoreRoundTripsSavedValues(logger) {
    Storage.deleteValue(SettingsStore.KEY);

    var settings = SettingsStore.load();
    settings.put("amt", 500);
    settings.put("elec", false);
    SettingsStore.save(settings);

    var reloaded = SettingsStore.load();
    Test.assert(reloaded.get("amt") == 500);
    Test.assert(reloaded.get("elec") == false);

    Storage.deleteValue(SettingsStore.KEY);
    return true;
}

(:test)
function testSettingsStoreResetsOnNegativeAmount(logger) {
    Storage.setValue(SettingsStore.KEY, { "amt" => -50, "elec" => true });

    var settings = SettingsStore.load();
    Test.assert(settings.get("amt") == 250);

    Storage.deleteValue(SettingsStore.KEY);
    return true;
}

(:test)
function testSettingsStoreResetsOnUnreasonablyLargeAmount(logger) {
    Storage.setValue(SettingsStore.KEY, { "amt" => 999999, "elec" => true });

    var settings = SettingsStore.load();
    Test.assert(settings.get("amt") == 250);

    Storage.deleteValue(SettingsStore.KEY);
    return true;
}

(:test)
function testSettingsStoreResetsOnMissingField(logger) {
    Storage.setValue(SettingsStore.KEY, { "amt" => 500 });

    var settings = SettingsStore.load();
    Test.assert(settings.get("amt") == 250);
    Test.assert(settings.get("elec") == true);

    Storage.deleteValue(SettingsStore.KEY);
    return true;
}
