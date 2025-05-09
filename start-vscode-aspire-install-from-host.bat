@echo off
REM This batch file is used to execute the PowerShell script generate-and-start.ps1

powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0generate-and-start.ps1" --templateFile "%~dp0config\vscode-aspire-install-from-host.wsb"

rem echo "%~dp0generate-and-start.ps1"

