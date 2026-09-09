# Omni Documentation & Guide

## 0. Auto-Updater (Updater.ahk)

The Omni package includes an **Updater.ahk** script that automatically checks for and installs the latest version of `Omni.exe`.

### What it does
- Reads the local `version.txt` file (if exists) to get the current version.
- Fetches the latest version string from the official GitHub repository.
- Compares local and remote versions.
- If they differ, performs a full update:
  - Downloads the newest `Omni.exe` to a temporary file.
  - If `Omni.exe` is currently running, attempts to close it gracefully, then forcefully if needed.
  - Replaces the old `Omni.exe` with the downloaded file (uses rename‑and‑replace for reliability).
  - Updates `version.txt` with the new version.
- If versions match, simply notifies you that you are up to date.

### How to use
1. Make sure `Updater.ahk` in the same folder as `Omni.exe` and `version.txt`.
2. Run `Updater.ahk` (double‑click or via AutoHotkey).
3. A small GUI window will show the current status (checking, downloading, replacing, etc.).
4. The script will request administrator privileges if needed – allow it.
5. After the update finishes, you can start `Omni.exe` as usual.

### Notes
- The updater requires an active internet connection.
- If the update fails, close `Omni.exe` manually and run the updater again.
- Running the updater regularly ensures you always have the latest features and offsets compatibility.

## 1. Step-by-Step Usage Guide
* Step 1: Obtain your key first before running the macro.
* Step 2: Open the Offsets tab and update the offsets according to your currently used Roblox version.
* Step 3: Configure your settings, button hotkeys, and preferences in the Config tab.
* Step 4: Press your start key to begin using the macro.

## 2. Configurations & Default Values
* cooldown: Minimum delay (ms) between parry actions to prevent spam.
  * Default value: 50 ms. Lowering it can cause double-clicks, while raising it may cause you to miss consecutive parries.
* delay: Loop interval (ms) for the main timer checking game states.
  * Default value: 5 ms. Lower values increase responsiveness but consume more CPU usage.
* distanceThreshold: Base distance (in-game units) between player and ball to trigger a parry.
  * Default value: 3. Adjust this depending on your ping; increase it if you have higher latency so it triggers earlier.
* speedFactor: Multiplier added to the distance threshold based on ball speed.
  * Default value: 0.3. 
  * Tuning guide: If the ball is too fast and you are parrying too late, increase this value (e.g., to 0.4 or 0.5) so the macro triggers from farther away. If you are parrying too early before the ball actually reaches you, decrease this value (e.g., to 0.1 or 0.2).
* startKey / reattachKey / switchKey: Hotkeys to toggle macro (default F1), reattach memory (F2), and switch mode (F3).
* startMode: Toggle (press once for ON/OFF) or Hold (active only while key is pressed).
* aeroYDrop: Y-axis coordinate drop threshold for handling AeroDynamic slash effects.
  * Default value: 0.01.

## 3. Detection Modes
* Instant Parry: Reacts immediately based on character highlight status without complex 3D distance calculations.
* Ball Position: Tracks 3D ball coordinates relative to the player, using dynamic speed calculation and threshold distance for precision parrying.
* Note: If the enemy is using Singularity, it is strongly recommended to switch to Instant Parry mode, as Ball Position can sometimes be too slow to parry.

## 4. Offsets Update
* Automatic source: Fetches latest Roblox memory pointers from remote repository.
* Local storage: Saves data into `_of/offsets.json`.
* Update & Reattach: Updates pointer versions and re-establishes process memory connection safely.

## 5. Anti Singu
* Filters out fake highlights.
* Ensures parry triggers only on genuine highlights or valid fake highlights paired with a Singularity Cape, preventing visual trap misparrys.

## 6. Anti Aero
* Detects AeroDynamic Slash VFX inside the ball.
* Enters a monitoring state and triggers parry precisely when the ball's Y-coordinate descent matches the set drop threshold.
