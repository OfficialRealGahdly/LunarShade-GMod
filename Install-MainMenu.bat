@echo off
title Lunar Shade - install main menu
set "PS1=%~dp0installer\mainmenu.ps1"
if not exist "%PS1%" goto missing
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
goto done
:missing
echo.
echo The installer script was not found (installer\mainmenu.ps1).
echo Extract the full Lunar Shade download again, then run this again.
:done
echo.
pause
