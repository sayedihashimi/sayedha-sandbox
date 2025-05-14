$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$gitpath = "C:\Program Files\Git\bin\git.exe"
function Install-Apps{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $settings
    )
    process{
        if (-not $settings) {
            Write-Error "The 'settings' parameter is null or empty. Please provide valid settings."
            return
        }
        if ($settings.AppsToInstall) {
            foreach ($app in $settings.AppsToInstall) {
                if($($app.Enabled)){
                    "Installing app: {0}" -f $app.Name | Write-Output
                    $installCommand = $app.InstallCommand

                    $appname = $app.Name
                    $filepath = $installCommand.Split(' ', 2)[0]
                    $arglist = $installCommand.Split(' ', 2)[1]

                    'Installing "{0}" with command: "{1} {2}"' -f $appname, $filepath, $arglist | Write-Output
                    if($app.WaitForCompletion -eq $true){
                        Start-Process -FilePath $filepath -ArgumentList $arglist -Wait
                    }
                    else{
                        Start-Process -FilePath $filepath -ArgumentList $arglist
                    }
                    
                }
                else {
                    "Skipping app: {0}" -f $app.Name | Write-Output
                }                
            }
        } else {
            Write-Output "No apps to install."
        }

        "`nInstallation complete" | Write-Output
    }
}

function Update-WindowsSettings{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        $settings
    )
    process{
        if (-not $settings) {
            Write-Error "The 'settings' parameter is null or empty. Please provide valid settings."
            return
        }
        $showHiddenFiles = $settings.WindowsSettings.EnableShowHiddenFiles
        $showFileExtensions = $settings.WindowsSettings.EnableShowFileExtensions

        if($showHiddenFiles -eq $true){
            'Enabling show hidden files' | Write-Output
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
        }
        if($showFileExtensions -eq $true){
            'Enabling show file extensions' | Write-Output
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0
        }
    }
}

function Install-VSCodeExtensions{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        $settings
    )
    process{
        if (-not $settings) {
            Write-Error "The 'settings' parameter is null or empty. Please provide valid settings."
            return
        }
        $vscExtensions = $settings.VSCodeExtensionsToInstall
        if($vscExtensions){
            foreach($extension in $vscExtensions){
                'Installing VSCode extensions' | Write-Output
                # cmd.exe /c start cmd.exe /k "C:\Program Files\Microsoft VS Code\bin\code" --install-extension ms-dotnettools.csharp --force
                $argList = '/k "C:\Program Files\Microsoft VS Code\bin\code" --install-extension {0} --force' -f $extension
                Start-Process -FilePath "cmd.exe" -ArgumentList $argList -NoNewWindow -Wait
            }
        }
    }
}
function Clone-Repos{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        $settings)
    process{
        if (-not $settings) {
            Write-Error "The 'settings' parameter is null or empty. Please provide valid settings."
            return
        }
        $codeHome = $settings.CodeHome
        if(-not $codeHome){
            $codeHome = "c:\\data\\mycode"
        }
        New-Item -Path $codeHome -ItemType Directory | Out-Null
        Push-Location -Path $codeHome
        $repos = $settings.ReposToClone
        foreach($repo in $repos){
            # "C:\Program Files\Git\bin\git.exe" clone https://github.com/sayedihashimi/RestaurantService.git
            Start-Process -FilePath $gitpath
                            -ArgumentList "clone {0}" -f $repo -NoNewWindow -Wait
        }
        Pop-Location
    }
}
function Get-InstallSettings {
    param (
        [string]$SettingsFilePath = (Join-Path $scriptDir 'settings.json')
    )
    'Loading settings from: "{0}"' -f $SettingsFilePath | Write-Output
    if (Test-Path $SettingsFilePath) {
        $jsonContent = Get-Content -Path $SettingsFilePath -Raw | ConvertFrom-Json
        return $jsonContent
    } else {
        Write-Error "Settings file not found at path: $SettingsFilePath"
        return $null
    }
}

Set-Location -LiteralPath $scriptDir

$settings = Get-InstallSettings

Install-Apps -settings $settings

Update-WindowsSettings -settings $settings

Install-VSCodeExtensions -settings $settings

Clone-Repos -settings $settings
