using Toybox.Application.Storage as Storage;

// Persists default water amount / default electrolyte choice.
module SettingsStore {

    const KEY = "settings";

    function load() {
        try {
            var settings = Storage.getValue(KEY);
            if (!isValid(settings)) {
                settings = SettingsDefaults.build();
                Storage.setValue(KEY, settings);
            }
            return settings;
        } catch (ex) {
            var defaults = SettingsDefaults.build();
            Storage.setValue(KEY, defaults);
            return defaults;
        }
    }

    function isValid(settings) {
        if (settings == null) {
            return false;
        }
        var amount = settings.get("amt");
        var electrolytes = settings.get("elec");
        if (amount == null || electrolytes == null) {
            return false;
        }
        if (amount < 0 || amount > 5000) {
            return false;
        }
        return true;
    }

    function save(settings) {
        try {
            Storage.setValue(KEY, settings);
        } catch (ex) {
        }
    }

}
