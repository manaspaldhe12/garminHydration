using Toybox.Application.Storage as Storage;

// Persists logged hydration events.
module EventStore {

    const KEY = "events";
    const NEXT_ID_KEY = "nextEventId";

    // Keeps detailed event history (as opposed to daily aggregates)
    // bounded so a single Storage value can't grow without limit.
    const RETENTION_DAYS = 30;
    const MAX_EVENTS = 2000;

    // Reads and sanitizes the stored event list, dropping any entry
    // that's missing required fields (e.g. from a corrupted write or
    // a future format change) rather than letting a bad entry crash
    // every screen that reads events.
    function load() {
        try {
            var events = Storage.getValue(KEY);
            if (events == null) {
                return [];
            }

            var valid = [];
            for (var i = 0; i < events.size(); i += 1) {
                var event = events[i];
                if (event != null && event.get("id") != null && event.get("ts") != null && event.get("amt") != null) {
                    valid.add(event);
                }
            }
            return valid;
        } catch (ex) {
            return [];
        }
    }

    function save(events) {
        try {
            Storage.setValue(KEY, events);
        } catch (ex) {
            // Most likely a storage-quota error. Drop the oldest half
            // and retry once so logging keeps working even if full
            // history can't be kept.
            var half = events.size() / 2;
            var trimmed = [];
            for (var i = half; i < events.size(); i += 1) {
                trimmed.add(events[i]);
            }
            try {
                Storage.setValue(KEY, trimmed);
            } catch (ex2) {
            }
        }
    }

    function nextId() {
        var candidate = Storage.getValue(NEXT_ID_KEY);
        if (candidate == null) {
            candidate = 1;
        }

        // Guard against a corrupted/reset counter re-issuing an id
        // that's already in use.
        var events = load();
        for (var i = 0; i < events.size(); i += 1) {
            var existingId = events[i].get("id");
            if (existingId != null && existingId >= candidate) {
                candidate = existingId + 1;
            }
        }

        Storage.setValue(NEXT_ID_KEY, candidate + 1);
        return candidate;
    }

    function add(timestampEpoch, amountMl, electrolytes, reminderId) {
        var events = load();
        var event = HydrationEvents.build(nextId(), timestampEpoch, amountMl, electrolytes, reminderId);
        events.add(event);
        save(prune(events));
        return event;
    }

    // Drops events older than the retention window, then enforces a
    // hard cap as a last-resort backstop even within that window.
    function prune(events) {
        var cutoff = Clock.dayStartOffset(Clock.startOfDayEpoch(Clock.nowEpoch()), -RETENTION_DAYS);
        var kept = [];
        for (var i = 0; i < events.size(); i += 1) {
            if (events[i].get("ts") >= cutoff) {
                kept.add(events[i]);
            }
        }

        if (kept.size() > MAX_EVENTS) {
            var trimmed = [];
            var start = kept.size() - MAX_EVENTS;
            for (var i = start; i < kept.size(); i += 1) {
                trimmed.add(kept[i]);
            }
            kept = trimmed;
        }

        return kept;
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
