using Toybox.Application.Storage as Storage;

// Persists default water amount / default electrolyte choice.
module SettingsStore {

    const KEY = "settings";

    function load() {
        var settings = Storage.getValue(KEY);
        if (settings == null) {
            settings = SettingsDefaults.build();
            Storage.setValue(KEY, settings);
        }
        return settings;
    }

    function save(settings) {
        Storage.setValue(KEY, settings);
    }

}
