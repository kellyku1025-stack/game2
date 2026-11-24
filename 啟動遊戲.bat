@echo off
set "GODOT=C:\Godot\Godot_v4.7.2-stable_win64.exe"
if not exist "%GODOT%" (
  echo 找不到 Godot：%GODOT%
  echo 請安裝 Godot 4.3 或更新版本，或修改本檔中的 GODOT 路徑。
  pause
  exit /b 1
)
start "小小夢魔：星港理財迷航" "%GODOT%" --path "%~dp0"
