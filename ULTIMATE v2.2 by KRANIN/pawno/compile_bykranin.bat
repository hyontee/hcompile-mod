@echo off
chcp 1251 > nul
cd /d "%~dp0"
pawncc.exe "..\gamemodes\bykranin.pwn" "-iinclude" "-i..\include" "-o..\gamemodes\bykranin.amx"
if errorlevel 1 (
    echo.
    echo Compilation failed. Check the errors above.
) else (
    echo.
    echo Compilation completed: gamemodes\bykranin.amx
)
pause
