@echo off
echo Stopping OplusFeedbackInfo logs...
echo.

REM Try common ADB locations
set ADB_PATH=

if exist "%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" (
    set ADB_PATH=%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe
) else if exist "C:\Users\%USERNAME%\AppData\Local\Android\Sdk\platform-tools\adb.exe" (
    set ADB_PATH=C:\Users\%USERNAME%\AppData\Local\Android\Sdk\platform-tools\adb.exe
) else if exist "C:\Android\Sdk\platform-tools\adb.exe" (
    set ADB_PATH=C:\Android\Sdk\platform-tools\adb.exe
) else if exist "C:\flutter\bin\cache\artifacts\engine\android-arm-release\adb.exe" (
    set ADB_PATH=C:\flutter\bin\cache\artifacts\engine\android-arm-release\adb.exe
) else (
    echo ERROR: Could not find adb.exe
    echo.
    echo Please run this command manually in Android Studio Terminal:
    echo flutter run 2^>^&1 ^| findstr /V "OplusFeedbackInfo"
    echo.
    pause
    exit /b 1
)

echo Found ADB at: %ADB_PATH%
echo.

"%ADB_PATH%" shell "setprop log.tag.OplusFeedbackInfo S"

if %ERRORLEVEL% EQU 0 (
    echo SUCCESS! OplusFeedbackInfo logs are now disabled.
    echo.
    echo Now run your app from Android Studio - the logs won't appear anymore!
) else (
    echo.
    echo Could not disable logs. Make sure your device is connected.
    echo Run: flutter devices
)

echo.
pause
