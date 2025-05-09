@echo off
setlocal

cd /d "%~dp0"

rem patch the sandbox to prevent long install times more info at 
cmd.exe /c start powershell -ExecutionPolicy Bypass -File C:\setup\PatchSandbox.ps1

rem echo Installing App Installer (winget)...
rem powershell -Command "Add-AppxPackage -Path .\AppInstaller.msixbundle"

echo Installing Git...
start /wait git.exe /VERYSILENT /NORESTART

echo Installing .NET SDK 9.0.203...
start /wait dotnet9.exe /install /quiet /norestart

echo Installing Visual Studio Code...
start /wait vscode.exe /VERYSILENT /NORESTART /MERGETASKS=!runcode

echo Installing PowerShell 7...
start /wait msiexec /i pwsh.msi /qn

rem echo Installing Windows Terminal...
rem powershell -Command "Add-AppxPackage -Path .\terminal.msixbundle"

echo Installing ConEmu...
start /wait ConEmuSetup.exe /p:x64,adm /qr /norestart

mkdir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\"
echo Setting PowerShell 7 as default...
set PS7_PATH=%ProgramFiles%\PowerShell\7\pwsh.exe
if exist "%PS7_PATH%" (
    del "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
    powershell -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%ProgramData%\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk');$s.TargetPath='%PS7_PATH%';$s.Save()"
)

echo Enabling 'Show hidden files' and 'Show file extensions'...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f


echo Clone repos
mkdir c:\data\mycode
cd c:\data\mycode
"C:\Program Files\Git\bin\git.exe" clone https://github.com/sayedihashimi/RestaurantService.git

rem add VS code extensions
cmd.exe /c start cmd.exe /k "C:\Program Files\Microsoft VS Code\bin\code" --install-extension ms-dotnettools.csharp --force
echo "installed --install-extension ms-dotnettools.csharp"
timeout /t 10 /nobreak >nul

cmd.exe /c start cmd.exe /k "C:\Program Files\Microsoft VS Code\bin\code" --install-extension GitHub.copilot --force
echo "installed --install-extension GitHub.copilot"
timeout /t 10 /nobreak >nul

cmd.exe /c start cmd.exe /k "C:\Program Files\Microsoft VS Code\bin\code" --install-extension ms-dotnettools.csdevkit --force
echo "installed --install-extension ms-dotnettools.csdevkit"
timeout /t 10 /nobreak >nul

echo Done!
pause
