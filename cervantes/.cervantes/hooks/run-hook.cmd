: << 'CMDBLOCK'
@echo off
REM Cross-platform polyglot launcher for Cervantes hook scripts.
REM On Windows cmd.exe runs the batch block below, which locates bash.
REM On Unix the shell skips it: ":" is a no-op and the block is a quoted heredoc.
REM Pattern adapted from the superpowers plugin (MIT).
REM
REM Usage: run-hook.cmd <script-name> [args...]

if "%~1"=="" (
    echo run-hook.cmd: missing script name >&2
    exit /b 1
)

set "HOOK_DIR=%~dp0"

REM Git for Windows, machine-wide (64- and 32-bit) and per-user (the installer's
REM "only for me" option, or winget --scope user).
REM Passing on bash's exit code takes three lines. Inside a parenthesised block
REM %ERRORLEVEL% is expanded before bash runs, and a bare "exit /b" reports 0
REM under "cmd /c". So: "call set" reads it after bash, then delayed expansion
REM (switched on only now, so a "!" in the folder path is never touched) hands
REM it to "exit /b". No labels or goto on purpose: this file is LF-only, and
REM cmd.exe's label search is unreliable in LF-only batch files.
if exist "%ProgramFiles%\Git\bin\bash.exe" (
    "%ProgramFiles%\Git\bin\bash.exe" "%HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
    call set "CERVANTES_RC=%%ERRORLEVEL%%"
    setlocal EnableDelayedExpansion
    exit /b !CERVANTES_RC!
)
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" "%HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
    call set "CERVANTES_RC=%%ERRORLEVEL%%"
    setlocal EnableDelayedExpansion
    exit /b !CERVANTES_RC!
)
if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
    "C:\Program Files (x86)\Git\bin\bash.exe" "%HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
    call set "CERVANTES_RC=%%ERRORLEVEL%%"
    setlocal EnableDelayedExpansion
    exit /b !CERVANTES_RC!
)
if exist "%LOCALAPPDATA%\Programs\Git\bin\bash.exe" (
    "%LOCALAPPDATA%\Programs\Git\bin\bash.exe" "%HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
    call set "CERVANTES_RC=%%ERRORLEVEL%%"
    setlocal EnableDelayedExpansion
    exit /b !CERVANTES_RC!
)

REM Any other bash on the PATH, except the WSL launchers (System32\bash.exe and
REM the WindowsApps alias): they run Linux, not this folder's Windows paths.
for /f "delims=" %%B in ('where bash 2^>nul') do (
    if /i not "%%~dpB"=="%SystemRoot%\System32\" if /i not "%%~dpB"=="%LOCALAPPDATA%\Microsoft\WindowsApps\" (
        "%%~B" "%HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
        call set "CERVANTES_RC=%%ERRORLEVEL%%"
        setlocal EnableDelayedExpansion
        exit /b !CERVANTES_RC!
    )
)

REM No bash available. Exit clean: the workspace CLAUDE.md still governs,
REM it just falls back to checking its own health.
exit /b 0
CMDBLOCK

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="$1"
shift
exec bash "${SCRIPT_DIR}/${SCRIPT_NAME}" "$@"
