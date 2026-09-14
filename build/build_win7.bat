@echo off
REM Build Isam AULauncher for Windows 7 using Python 3.8
REM Move directory context up to the repository root
cd /d "%~dp0.."

if not exist "venv38\Scripts\activate.bat" (
    echo Error: venv38 environment not found in root directory.
    pause
    exit /b 1
)

call venv38\Scripts\activate.bat

echo Installing/Verifying Win7 Launcher Requirements...
python --version
pip install -r build\requirements7.txt
pip install requests pypresence PySide6==6.1.3

if not exist "dist\win7" mkdir dist\win7

echo Building PyInstaller launcher binary targeting Windows 7...
pyinstaller --noconfirm --onedir --windowed --noupx ^
  --name IsamAULauncher ^
  --distpath dist\win7 ^
  --icon src\launcher\resources\icon.ico ^
  --add-data "src\launcher\resources\icon.ico;resources" ^
  --add-data "release\bepmods.zip;." ^
  --collect-all dearpygui ^
  --collect-all pywin32 ^
  --collect-all PySide6 ^
  src\launcher\main.py

echo.
echo Successfully built Windows 7 Launcher: dist\win7\IsamAULauncher\
pause