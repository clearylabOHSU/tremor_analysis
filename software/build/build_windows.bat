@echo off
setlocal enabledelayedexpansion

REM ===== Settings you can tweak =====
set "APPNAME=HIFU-Spiral"
set "MAINPY=SpiralDrawUI.py"   REM change if your main file has a different name

REM ===== Go to the script's directory (repo root) =====
cd /d "%~dp0"

REM ===== Check Python launcher =====
where py >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Python launcher "py" not found. Install Python from python.org and make sure "py" is on PATH.
  pause
  exit /b 1
)

REM ===== Create/activate venv =====
if not exist .venv (
  echo [INFO] Creating virtual environment...
  py -m venv .venv
)
call ".venv\Scripts\activate.bat"
if errorlevel 1 (
  echo [ERROR] Could not activate venv.
  pause
  exit /b 1
)

REM ===== Upgrade pip/wheel =====
python -m pip install -U pip wheel

REM ===== Install deps =====
if exist requirements.txt (
  echo [INFO] Installing from requirements.txt ...
  pip install -r requirements.txt
) else (
  echo [INFO] Installing default deps ...
  pip install pyinstaller PyQt5 reportlab matplotlib bleak metawear
)

REM ===== Clean previous build bits (optional) =====
if exist build rd /s /q build
if exist dist rd /s /q dist
if exist "%APPNAME%.spec" del "%APPNAME%.spec"

REM ===== Build (onefile) =====
echo [INFO] Building onefile EXE...
pyinstaller ^
  --onefile --noconsole ^
  --name "%APPNAME%" ^
  --collect-plugins PyQt5 ^
  --collect-submodules bleak ^
  --collect-binaries bleak ^
  --collect-submodules metawear ^
  --collect-binaries metawear ^
  --collect-binaries warble ^
  --collect-binaries mbientlab.metawear ^
  --add-data "spiralDraw.ui;." ^
  --add-data "ims;ims" ^
  "%MAINPY%"

if errorlevel 1 (
  echo [ERROR] PyInstaller failed.
  pause
  exit /b 1
)

echo.
echo [SUCCESS] EXE ready: dist\%APPNAME%.exe
echo        You can move/copy that .exe anywhere.
pause
