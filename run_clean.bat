@echo off
echo Starting Flutter with filtered logs...
echo.
flutter run 2>&1 | findstr /V /C:"OplusFeedbackInfo"
