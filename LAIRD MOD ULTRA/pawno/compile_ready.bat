@echo off
setlocal
cd /d "%~dp0.."
if not exist logs mkdir logs
"pawno\pawncc.exe" "gamemodes\shanyrak.pwn" -i"pawno\include" -o"gamemodes\shanyrak.amx" > "logs\compile.log" 2>&1
set ERR=%ERRORLEVEL%
echo.>>"logs\compile.log"
echo Exit code: %ERR%>>"logs\compile.log"
if not "%ERR%"=="0" (
  echo Compilation failed. See logs\compile.log
) else (
  echo Compilation succeeded: gamemodes\shanyrak.amx
)
exit /b %ERR%
