using Toybox.Application.Storage as Storage;

// Persists logged hydration events.
module EventStore {

    const KEY = "events";
    const NEXT_ID_KEY = "nextEventId";

    function load() {
        var events = Storage.getValue(KEY);
        if (events == null) {
            events = [];
        }
        return events;
    }

    function save(events) {
        Storage.setValue(KEY, events);
    }

    function nextId() {
        var id = Storage.getValue(NEXT_ID_KEY);
        if (id == null) {
            id = 1;
        }
        Storage.setValue(NEXT_ID_KEY, id + 1);
        return id;
    }

    function add(timestampEpoch, amountMl, electrolytes, reminderId) {
        var events = load();
        var event = HydrationEvents.build(nextId(), timestampEpoch, amountMl, electrolytes, reminderId);
        events.add(event);
        save(events);
        return event;
    }

    function eventsBetween(startEpoch, endEpoch) {
        var events = load();
        var result = [];
        for (var i = 0; i < events.size(); i += 1) {
            var event = events[i];
            var ts = event.get("ts");
            if (ts >= startEpoch && ts < endEpoch) {
                result.add(event);
            }
        }
        return result;
    }

}
