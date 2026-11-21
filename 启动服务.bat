@echo off
chcp 65001 >nul
cd /d "%~dp0"

set "APP_DIR=%~dp0"
if exist "%~dp0创.ico" powershell -NoProfile -ExecutionPolicy Bypass -Command "$base=$env:APP_DIR; $icon=Join-Path $base '创.ico'; $shell=New-Object -ComObject WScript.Shell; Get-ChildItem -LiteralPath $base -Filter *.lnk -File -ErrorAction SilentlyContinue | ForEach-Object { try { $s=$shell.CreateShortcut($_.FullName); if($s.TargetPath -and ([IO.Path]::GetFileName($s.TargetPath) -ieq '启动服务.bat')) { $s.IconLocation=($icon+',0'); $s.Save() } } catch {} }"

set "PYEXE=%~dp0python\python.exe"
if not exist "%PYEXE%" set "PYEXE=python"

set "LAN_IP=127.0.0.1"
for /f "usebackq delims=" %%I in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$ip=(Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -and $_.IPv4Address } | Select-Object -First 1 -ExpandProperty IPv4Address).IPAddress; if(-not $ip){$ip=(Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } | Sort-Object InterfaceMetric | Select-Object -First 1 -ExpandProperty IPAddress)}; if($ip){$ip}else{'127.0.0.1'}"`) do set "LAN_IP=%%I"
if not defined PORT set "PORT=3000"
set "APP_URL=http://127.0.0.1:%PORT%/"
set "LAN_URL=http://%LAN_IP%:%PORT%/"

echo Starting ComfyUI-API-Modelscope...
echo Local: %APP_URL%
echo LAN:   %LAN_URL%
echo Press Ctrl+C to stop.
echo.

start "" /b powershell -NoProfile -Command "$deadline=(Get-Date).AddSeconds(30); while((Get-Date) -lt $deadline) { try { Invoke-WebRequest -UseBasicParsing -Uri $env:APP_URL -TimeoutSec 2 -ErrorAction Stop | Out-Null; Start-Process $env:APP_URL; exit } catch { Start-Sleep -Milliseconds 500 } }"
"%PYEXE%" main.py

echo.
echo Server stopped.
pause
