# Backlog

Ideas and known gaps, roughly ordered by value. Nothing here is started yet.

## High value

- **Persist game state across app restarts.** If Android kills the app (or it's closed accidentally) mid-game, all scores are lost. Save settings + current scores with `shared_preferences` and offer "Resume game" on launch. Note: adding plugins has historically been painful with this project's legacy Gradle setup — pin the package version like `wakelock_plus`/`package_info_plus` are pinned, or do the Gradle migration first (see below).
- **Undo / score history.** A small event log ("Blue +1 CP", "Red +5 FP") with an undo button would recover from mis-taps without a full reset, and doubles as a game record.
- **Support 3–6 players.** Starcraft TMG plays up to 6. The current layout is hardcoded to Blue vs Red; a player-count picker on setup and a grid layout would generalize it.

## Nice to have

- **Player names and faction picker.** Let each player pick Terran / Zerg / Protoss (colors + icon) instead of fixed BLUE/RED labels.
- **Face-to-face mode.** Option to rotate one player's panel 180° so the device can sit flat between players sitting across from each other.
- **Victory celebration.** A one-time banner/animation (and optional sound) when a player crosses the threshold; the amber border + trophy is easy to miss.
- **Per-round score snapshot.** Show each player's points at the start of the round so end-of-round scoring disputes are easy to settle.
- **Portrait support on tablets.** The app is landscape-locked; a stacked portrait layout would help phone users.

## Tech debt / infra

- **Migrate Android to the declarative Gradle plugins DSL**, then unpin `wakelock_plus` (1.2.8) and drop the `package_info_plus` (8.0.2) override. This also unblocks upgrading Flutter past 3.24.x (newer plugin versions require it).
- **Upgrade Flutter** in CI (`3.24.5`) and `pubspec.yaml` once the Gradle migration lands; `withOpacity` is deprecated from Flutter 3.27 and will need a sweep to `withValues()`.
- **Add `dart format --set-exit-if-changed .` to CI** so formatting stays consistent.
- **iOS CI lane.** Only the Android APK is built today; the ios/ project is untested in CI.
- **Real release signing.** The APK ships with debug keys; set up a proper keystore (GitHub secret) before any Play Store distribution.
- **App icon / branding.** Still using the stock Flutter launcher icon and launch screen.
