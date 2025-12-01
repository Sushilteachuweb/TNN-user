# Flutter run with filtered logs (removes OplusFeedbackInfo spam)
Write-Host "Starting Flutter with clean logs..." -ForegroundColor Green
Write-Host ""

flutter run 2>&1 | Where-Object { $_ -notmatch "OplusFeedbackInfo" }
