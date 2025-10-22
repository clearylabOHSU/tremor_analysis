@echo off
setlocal enabledelayedexpansion

REM ===== Settings to tweak =====
set "APPNAME=HIFU-Spiral"
set "MAINPY=SpiralDrawUI.py"

REM ===== Go to the script's directory =====
cd /d "%~dp0"

REM ===== Create/activate venv =====
if not exist .venv (
  echo [INFO] Creating virtual environment...
  py -m venv .venv
)
call ".venv\Scripts\activate.bat" || (echo [ERROR] Could not activate venv.& pause & exit /b 1)

REM ===== Upgrade pip/wheel =====
python -m pip install -U pip wheel

REM ===== Install dependencies =====
if exist requirements.txt (
  echo [INFO] Installing from requirements.txt ...
  pip install -r requirements.txt
) else (
  echo [WARN] No requirements.txt found. Skipping dependency install.
)

REM ===== Clean previous build outputs =====
if exist build rd /s /q build
if exist dist rd /s /q dist

REM ===== Build (ONEDIR for first run) =====
echo [INFO] Building onefile EXE ...

pyinstaller ^
  --clean ^
  --log-level=DEBUG ^
  --onefile ^
  --noconsole ^
  --name "%APPNAME%" ^
  --add-data "spiralDraw.ui;." ^
  --add-data "ims;ims" ^
  --add-binary "dll/*.dll;dll" ^
  "%MAINPY%"
  
if errorlevel 1 (
  echo [ERROR] PyInstaller failed.
  pause
  exit /b 1
)

echo.
echo [SUCCESS]  build ready:
echo   dist\%APPNAME%.exe
pause
