# Garmin 935 Hydration Reminder

## 1. Goals

### Primary Goal

Build a **standalone hydration reminder app for the Garmin Forerunner 935** that allows the user to schedule reminders, log water consumption, and review hydration totals **without requiring a phone**.

The phone should be an optional companion for configuration and historical visualization, not a dependency for the core experience.

### Core principles

1. **Watch-first**

   * The app must be fully usable from the Garmin 935.
   * The user should not need their phone during normal use.

2. **Fast interaction**

   * Logging a drink should take only a few button presses.
   * The app should be practical to use repeatedly throughout the day.

3. **Offline-first**

   * Reminders, settings, and hydration data should work without phone connectivity or Internet access.

4. **Simple data model**

   * Track water amount and whether electrolytes were consumed.
   * Avoid unnecessary complexity.

5. **Phone as optional enhancement**

   * A phone companion can provide easier configuration and historical views.
   * Losing phone connectivity must not break the watch app.

---

# 2. Functional Requirements

## 2.1 Reminder Scheduling

The user can configure hydration reminders directly on the watch.

Each reminder has:

* Time
* Enabled/disabled
* Days of week

Example:

```text
Hydration Reminders

08:30  Every day     ON
10:30  Every day     ON
12:30  Weekdays      ON
15:00  Every day     ON
17:00  Every day     ON
19:00  Every day     ON
```

The app should support multiple reminders per day.

### Phone

The phone may provide a more convenient interface for managing the same settings, but **the phone is not required**.

---

# 2.2 Hydration Reminder

At the configured time, the Garmin should:

* Alert the user.
* Vibrate.
* Display a hydration reminder.

Example:

```text
┌─────────────────┐
│                 │
│   DRINK WATER   │
│                 │
│     12:30       │
│                 │
│    Dismiss      │
└─────────────────┘
```

The exact implementation should follow what is technically possible on the Forerunner 935 / Connect IQ.

---

# 2.3 Water Logging

After acknowledging the reminder, the app asks how much water was consumed.

Amounts are always represented in **ml**.

Initial presets:

```text
0 ml
250 ml
350 ml
500 ml
750 ml
```

The user should be able to select an amount using the physical watch buttons.

A configurable default amount should be supported.

Default:

```text
250 ml
```

The common interaction should therefore be very fast.

---

# 2.4 Electrolyte Tracking

Each hydration event optionally records whether electrolytes were consumed.

```text
Electrolytes?

● Yes
  No
```

Default:

**Yes**

The user can select **No** when the drink did not contain electrolytes.

This should be part of the hydration event rather than a separate global record.

---

# 2.5 Hydration Events

Each logged drink creates an event:

```text
HydrationEvent
├── id
├── timestamp
├── amountMl
├── electrolytes
└── reminderId
```

Example:

```text
08:30   250 ml   Yes
10:30   350 ml   Yes
12:30   500 ml   No
15:00   250 ml   Yes
```

The watch stores these events locally.

---

# 2.6 Today's Hydration

The watch should provide a way to see today's totals.

Example:

```text
TODAY

1,350 ml

Electrolytes
1,000 ml

No electrolytes
350 ml
```

The total is simply:

```text
Total = sum(all logged water amounts)
```

The user should not need the phone to see today's total.

---

# 2.7 Hydration History

The watch should retain historical hydration data.

At minimum, the watch should be able to display daily totals:

```text
Hydration History

Today       1,850 ml
Yesterday   2,100 ml
Aug 19      1,650 ml
Aug 18      1,900 ml
```

The exact amount of history retained should be constrained by the storage capabilities of the 935.

---

# 3. Phone Companion

The phone is **optional**.

The app should work correctly even if the user never installs the phone companion.

## Phone capabilities

The companion can provide:

### Easier settings management

* Create reminders.
* Edit reminders.
* Delete reminders.
* Configure schedules.
* Configure default water amount.
* Configure default electrolyte value.

### Better history

The phone can display:

* Daily totals.
* Hydration events.
* Weekly averages.
* Longer-term history.
* Electrolyte statistics.

### Synchronization

```text
              Optional
        ┌─────────────────┐
        │      Phone      │
        └────────┬────────┘
                 │
          Garmin Connect
                 │
                 ▼
        ┌─────────────────┐
        │   Garmin 935   │
        │                 │
        │ Reminders       │
        │ Hydration       │
        │ History         │
        └─────────────────┘
```

The watch remains authoritative for the core hydration experience.

---

# 4. Architecture

## 4.1 Watch-first architecture

The watch should contain all components required for standalone operation:

```text
┌─────────────────────────────────┐
│          Garmin 935             │
│                                 │
│  ┌───────────────┐              │
│  │ Reminder      │              │
│  │ Scheduler     │              │
│  └───────┬───────┘              │
│          │                      │
│          ▼                      │
│  ┌───────────────┐              │
│  │ Reminder UI   │              │
│  └───────┬───────┘              │
│          │                      │
│          ▼                      │
│  ┌───────────────┐              │
│  │ Hydration     │              │
│  │ Logger        │              │
│  └───────┬───────┘              │
│          │                      │
│          ▼                      │
│  ┌───────────────┐              │
│  │ Local Storage │              │
│  └───────────────┘              │
│                                 │
└─────────────────────────────────┘
```

There should be no dependency on:

* Internet
* Garmin Connect
* Phone
* Cloud backend

for the core functionality.

---

# 5. Data Ownership

The watch should be the **source of truth** for locally generated hydration events.

### Watch

Stores:

* Reminder configuration.
* App settings.
* Hydration events.
* Daily aggregates/history as needed.

### Phone

Stores a synchronized copy for:

* Visualization.
* Longer-term history.
* Easier editing.

This avoids a situation where the phone must be available for the watch to function.

---

# 6. User Experience

## Normal workflow

The ideal daily workflow is:

```text
              12:30
                │
                ▼
         ┌─────────────┐
         │ DRINK WATER │
         └──────┬──────┘
                │
             Dismiss
                │
                ▼
         ┌─────────────┐
         │    250 ml   │
         │    350 ml   │
         │    500 ml   │
         │    750 ml   │
         └──────┬──────┘
                │
                ▼
         ┌─────────────┐
         │ Electrolytes│
         │   ● Yes     │
         │     No      │
         └──────┬──────┘
                │
                ▼
              Saved
```

The most common case should require minimal interaction:

**Reminder → amount → confirm default electrolyte choice → done**

---

# 7. Configuration UX

The watch should provide a Settings menu:

```text
Hydration

> Reminders
  Default Amount
  Default Electrolytes
  Today's Total
  History
```

### Reminders

```text
Reminders

> 08:30  Every day
  10:30  Every day
  12:30  Weekdays
  15:00  Every day

[Add Reminder]
```

Selecting a reminder:

```text
08:30

Enabled       ON
Time          08:30
Days          Every day

> Save
  Delete
```

---

# 8. Goals vs Non-Goals

## Goals

* Standalone Garmin 935 operation.
* Configurable hydration reminders.
* Fast water logging.
* ml-based tracking.
* Electrolyte Yes/No tracking.
* Daily totals.
* Local history.
* Optional phone synchronization.

## Non-goals

For the initial product:

* Automatic detection of drinking.
* Smart water bottle integration.
* Medical hydration recommendations.
* Weather-based hydration recommendations.
* Complex electrolyte/nutrition tracking.
* Cloud accounts.
* Social features.
* Requiring a phone for configuration or operation.

---

# 9. Milestones

## v0.0 — App Shell

**Goal:** Prove the basic Garmin app works.

### Watch

* Create Connect IQ project.
* Target Forerunner 935.
* Basic app lifecycle.
* Basic screen.
* Basic navigation.
* Install and launch on simulator/watch.

### Functionality

None.

Example:

```text
Hydration

App running.
```

### Phone

No phone functionality required yet.

**Exit criteria:** App builds, installs, launches, and can navigate between basic screens.

---

# v0.1 — Standalone Core With Defaults

**Goal:** Build the complete basic experience using hard-coded defaults.

### Defaults

```text
Reminders:
08:00
10:00
12:00
14:00
16:00
18:00

Default amount:
250 ml

Default electrolytes:
Yes
```

### Watch

* Reminder scheduling.
* Reminder alert/vibration.
* Reminder dismissal.
* Water amount selection.
* Electrolyte selection.
* Hydration event creation.
* Local event storage.
* Today's total.

### No configuration yet

Everything is hard-coded.

**Exit criteria:** The watch can independently remind, log water, and display today's hydration total.

---

# v0.2 — CRUD for Watch Settings

**Goal:** Make the standalone watch app configurable.

### Reminder CRUD

* Create reminder.
* List reminders.
* Edit reminder.
* Delete reminder.
* Enable/disable reminder.
* Configure time.
* Configure days.

### Settings

* Default water amount.
* Default electrolytes.

### Persistence

Settings survive app restarts.

**Exit criteria:** The user can configure the entire app directly from the watch.

---

# v0.3 — Hydration History

**Goal:** Make the watch useful as a standalone hydration tracker.

### Add

* Today's event list.
* Daily totals.
* Historical daily totals.
* Electrolyte totals.
* Event timestamps.

Example:

```text
Today

1,850 ml
1,100 ml with electrolytes
750 ml without
```

**Exit criteria:** The user can leave their phone at home and still review their hydration history on the watch.

---

# v0.4 — Data Reliability

**Goal:** Make the standalone application robust.

### Handle

* Watch restart.
* App restart.
* Empty data.
* Storage limits.
* Multiple reminders.
* Missed reminders.
* Midnight/day boundaries.
* Time changes.
* Invalid configurations.

### Data integrity

Every event gets a unique identifier and timestamp.

**Exit criteria:** Hydration data remains consistent across normal watch lifecycle events.

---

# v0.5 — Watch UX Optimization

**Goal:** Make the app pleasant enough for everyday use.

Focus on:

* Minimum button presses.
* Clear navigation.
* Good defaults.
* Fast logging.
* Clear reminder UI.
* Clear selected values.
* Avoid accidental actions.
* Efficient use of the 935's physical buttons.

### Target

A typical hydration event should take only a few seconds to log.

**Exit criteria:** The interaction feels natural enough to use repeatedly throughout a day.

---

# v0.6 — Optional Phone Companion

**Goal:** Add the phone without making it a dependency.

### Phone

Implement:

* Reminder list.
* Reminder CRUD.
* Settings.
* Daily hydration total.
* Hydration history.

### Synchronization

Phone ↔ watch synchronization for:

* Settings.
* Reminder configuration.
* Hydration events.

### Important requirement

If the phone disappears after v0.6:

**The watch must continue working exactly as it did before.**

**Exit criteria:** Phone provides convenience but is completely optional.

---

# v0.7 — Sync Reliability

**Goal:** Make optional synchronization dependable.

Handle:

* Phone unavailable.
* Watch unavailable.
* Multiple unsynchronized events.
* Duplicate events.
* Interrupted synchronization.
* Configuration changes on both devices.
* Historical event synchronization.

The watch must continue collecting data while disconnected.

**Exit criteria:** Disconnecting the phone for days does not cause data loss.

---

# v0.8 — Phone Analytics

**Goal:** Take advantage of the phone's larger screen.

Add:

* Daily hydration history.
* Weekly totals.
* Average daily intake.
* Highest/lowest days.
* Electrolyte statistics.
* Daily event timeline.
* Basic charts.

**Exit criteria:** Phone provides substantially better historical analysis while remaining optional.

---

# v0.9 — Production Hardening

**Goal:** Prepare for real-world use.

Test:

* Long-running operation.
* Repeated reminders.
* Battery impact.
* Storage behavior.
* Watch restarts.
* Phone disconnections.
* Synchronization.
* Timezone changes.
* Daylight saving changes.
* Large hydration histories.

**Exit criteria:** App can run continuously for weeks without manual repair.

---

# v1.0 — Standalone Production Release

The final v1.0 experience is:

### On the Garmin 935

* Create/edit/delete reminders.
* Recurring schedules.
* Reminder alerts.
* Quick hydration logging.
* ml amounts.
* Electrolyte Yes/No.
* Daily totals.
* Hydration history.
* Persistent local data.
* No phone required.

### On the phone — optional

* Easier reminder configuration.
* Hydration history.
* Daily/weekly aggregates.
* Analytics.
* Synchronization.

### Core architecture

```text
                    OPTIONAL
              ┌─────────────────┐
              │      Phone      │
              │                 │
              │ Settings        │
              │ History         │
              │ Analytics       │
              └────────┬────────┘
                       │
                       │ Sync
                       │
                       ▼
┌────────────────────────────────────────┐
│             Garmin 935                 │
│                                        │
│  Reminder Scheduler                    │
│          ↓                             │
│  Reminder / Alert                      │
│          ↓                             │
│  Water + Electrolyte Logging            │
│          ↓                             │
│  Local Hydration Database               │
│          ↓                             │
│  Daily Totals + History                 │
│                                        │
│        FULLY STANDALONE                │
└────────────────────────────────────────┘
```

The key architectural decision is therefore: **build the Garmin app as a complete product first, and treat the phone as an optional secondary UI rather than making it part of the core system.**


