# apply the workaround to avoid long install times
powershell -ExecutionPolicy Bypass -File C:\setup\PatchSandbox.ps1

# install winget, from: https://learn.microsoft.com/en-us/windows/package-manager/winget/
$progressPreference = 'silentlyContinue'
Write-Host "Installing WinGet PowerShell module from PSGallery..."
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
Repair-WinGetPackageManager
Write-Host "Done."

# make the temp folder if it doesn't exist
$tempFolder = "c:\temp"
New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null

# download .net winget file
$dotnetWingetFile = join-path $tempFolder dotnet.winget
Invoke-WebRequest -Uri "https://builds.dotnet.microsoft.com/dotnet/install/dotnet_basic_config_website.winget" -OutFile $dotnetWingetFile

winget configure -f $dotnetWingetFile