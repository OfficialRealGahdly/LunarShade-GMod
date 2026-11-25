Here's the fully rewritten README with those sections removed, no update notification claims, no version numbers, and all the actual user-facing features retained.

# Lunar Shade

A dark interface theme for Garry's Mod with its own **Lunar Shade tab in the spawn menu**, a customisable settings panel, a custom main menu and pause menu, and a Derma skin that restyles menus built from standard Derma controls.

Made by **OfficialRealGahdly**.

Client-side only · Works with Sandbox and Sandbox-derived gamemodes.

---

## Features

### Interface and appearance

- **Complete dark theme.** Give supported Garry's Mod menus a consistent dark appearance.
- **Spawn menu tab.** Press `Q` to find Lunar Shade alongside Spawnlists, Weapons, Entities and the other spawn menu tabs.
- **Settings panel.** Enable or disable the theme and customise its appearance.
- **Accent colours.** Choose from six presets or create your own colour using the custom colour mixer.
- **Surface tones.** Choose between Midnight, Obsidian and Slate.
- **Interface styling.** Adjust corner roundness, window accent lines and animations.
- **Live preview.** See appearance changes as you make them.
- **Derma skin.** Restyles standard Derma frames, buttons, text boxes, checkboxes, combo boxes, sliders, tabs, scroll bars, lists, trees, menus and tooltips.
- **Compatibility.** Panels that another addon deliberately skins are left alone rather than forcibly restyled.

### Customisation

The Custom page gives you control over the appearance and layout of Lunar Shade.

- Move and resize the main menu logo and button column.
- Reorder main menu buttons.
- Hide main menu buttons.
- Move, rename and reorder Q menu tabs.
- Hide Q menu tabs. The Lunar Shade tab itself can never be hidden.
- Change individual interface colours.
- Use the colour mixer or enter hexadecimal colour codes.
- Reset individual colours to their defaults.
- Preview your custom layout before using it.

The main-menu **Options > Custom** page provides the same main menu layout, button and colour controls without needing to start a game.

Options itself can never be hidden, so you can always access your settings.

Q menu tab customisation is available in-game through the Lunar Shade tab.

### Main menu

Lunar Shade includes its own custom main menu.

- Animated night sky.
- Spinning moon.
- Custom accent colours.
- Customisable logo and button positions.
- Reorderable and hideable menu buttons.
- Custom background options.
- Classic menu button to return to the original main menu.

The background can be changed to:

- **Night sky:** The original animated background.
- **No stars:** Moon and hills without stars, aurora or shooting stars.
- **Gradient:** A background using two colours of your choice.
- **Plain:** A single-colour background.

Plain and Gradient backgrounds stop the background animation to minimise drawing overhead.

### Pause menu

The custom pause menu appears when you press `Esc` while playing.

It displays the game behind a dimmed interface and provides access to:

- Resume Game
- Disconnect
- Options
- Addons
- Duplications
- Saves
- Demos
- Mod Files

The pause menu uses your Lunar Shade styling and can be disabled from the Main menu page of the Lunar Shade settings.

### Layout preview

The layout preview lets you see your customised title screen without leaving your current game.

It includes:

- Your custom logo and button positions.
- Your button order and visibility settings.
- Your selected background.
- Your custom colours.
- A switch between the main menu and pause menu previews.

You can open the preview using the Custom page or the `lunar_shade_menu_preview` console command.

### Saved themes

Save and switch between your own Lunar Shade appearances.

Saved themes can include:

- Accent colour.
- Surface tone.
- Interface shape.
- Individual colours.
- Main menu layout.
- Q menu tab order, names and visibility.

You can name your themes, switch between them, undo a switch and copy a theme code to share with someone else.

### NPC options

Common NPC options are available in a small box in the spawn menu.

These include:

- Disable Thinking
- Ignore Players
- Keep Corpses
- Join Player's Squad
- Weapon Override

The NPC options box can be disabled from the Custom page.

It appears on spawn menu tabs except Spawnlists, where the NPC controls are already available.

### Welcome tours

Lunar Shade includes welcome walkthroughs to help new users understand the interface.

- A main-menu welcome tour.
- An in-game welcome tour using the same visual design.
- Numbered steps and navigation indicators.
- A Skip tour button.
- A Finish button to close the walkthrough.

The tour normally appears on first launch and can be replayed from the main menu or the Tools page.

### Automatic settings saving

Lunar Shade automatically saves customisation changes.

Changes are written to the game's configuration after a short delay, rather than waiting for the game to close normally.

This helps preserve settings if the game closes unexpectedly.

---

## Installation

### Part 1: Install the addon

1. Close Garry's Mod.
2. Delete any existing `addons/LunarShade` folder.
3. Extract the ZIP into your Garry's Mod addons folder.
4. Make sure the final folder structure looks like this:

   `garrysmod/addons/LunarShade/addon.json`

   If you see `LunarShade/LunarShade/`, move the inner folder up one level.
5. Start Garry's Mod and load a Sandbox map.
6. Press `Q` and look for the Lunar Shade tab in the top strip.

### Part 2: Install the custom main menu and pause menu

This is a one-time installation step.

Garry's Mod does not allow ordinary addons to draw directly in the main menu or pause menu. Lunar Shade therefore includes an installer that makes a small change to your own copy of:

`garrysmod/lua/menu/menu.lua`

The installer adds a single line at the top of the file to load Lunar Shade's menu code.

**Windows:**

1. Close Garry's Mod.
2. Double-click `Install-MainMenu.bat` in the addon folder.
3. The installer runs `installer/mainmenu.ps1`.
4. You can open and inspect the PowerShell script before running it.

**macOS / Linux:**

Run:

`bash Install-MainMenu.sh`

The installer backs up the original menu file as:

`menu.lua.lunarshade.bak`

Restart Garry's Mod after installation.

**Important:** Re-run the installer after updating Lunar Shade or after a Garry's Mod update. Game updates can overwrite `menu.lua` and remove the added line.

To uninstall the main-menu integration:

- Windows: Run `Uninstall-MainMenu.bat`.
- macOS / Linux: Run `bash Install-MainMenu.sh --uninstall`.

The uninstaller removes the added line and restores the original state of the menu file.

### Dedicated servers

Part 1 can also be installed in the dedicated server's `addons` folder.

Part 2 is client-side only.

---

## Using Lunar Shade

| Section              | Description                                                                                                             |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Appearance**       | Enable or disable the theme, choose an accent colour and select a surface tone.                                         |
| **Custom**           | Move and resize the main menu logo and buttons, change button order, customise Q menu tabs and edit individual colours. |
| **Options > Custom** | Access main menu layout, button and colour controls from the title screen or pause menu.                                |
| **Themes**           | Save your appearance, switch between saved themes, undo a switch and share theme codes.                                 |
| **Interface**        | Adjust corner roundness, accent lines, animations and live preview.                                                     |
| **Main menu**        | Customise the title screen and pause menu.                                                                              |
| **Tools**            | Reapply the theme, reload the spawn menu, open Lunar Shade as a window or reset settings.                               |
| **About**            | View information about Lunar Shade and its current status.                                                              |

---

## Console commands

Open the Garry's Mod console using `~`.

| Command                    | Purpose                                                      |
| -------------------------- | ------------------------------------------------------------ |
| `lunar_shade_diag`         | Display diagnostic information.                              |
| `lunar_shade_verify`       | Check the installed Lunar Shade files.                       |
| `lunar_shade_doctor`       | Check the main menu installation.                            |
| `lunar_shade_apply`        | Reapply the Derma skin.                                      |
| `lunar_shade_reset`        | Reset Lunar Shade settings.                                  |
| `lunar_shade_open`         | Open the Lunar Shade tab.                                    |
| `lunar_shade_window`       | Open Lunar Shade as a window.                                |
| `lunar_shade_reload_menu`  | Rebuild the spawn menu.                                      |
| `lunar_shade_menu_preview` | Preview the customised title screen.                         |
| `lunar_shade_tutorial`     | Replay the welcome tour.                                     |
| `lunar_shade_npcbar`       | Check the NPC options box.                                   |
| `lunar_shade_tabs_reset`   | Restore the original Q menu tab order, names and visibility. |
| `lunar_shade_status`       | Display online status information.                           |

### Online settings

Online checking can be disabled at any time using:

`lunar_shade_online 0`

To view the current online status, run:

`lunar_shade_status`

---

## Online checking and privacy

Lunar Shade can connect to an online service to check for information about the installed version and display important notices.

The online check sends the installed Lunar Shade version and a randomly generated installation ID.

It does not send your Steam ID or Steam username.

The hosting provider may see your IP address when Lunar Shade connects, just like any website.

Online checking can be disabled at any time using:

`lunar_shade_online 0`

If the online service cannot be reached, Lunar Shade continues without receiving updated online information.

---

## Troubleshooting

### Lunar Shade does not appear

1. Check that the addon is installed in the correct `addons` folder.
2. Make sure the folder is named `LunarShade`.
3. Load a Sandbox map.
4. Press `Q` and look for the Lunar Shade tab.
5. Run `lunar_shade_diag` in the console.

### The custom main menu does not appear

1. Close Garry's Mod.
2. Run `Install-MainMenu.bat` again.
3. Restart Garry's Mod.
4. Run `lunar_shade_doctor` if the menu still does not appear.

### The installed files fail verification

Run:

`lunar_shade_verify`

If the problem continues, download Lunar Shade again from its official release page, replace the existing addon folder and run the main-menu installer again.

### Online checking does not work

Run:

`lunar_shade_status`

If the online service cannot be reached, Lunar Shade continues without receiving updated online information.

### Welcome tour does not appear

Run:

`lunar_shade_tutorial`

This manually starts the welcome walkthrough.

---

## What Lunar Shade cannot theme

Garry's Mod has certain interface areas that ordinary addons cannot fully customise.

These include:

- Engine dialogs such as Options, Server Browser and New Game.
- The HUD.
- The chat box.
- The console.
- Addons that draw their own interfaces.
- Panels where another addon forces its own skin.
- HTML-based interfaces created independently by other addons.

Lunar Shade focuses on supported Derma interfaces and its own custom menus.

---

## Compatibility

Lunar Shade is client-side and designed for Garry's Mod Sandbox and Sandbox-derived gamemodes.

Its main-menu integration requires the included installer.

Other addons that deliberately use their own interface skins may not be affected by Lunar Shade.

---

## License

Proprietary.

Copyright © 2026 OfficialRealGahdly.

Personal, non-commercial use of an unmodified copy is allowed, subject to the terms in LICENSE.
