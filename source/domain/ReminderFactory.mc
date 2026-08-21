// Builds reminder value objects (plain Dictionaries so they can be
// stored directly with Application.Storage) and the hard-coded v0.1
// defaults from goals.md.
module ReminderFactory {

    function build(id, hour, minute, enabled, days) {
        return {
            "id" => id,
            "hour" => hour,
            "min" => minute,
            "enabled" => enabled,
            "days" => days
        };
    }

    function defaults() {
        return [
            build(1, 8, 0, true, Days.ALL),
            build(2, 10, 0, true, Days.ALL),
            build(3, 12, 0, true, Days.ALL),
            build(4, 14, 0, true, Days.ALL),
            build(5, 16, 0, true, Days.ALL),
            build(6, 18, 0, true, Days.ALL)
        ];
    }

}
