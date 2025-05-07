@echo off
REM This batch file is used to execute the PowerShell script generate-and-start.ps1

powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0generate-and-start.ps1"

rem echo "%~dp0generate-and-start.ps1"

