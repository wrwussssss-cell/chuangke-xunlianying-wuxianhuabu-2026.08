@echo off
chcp 65001 >nul
set "APP_DIR=%~dp0"
set "SHORTCUT=%USERPROFILE%\Desktop\创·无限画布.lnk"
set "TARGET=%APP_DIR%启动服务.bat"
set "ICON=%APP_DIR%创.ico"

if not exist "%ICON%" (
  echo 找不到图标文件：%ICON%
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut($env:SHORTCUT); $s.TargetPath=$env:TARGET; $s.WorkingDirectory=$env:APP_DIR; $s.IconLocation=$env:ICON+',0'; $s.Description='启动无限画布服务'; $s.Save()"
echo 已创建桌面快捷方式：%SHORTCUT%
pause
