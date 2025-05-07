$dest = get-fullpath (join-path ".." "mapped-folder")

New-Item -ItemType Directory -Path $dest -Force | Out-Null

# Git
Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe" -OutFile "$dest\git.exe"

# VS Code
Invoke-WebRequest -Uri "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64" -OutFile "$dest\vscode.exe"

# .NET SDK 9.0.203
Invoke-WebRequest -Uri "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.203/dotnet-sdk-9.0.203-win-x64.exe" -OutFile "$dest\dotnet9.exe"

# PowerShell 7
Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.5.1/PowerShell-7.5.1-win-x64.msi" -OutFile "$dest\pwsh.msi"

# Windows Terminal
# Invoke-WebRequest -Uri "https://github.com/microsoft/terminal/releases/latest/download/Microsoft.WindowsTerminal_1.19.11061.0_8wekyb3d8bbwe.msixbundle" -OutFile "$dest\terminal.msixbundle"

# conemu
Invoke-WebRequest -Uri "https://github.com/Maximus5/ConEmu/releases/download/v23.07.24/ConEmuSetup.230724.exe" -OutFile "$dest\conemusetup.exe"

# App Installer (winget)
Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile "$dest\AppInstaller.msixbundle"
