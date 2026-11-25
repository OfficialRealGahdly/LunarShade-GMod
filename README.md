# Lunar Shade

Lunar Shade is a customizable interface overhaul for Garry's Mod. It includes its own spawn menu tab, custom main menu, pause menu, and a wide range of appearance and layout options.

Customize your interface with different colours, surface styles, backgrounds, and layouts to make Garry's Mod look the way you want.

**Made by OfficialRealGahdly**

Client-side only · Designed for Sandbox and Sandbox-derived gamemodes.

---

## Features

### Interface and appearance

- **Customizable appearance:** Change the look of supported Garry's Mod menus.
- **Lunar Shade tab:** Access Lunar Shade directly from the spawn menu by pressing `Q`.
- **Settings panel:** Manage the theme and customize its appearance.
- **Accent colours:** Choose from six presets or create your own colours.
- **Surface styles:** Choose between Midnight, Obsidian, and Slate.
- **Interface styling:** Adjust corner roundness, window accent lines, and animations.
- **Live preview:** See appearance changes as you make them.
- **Derma skin:** Restyles standard Derma frames, buttons, text boxes, checkboxes, combo boxes, sliders, tabs, scroll bars, lists, trees, menus, and tooltips.
- **Compatibility:** Panels that another addon deliberately skins are left alone rather than forcibly restyled.

### Customization

The Custom page gives you control over the appearance and layout of Lunar Shade.

- Move and resize the main menu logo and button column.
- Reorder main menu buttons.
- Hide main menu buttons.
- Move, rename, and reorder spawn menu tabs.
- Hide spawn menu tabs. The Lunar Shade tab cannot be hidden.
- Change individual interface colours.
- Use the colour mixer or enter hexadecimal colour codes.
- Reset individual colours to their defaults.
- Preview your custom layout before using it.

The main-menu **Options > Custom** page provides main menu layout, button, and colour controls without needing to start a game.

Options itself can never be hidden, so you can always access your settings.

Spawn menu tab customization is available in-game through the Lunar Shade tab.

### Main menu

Lunar Shade includes its own customizable main menu.

- Animated night sky.
- Spinning moon.
- Custom accent colours.
- Customizable logo and button positions.
- Reorderable and hideable menu buttons.
- Multiple background options.
- Option to return to the original main menu.

Available backgrounds:

- **Night sky:** The original animated background.
- **No stars:** Moon and hills without stars, aurora, or shooting stars.
- **Gradient:** A background using two colours of your choice.
- **Plain:** A single-colour background.

Plain and Gradient backgrounds stop the background animation to minimize drawing overhead.

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

Preview your customized title screen without leaving your current game.

The preview includes:

- Custom logo and button positions.
- Button order and visibility.
- Selected background.
- Custom colours.
- Main menu and pause menu previews.

Open the preview from the Custom page or by using:

`lunar_shade_menu_preview`

### Saved themes

Save and switch between your own Lunar Shade appearances.

Saved themes can include:

- Accent colour.
- Surface tone.
- Interface shape.
- Individual colours.
- Main menu layout.
- Spawn menu tab order, names, and visibility.

You can name themes, switch between them, undo a switch, and copy a theme code to share with others.

### Welcome tours

Lunar Shade includes walkthroughs to help new users understand its features.

- Main menu welcome tour.
- In-game welcome tour with the same visual design.
- Numbered steps and navigation indicators.
- Skip and Finish buttons.
- Option to replay the walkthrough from the main menu or Tools page.

### Automatic settings saving

Lunar Shade automatically saves customization changes.

Changes are written to the game's configuration after a short delay instead of waiting for the game to close.

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
6. Press `Q` and look for the Lunar Shade tab.

### Part 2: Install the custom main menu and pause menu

This is a one-time installation step.

Garry's Mod does not allow ordinary addons to draw directly in the main menu or pause menu. Lunar Shade includes an installer that makes a small change to your copy of:

`garrysmod/lua/menu/menu.lua`

**Windows:**

1. Close Garry's Mod.
2. Double-click `Install-MainMenu.bat` in the addon folder.
3. Follow the installer instructions.

**macOS / Linux:**

Run:

`bash Install-MainMenu.sh`

The installer backs up the original menu file as:

`menu.lua.lunarshade.bak`

Restart Garry's Mod after installation.

**Important:** Re-run the installer after updating Lunar Shade or after a Garry's Mod update. Game updates can overwrite `menu.lua` and remove the added line.

To uninstall the main menu integration:

- Windows: Run `Uninstall-MainMenu.bat`.
- macOS / Linux: Run `bash Install-MainMenu.sh --uninstall`.

### Dedicated servers

Part 1 can also be installed in a dedicated server's `addons` folder.

Part 2 is client-side only.

---

## Using Lunar Shade

| Section              | Description                                                                                |
| -------------------- | ------------------------------------------------------------------------------------------ |
| **Appearance**       | Enable or disable the theme, choose an accent colour, and select a surface style.          |
| **Custom**           | Adjust the main menu layout, button order, spawn menu tabs, and individual colours.        |
| **Options > Custom** | Access main menu layout, button, and colour controls from the title screen or pause menu.  |
| **Themes**           | Save appearances, switch between themes, undo a switch, and share theme codes.             |
| **Interface**        | Adjust corner roundness, accent lines, animations, and live preview.                       |
| **Main menu**        | Customize the title screen and pause menu.                                                 |
| **Tools**            | Reapply the theme, reload the spawn menu, open Lunar Shade as a window, or reset settings. |
| **About**            | View information about Lunar Shade and its current status.                                 |

---

## Console commands

Open the Garry's Mod console using `~`.

| Command                    | Purpose                                                           |
| -------------------------- | ----------------------------------------------------------------- |
| `lunar_shade_diag`         | Display diagnostic information.                                   |
| `lunar_shade_doctor`       | Check the main menu installation.                                 |
| `lunar_shade_apply`        | Reapply the Derma skin.                                           |
| `lunar_shade_reset`        | Reset Lunar Shade settings.                                       |
| `lunar_shade_open`         | Open the Lunar Shade tab.                                         |
| `lunar_shade_window`       | Open Lunar Shade as a window.                                     |
| `lunar_shade_reload_menu`  | Rebuild the spawn menu.                                           |
| `lunar_shade_menu_preview` | Preview the customized title screen.                              |
| `lunar_shade_tutorial`     | Replay the welcome tour.                                          |
| `lunar_shade_tabs_reset`   | Restore the original spawn menu tab order, names, and visibility. |
| `lunar_shade_status`       | Display online status information.                                |

### Online settings

Online checking can be disabled using:

`lunar_shade_online 0`

To view the current online status, run:

`lunar_shade_status`

---

## Online checking and privacy

Lunar Shade can connect to an online service to check the status of the installed version.

The online check sends the installed Lunar Shade version and a randomly generated installation ID.

It does not send your Steam ID or Steam username.

The hosting provider may see your IP address when Lunar Shade connects, just like a website.

Online checking can be disabled at any time using:

`lunar_shade_online 0`

If the online service cannot be reached, Lunar Shade continues to work without updated online status information.

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

### Online checking does not work

Run:

`lunar_shade_status`

If the online service cannot be reached, Lunar Shade continues without updated online status information.

### Welcome tour does not appear

Run:

`lunar_shade_tutorial`

This manually starts the welcome walkthrough.

---

## What Lunar Shade cannot customize

Some Garry's Mod interface areas cannot be fully customized by ordinary addons.

These include:

- Engine dialogs such as Options, Server Browser, and New Game.
- The HUD.
- The chat box.
- The console.
- Addons that draw their own interfaces.
- Panels where another addon forces its own skin.
- Independent HTML interfaces created by other addons.

Lunar Shade focuses on supported Derma interfaces and its own custom menus.

---

## Compatibility

Lunar Shade is client-side and designed for Garry's Mod Sandbox and Sandbox-derived gamemodes.

Its main menu integration requires the included installer.

Other addons that deliberately use their own interface skins may not be affected by Lunar Shade.

---

## License

Proprietary.

Copyright © 2026 OfficialRealGahdly.

Personal, non-commercial use of an unmodified copy is allowed, subject to the terms in LICENSE.
