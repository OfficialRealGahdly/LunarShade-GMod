# Lunar Shade

Lunar Shade is an interface customization tool for Garry’s Mod. This mod offers its own spawn menu tab, custom main menu, pause menu, and many other options to customize the appearance of the game.

You can change colors, surfaces, backgrounds, layouts and more to get the desired appearance for Garry’s Mod.

**Created by OfficialRealGahdly**

Client-side only · Made for Sandbox gamemode.

---

## Features

### Interface and Appearance

- **Appearance customization:** Customize the appearance of compatible Garry's Mod menus.
- **Lunar Shade tab:** Access Lunar Shade from the spawn menu using `Q` key.
- **Settings tab:** Theme settings and appearance customization.
- **Accent colors:** Six presets or custom colors.
- **Surface styles:** Select from Midnight, Obsidian, and Slate.
- **Interface style:** Customization of corner rounding, accent lines for windows, and animations.
- **Live preview:** Observe changes to the appearance in real time.
- **Derma skin:** Skin of default Derma frames, buttons, text entry, check box, combo box, sliders, tabs, scroll bars, lists, trees, menus, and tooltips.
- **Compatibility:** Panels intentionally skinned by other addons are left unchanged.

### Customization

On the Custom page, you can customize how Lunar Shade will look and behave.

- Drag and resize the logo and button column of the main menu.
- Rearrange main menu buttons.
- Remove main menu buttons.
- Drag and rearrange spawn menu tabs.
- Remove spawn menu tabs. The tab named Lunar Shade cannot be removed.
- Change individual colors on the interface.
- You may use color mixer or specify hex code for the colors.
- Return individual colors to the default state.
- Preview your customization before applying.

The main-menu **Options > Custom** page allows for controlling main menu layouts and colors without starting the game.

It is not possible to remove Options itself, so you will always have access to your settings.

Spawn menu tab customization is possible only in-game through the Lunar Shade tab.

### Main menu

Lunar Shade comes with a built-in customisable main menu.

- Animated night sky.
- Spinning moon.
- Custom accent colours.
- Customisable logo and button positioning.
- Rearrangeable and concealable menu buttons.
- Choice of multiple backgrounds.
- Ability to revert to default main menu.

Backgrounds available:

- **Night sky:** The original animated background.
- **No stars:** Moon and hills without stars, auroras, and shooting stars.
- **Gradient:** Background using two colours of your choice.
- **Plain:** A simple coloured background.

Gradient and Plain backgrounds turn off the background animation in order to reduce drawing overhead.

### Pause menu

The customizable pause menu will appear once you hit `Esc` during gameplay.

You will see the game in the background through the darkened menu screen, which features the following options:

- Resume Game
- Disconnect
- Options
- Addons
- Duplications
- Saves
- Demos
- Mod Files

The pause menu utilizes your Lunar Shade style and can be turned off on the Main menu page of Lunar Shade settings.

### Preview Layout

See your own custom title screen preview without leaving your currently active game.

The preview contains:

- Your custom logo and buttons positioning.
- Positioning and visibility of buttons.
- Your chosen background.
- Custom colors.
- Previews for your main menu and pause menu.

Access the preview from Custom screen or use:

`lunar_shade_menu_preview`

### Stored themes

Store and switch between custom Lunar Shade themes.

Stored themes may include:

- Accent color.
- Surface color.
- Interface shape.
- Specific colors.
- Layout of the main menu.
- Layout and names of the tabs in spawn menu.

Themed can be named, switched, canceled and copied into theme code for sharing with other people.

### Welcome tours

Lunar Shade provides guided tours to help new users learn about its features.

- Welcome tour in the main menu.
- In-game welcome tour using the same graphic interface.
- Step numbers and navigational hints.
- Skip and Finish buttons.
- Replay option available from the main menu and Tools page.

### Auto-saving settings

Lunar Shade auto-saves all customizations.

All changes will be saved in the game's configuration file with a small delay.

---

## Installation

### Step 1: Installing the addon

1. Close Garry's Mod.
2. Delete any existing `addons/LunarShade` directory.
3. Unzip the file into your Garry's Mod addons directory.
4. Ensure that your final directory layout is as follows:

   `garrysmod/addons/LunarShade/addon.json`

   If you have `LunarShade/LunarShade/`, move the inner directory back one level.
5. Launch Garry's Mod and enter a Sandbox map.
6. Press `Q` and find the Lunar Shade tab.

### Step 2: Installing the custom main menu and pause menu

One-time installation procedure.

In Garry's Mod, it is impossible to draw directly from an ordinary addon in the main menu and pause menu. Lunar Shade provides an installer that makes a minor edit to your copy of:

`garrysmod/lua/menu/menu.lua`

**Windows:**

1. Exit Garry's Mod.
2. Double click on `Install-MainMenu.bat` within the addon folder.
3. Proceed with the installer wizard.

**macOS / Linux:**

Execute:

`bash Install-MainMenu.sh`

The installer makes a backup of the original menu file as:

`menu.lua.lunarshade.bak`

Relaunch Garry's Mod after the installation is complete.

**Note:** Redo the installer after any updates to Lunar Shade and Garry's Mod. Any game updates might overwrite `menu.lua` and will undo the changes.

To uninstall the main menu plugin:

- Windows: Run `Uninstall-MainMenu.bat`.
- macOS / Linux: Run `bash Install-MainMenu.sh --uninstall`.

### Dedicated servers

The first part of the guide can also be done on a dedicated server `addons` directory.

The second part is client-side only.

---

## Lunar Shade Interface Usage

| Section              | Description                                                                                  |
| -------------------- | -------------------------------------------------------------------------------------------- |
| **Appearance**       | Turn the theme on or off, choose an accent colour, and select a surface style.               |
| **Custom**           | Change the layout, button order, spawn menu tabs, and individual colours.                    |
| **Options > Custom** | Adjust the layout, buttons, and colour options from the title screen or pause menu.          |
| **Themes**           | Save appearances, switch between themes, undo a switch, and share theme codes.               |
| **Interface**        | Adjust corner roundness, accent lines, animations, and previews.                             |
| **Main menu**        | Customize the main menu and pause menu.                                                      |
| **Tools**            | Reapply the theme, refresh the spawn menu, open Lunar Shade in window mode, or reset options.|
| **About**            | View Lunar Shade information and its current status.                                         |

---

## Console commands

To access the Garry's Mod console, press `~`.

| Command                    | Purpose                                                           |
| -------------------------- | ----------------------------------------------------------------- |
| `lunar_shade_diag`         | Show diagnostic information.                                      |
| `lunar_shade_doctor`       | Check the installation of the main menu.                          |
| `lunar_shade_apply`        | Apply the Derma skin.                                             |
| `lunar_shade_reset`        | Reset all Lunar Shade settings.                                   |
| `lunar_shade_open`         | Open the Lunar Shade tab.                                         |
| `lunar_shade_window`       | Open Lunar Shade in window mode.                                  |
| `lunar_shade_reload_menu`  | Refresh the spawn menu.                                           |
| `lunar_shade_menu_preview` | Preview the modified title screen.                                |
| `lunar_shade_tutorial`     | Reopen the tutorial.                                              |
| `lunar_shade_tabs_reset`   | Restore the original spawn menu tab order, names, and visibility. |

### Online configurations

Online verification can be turned off with:

`lunar_shade_online 0`

Current online status can be viewed with:

`lunar_shade_status`

---

## Online verification and privacy

Lunar Shade is able to reach out to an online server and verify the installed version.

The information which the online verification will transmit includes installed version of Lunar Shade and randomly generated installation ID.

Your Steam ID and/or Steam username will not be transmitted.

Hosting company may be able to see your IP address when Lunar Shade reaches out to their servers, just like a website would.

Online verification can be turned off anytime with:

`lunar_shade_online 0`

If the online server is unavailable for any reason, Lunar Shade will continue to work with outdated information.

---

## Troubleshooting

### Lunar Shade does not show up

1. Verify that the addon is properly placed in the `addons` directory.
2. Ensure the folder name is called `LunarShade`.
3. Load up a map from the Sandbox environment.
4. Press `Q` and see if the Lunar Shade tab is there.
5. Type in `lunar_shade_diag` in the console.

### Main menu skin does not appear

1. Close Garry's Mod.
2. Re-run `Install-MainMenu.bat`.
3. Open Garry's Mod.
4. If problem persists, try typing `lunar_shade_doctor` in the console.

### Online checking doesn’t work

Type in the following command:

`lunar_shade_status`

If the online server can't be reached, then Lunar Shade will proceed without any updated online status information.

### Welcome tutorial doesn’t show up

Type in the following command:

`lunar_shade_tutorial`

---

## What Lunar Shade can’t customize

There are parts of the Garry's Mod UI that simply can’t be customized using a regular addon.

They are:

- Engine menus, including Options, Server Browser, and New Game.
- The HUD.
- The chat box.
- The console.
- Addons which create their own UI elements.
- Panels, where some other addon overrides the default skin.
- HTML panels created by other addons.

Lunar Shade concentrates on customizing its own Derma and custom menus only.

---

## Compatibility

Lunar Shade is client-sided and made for Garry's Mod Sandbox and Sandbox derived game modes.

The integration of its menu requires the included installer.

Other add-ons which specifically use their own interface skins are unlikely to be affected by Lunar Shade.

---

## License

Proprietary.

© 2026 OfficialRealGahdly.

Use of this unaltered copy for personal, non-commercial purposes is permitted, as per the provisions in LICENSE.
