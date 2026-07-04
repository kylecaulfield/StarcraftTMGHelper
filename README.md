# Starcraft TMG Helper

A tablet-friendly helper app for tracking **Control Points**, **Faction Points**, and **rounds** during a game of Starcraft TMG. Built with Flutter so it can run on Android and iOS from a single codebase. The first release is tuned for Android tablets in landscape.

## Layout

- **Left side – BLUE player**: Control Points counter + Faction Points counter
- **Right side – RED player**: Control Points counter + Faction Points counter
- **Middle column**: Round counter with up/down buttons, plus Reset and New Game

The Faction Points counter shows a `current / threshold` badge; when the configured victory threshold is reached the winning panel gets a trophy icon, an amber border, and an amber badge.

### Score controls

- Tap **+ / −** to change a score by 1 (with haptic feedback).
- **Long-press + / −** to change a score by 5 (never below 0).
- **Reset** restores both players' points and the round to their starting values (asks for confirmation).
- **New Game** ends the current game and returns to setup (asks for confirmation). Your last setup values are remembered.
- The Android back button acts like **New Game** instead of instantly quitting mid-game.

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

The output APK lives at `build/app/outputs/flutter-apk/app-release.apk`.

## Installing on an Android tablet

GitHub Actions builds a release APK on every push and attaches it both as a workflow artifact and (when you push a `v*` tag) as a GitHub Release asset.

1. Grab the APK:
   - **Latest build**: open the [Actions tab](../../actions), pick the latest successful `android` run, and download the `starcraft-tmg-helper-<sha>.apk` artifact (GitHub login required; artifacts expire after 90 days).
   - **Tagged release**: download from the [Releases page](../../releases) — public link, no login needed.
2. On the tablet, allow installs from your browser / Files app: **Settings → Apps → Special access → Install unknown apps**.
3. Open the APK from the Files app and install.

To cut a new release:

```bash
git tag v0.1.0
git push origin v0.1.0
```

The workflow will build the APK and create a GitHub Release with it attached.

> The release APK is currently signed with Flutter's debug keys, so Android will warn when sideloading. This is fine for personal use; for Play Store distribution you'd need to set up a real signing config.

## Notes

- The Android activity is locked to `sensorLandscape`.
- The screen is kept awake while the app is open (via `wakelock_plus`).
