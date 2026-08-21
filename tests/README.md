# Unit tests

These use Connect IQ's built-in `Toybox.Test` framework: every function
tagged `(:test)` below is excluded from normal builds and only
compiled/run when you build with `-t`.

## Running

```bash
monkeyc -f monkey.jungle -d fr935 -y developer_key.der -o bin/test.prg -t
monkeydo bin/test.prg fr935 -t
```

The simulator (or `monkeydo -t`) runs every `(:test)` function and
prints a pass/fail summary instead of launching the app UI.

## Coverage

Everything in `source/domain`, `source/persistence`, and
`source/timing` is covered - the reminder scheduling math (including
day-of-week rollover, coincident reminders, and DST-safe date
arithmetic), storage CRUD, retention pruning, corrupt-data recovery,
id-collision guards, and formatting helpers. `tests/IntegrationTest.mc`
exercises the full "reminder fires -> dismiss -> log -> shows in
today's total" path by driving the same modules the UI layer calls,
without needing the UI itself.

**Not covered:** `source/ui/*.mc` (Views/Delegates) and
`source/feedback/HapticService.mc` and
`source/platform/HydrationServiceDelegate.mc`. Connect IQ has no
headless way to unit-test a `WatchUi.View`'s rendering, button
handling, `Timer` callbacks, `Attention.vibrate`, or a
`Background.ServiceDelegate`'s `onTemporalEvent` - those need to be
exercised by hand in the simulator or on a device. The UI/platform
layers here are intentionally thin wrappers around the tested modules
(the Delegates just call into `EventStore`, `ReminderScheduler`, etc.)
specifically so the business logic that *can* be tested carries the
real risk, and the untested glue stays small and easy to eyeball.

## Storage isolation

Tests that touch `Application.Storage` explicitly reset the specific
keys they use at the start and end of each test (e.g.
`Storage.deleteValue(EventStore.KEY)`), so tests don't depend on
run order or leak state into each other. Run these against the
simulator's storage, not a real watch with real hydration data - they
will overwrite the app's `events`, `reminders`, `settings`, and
`pendingReminder` storage keys.
