# Lunar Shade

A dark interface theme for Garry's Mod with its own **Lunar Shade tab in the spawn menu**, a settings panel, and a Derma skin that restyles menus built from standard Derma controls.

Made by **OfficialRealGahdly**. Version 1.0.0 · Client-side only · Works with Sandbox and Sandbox-derived gamemodes.

## Features

- **Spawn menu tab.** Press `Q`: "Lunar Shade" sits beside Spawnlists, Weapons, Entities and the others.
- **Settings panel.** Enable or disable the theme, six accent presets plus a custom colour mixer, three surface tones (Midnight, Obsidian, Slate), corner roundness, accent line on windows, animations, live preview.
- **Custom page (1.1.0 to 1.5.5).** Drag the logo and the button column to anywhere on the title screen, resize them, reorder or hide menu buttons, move, rename or hide the tabs along the top of the Q menu (the Lunar Shade tab can never be hidden), and change twenty colours with a Reset on each: nine for the menus (background, panels, buttons, hover, borders, four text shades) and nine for the main menu itself (moon, logo text in two parts, splash text, button hover, three aurora ribbons, delete buttons).
- **Custom tab in the main menu's Options (Update 5).** Open Options on the title screen or the pause menu and pick the **Custom** tab: the same layout sliders, button order and hide controls, and all twenty colours (click a colour's box to mix it, or type a hex code) without starting a game. Changes show at once and are saved into your Lunar Shade settings the next time the game is running (immediately when you are in a game). Options itself can never be hidden, so you can always get back. (1.4.3: the Options page now stays open while you change things, and your changes are remembered even if the settings file cannot be read back. After updating, re-run Install-MainMenu: the main menu uses its own copy of the files.) Q menu tabs are still changed in the game, on the Custom page of the Lunar Shade tab.
- **Main menu background (1.5.0).** On the Custom page (and Options > Custom on the main menu) pick Night sky (the original), No stars (moon and hills, no stars, aurora or shooting star), Gradient (two colours of your choice) or Plain (one colour). Plain and Gradient also stop the animation, so they cost almost nothing to draw. The pause menu always shows your game behind it.
- **Layout preview in-game (1.5.0).** "Preview this layout full-screen" (Custom page), the Main menu page and `lunar_shade_menu_preview` now show the title screen with your own layout, button order, hidden buttons, background and colours. A button in the preview switches between the main menu and the pause menu view. After updating, re-run Install-MainMenu.
- **Signed release check.** Every official download carries a manifest of all its files (names and SHA-256 hashes) signed with the author's private key, which is never part of the addon. At startup Lunar Shade checks the signature with its built-in public key, then looks for changed, missing and unexpected files. **Fails closed:** if the check fails or cannot run, Lunar Shade switches itself off (no features load); Garry's Mod and other addons are never touched. Run `lunar_shade_verify` to see the result. Silent when everything matches.
- **Signed online check (1.5.5).** The status reply must now be signed with the author's secret key and made for your own install. Unsigned, old or altered replies are ignored, so nobody can fake a notice or switch the theme off. `lunar_shade_status` shows why a reply was not trusted.
- **NPC options box (1.5.1, moved to the corner in 1.5.3).** Disable Thinking, Ignore Players, Keep Corpses, Join Player's Squad and Weapon Override now sit in a small box in the bottom-left corner of the Q menu on every tab except Spawnlists (the NPCs tab already has them). Turn it off on the Custom page. If it does not show, run `lunar_shade_npcbar` in the console (1.5.2).
- **Fix (1.5.0).** Once you had reordered the menu buttons, the pause menu lost its spacing after Resume Game. The pause menu now keeps its own spacing.
- **Saved themes (1.4.1).** Name your current look (accent, surface tone, shape, every colour, main menu layout, Q menu tab order, names and hidden tabs), save it, switch between saved themes in one click, undo a switch, and copy a theme code to send to a friend or paste one they sent you.
- **Custom main menu** (needs Part 2 below). An animated night sky with a spinning moon, your accent colour, and a "Classic menu" button that always brings the original back.
- **Custom pause menu.** Press `Esc` in a game and you get the same menu (Resume, Disconnect, Options, Addons, Dupes, Saves, Demos, Mod Files) over a dimmed view of your game. Needs Part 2. Turn it off in the Main menu page of the Lunar Shade tab.
- **Welcome tour.** A short first-launch walkthrough. Replay it from the title screen or the Tools page.
- **Broad coverage.** One Derma skin restyles frames, buttons, text boxes, check boxes, combo boxes, sliders, tabs, scroll bars, lists, trees, menus and tooltips. Panels that another addon deliberately skins are left alone.

## Installation

**Part 1: the addon**

1. Close Garry's Mod. **Delete any existing `addons/LunarShade` folder first.**
2. Extract this ZIP into your addons folder so you end up with `garrysmod/addons/LunarShade/addon.json`.
   If you see `LunarShade/LunarShade/`, move the inner folder up one level.
3. Start Garry's Mod and load a Sandbox map. Press `Q`: the **Lunar Shade** tab is in the top strip.

**Part 2: the custom main menu and pause menu (one-time, 10 seconds)**

Garry's Mod does not let an addon draw anything in the main menu or the pause menu by itself — only a small set of its own files run there. To show Lunar Shade in those two places, the installer makes one small, text-only edit to your own copy of `garrysmod/lua/menu/menu.lua`: it adds a single line at the top of the file that loads Lunar Shade's menu code. Nothing else in that file is touched, no other file on your computer is changed, and the original line is removed in full if you uninstall.

- **Windows:** close the game and double-click **`Install-MainMenu.bat`** in the addon folder. It runs `installer/mainmenu.ps1`, which you're welcome to open and read first — it's plain-text PowerShell, not compiled.
- **macOS / Linux:** run `bash Install-MainMenu.sh` from the addon folder.

The installer backs up your original `menu.lua` next to itself (`menu.lua.lunarshade.bak`) before changing anything, so you can restore it by hand at any time even without Lunar Shade installed.

Restart the game. Re-run it after updating Lunar Shade or after a Garry's Mod update (a game update can overwrite `menu.lua` and remove the line). **Uninstall-MainMenu.bat** (or `bash Install-MainMenu.sh --uninstall`) removes the added line and everything else Part 2 put in place, leaving `menu.lua` exactly as it was before. The `.bak` copy is there as a manual fallback if you ever need it.

On a dedicated server, install Part 1 in the server's `addons` folder too. Part 2 is client-only.

## Release check and privacy

At startup, and whenever you run `lunar_shade_verify`, Lunar Shade compares its own files with `lua/lunar_shade/sh_manifest.lua`, a list of every file in the official release with its SHA-256 hash, signed by the author (RSA-3072). The check runs entirely on your computer and sends nothing anywhere. If it does not end in "verified" (changed, missing or unexpected files, a bad signature, or the check could not run), **Lunar Shade locks itself**: none of its features load and it writes `data/lunar_shade_locked.txt` so the custom main menu stays off on the next start too. It only ever switches itself off: it never touches Garry's Mod or other addons, never removes a file and never changes a setting. To recover, download Lunar Shade again from the official page, replace the folder, re-run Install-MainMenu, and start a game; a clean check removes the lock.

- **Changed, missing or unexpected files** are listed in the console. If you edited Lunar Shade yourself, or an old copy of the main menu files is still installed, that is what you will see. After updating, run Install-MainMenu again, as before.
- **README, LICENSE, installers and addon.json** are only checked when Lunar Shade is in a normal `addons` folder. A Workshop install does not contain them, so they are skipped, not counted as errors.
- **Not tamper-proof.** The public key is inside the addon, so the check tells you whether a copy matches the author's signed release; it cannot stop someone who rewrites the whole addon. Only download Lunar Shade from the official page.
- **File protection is not secrecy.** Most of Lunar Shade's Lua files are stored encrypted and authenticated (ChaCha20-Poly1305), so a modified, damaged or swapped file is rejected instead of run. The key has to be on your computer for the game to read the files, so anyone running the addon can still recover the Lua. This is tamper-evidence, not copy protection.

## Online check and privacy

At startup Lunar Shade can ask the author's status page whether a newer version exists and whether there is a notice to show. It sends only the addon version and a random install ID made on your computer (never your Steam ID or name). The web host can see your IP address, as any website can. If the check cannot connect, nothing changes. It never runs code from the server.

Every reply must carry a valid RSA-3072 / PKCS#1 v1.5 / SHA-256 signature made with the author's private key. Unlike the older shared-secret scheme, nothing in the addon can be used to forge a reply: the addon holds only the matching public key, which can check a signature but not make one. If the author switches a version or install off, Lunar Shade locks itself the same way a failed release check does (see above) rather than just flipping a setting.

Turn it off any time with `lunar_shade_online 0`. See what it found with `lunar_shade_status`.

## If something is wrong

To check the install, open the console (`~`) and run `lunar_shade_diag`.

## Using it

| Where | What |
| --- | --- |
| **Appearance** | Theme on/off, accent preset or custom colour, surface tone |
| **Custom** | Move and resize the main menu logo and buttons, reorder or hide buttons, reorder, rename or hide the Q menu tabs, change colours one by one |
| **Options > Custom** (main menu) | The same layout, button and colour controls, from the title screen or pause menu |
| **Themes** | Save your whole look under a name, apply it later, undo a switch, copy or paste a theme code |
| **Interface** | Corner roundness, accent line, animations, live preview |
| **Tools** | Reapply theme, reload spawn menu, open as a window, reset to defaults |
| **About** | Live status and what is and is not themed |

Console commands: `lunar_shade_diag` (status), `lunar_shade_verify` (check this copy against the signed release), `lunar_shade_doctor` (check the main menu install), `lunar_shade_apply` (reapply the skin), `lunar_shade_reset` (reset settings), `lunar_shade_open` / `lunar_shade_window` (open the tab), `lunar_shade_reload_menu` (rebuild the spawn menu), `lunar_shade_menu_preview` (preview the title screen), `lunar_shade_tutorial` (replay the welcome tour), `lunar_shade_npcbar` (check the NPC options bar), `lunar_shade_tabs_reset` (put the Q menu tabs back to stock order, names and visibility).

## What it cannot theme

Engine dialogs (Options, Server Browser, New Game), the HUD, chat box and console, addons that draw their own UI or use HTML panels, and panels where an addon forces its own skin.

## License

Proprietary, (c) 2026 OfficialRealGahdly. Personal, non-commercial use of an unmodified copy is allowed; see [LICENSE](LICENSE).
