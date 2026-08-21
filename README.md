# garminHydration

A standalone hydration reminder app for the **Garmin Forerunner 935**, built with Connect IQ.
See [goals.md](goals.md) for requirements, design, and milestones.

## Build

Requires the [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) and a
developer key (`monkeyc -g -y <developer_key.der> ...`, or use the Connect IQ SDK
Manager / VS Code extension).

```bash
monkeyc -f monkey.jungle -d fr935 -o bin/hydration.prg -y developer_key.der
monkeydo bin/hydration.prg fr935
```

Or open the project folder in VS Code with the Monkey C extension and use
"Run" / "Build for Device".
