$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
function Install-Apps{
    [CmdletBinding()]
    param(
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
                    "Executing install command: {0}" -f $installCommand | Write-Output

                    $filepath = $installCommand.Split(' ', 2)[0]
                    $arglist = $installCommand.Split(' ', 2)[1]

                    'Installing with command: "{0}" {1}' -f $filepath, $arglist | Write-Output
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

# update windows settings

# install vs code extensions

# clone repos

