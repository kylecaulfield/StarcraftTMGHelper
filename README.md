# Starcraft TMG Helper

A tablet-friendly helper app for tracking **Control Points**, **Faction Points**, and **rounds** during a game of Starcraft TMG. Built with Flutter so it can run on Android and iOS from a single codebase. The first release is tuned for Android tablets in landscape.

## Layout

- **Left side – BLUE player**: Control Points counter + Faction Points counter
- **Right side – RED player**: Control Points counter + Faction Points counter
- **Middle column**: Round counter with up/down buttons, plus Reset and New Game

The Faction Points counter shows a `current / threshold` badge and a trophy icon when the configured victory threshold is reached.

## New game setup

Before each game you can configure:

- Starting Control Points
- Starting Faction Points
- Starting Round
- Victory Threshold

## Running

Prerequisites: Flutter 3.24+ and an Android device / emulator (or iOS simulator).

```bash
flutter pub get
flutter run            # pick the target device
flutter test           # widget tests
flutter analyze        # static analysis
```

To build a release APK for an Android tablet:

```bash
flutter build apk --release
```

## Notes

- The Android activity is locked to `sensorLandscape`.
- The screen is kept awake while the app is open (via `wakelock_plus`).
