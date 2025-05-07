[cmdletbinding()]
param(
    [Parameter(Position=0)]
    [string]$templateFile,
    [Parameter(Position=1)]
    [string]$mappedFolder
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# set default values for the parameters
if(-not($templateFile)){
    $templateFile = (Resolve-Path (Join-Path -Path $scriptDir -ChildPath 'config\vscode-aspire.wsb')).Path
}
if(-not($mappedFolder)){
    $mappedFolder = (Resolve-Path (Join-Path -Path $scriptDir -ChildPath 'mapped-folder')).Path
}

function CreateGeneratedFolder(){
    if(-not(Test-Path -Path (Join-Path $scriptDir 'generated'))){
        New-Item -ItemType Directory -Path (Join-Path $scriptDir 'generated') | Out-Null
    }
}

function CopyAndUpdateWsb {
    param(
        [string]$templateFile,
        [string]$mappedFolder
    )
    CreateGeneratedFolder
    $generatedFolder = (Resolve-Path (Join-Path $scriptDir 'generated')).Path

    if (Test-Path $generatedFolder) {
        Get-ChildItem -Path $generatedFolder -Recurse -Force | Remove-Item -Recurse -Force
    } else {
        New-Item -ItemType Directory -Path $generatedFolder | Out-Null
    }
    $destFile = Join-Path $generatedFolder (Split-Path $templateFile -Leaf)
    Copy-Item $templateFile $destFile
    [xml]$xml = Get-Content $destFile
    $hostFolderNode = $xml.SelectSingleNode('//Configuration/MappedFolders/MappedFolder/HostFolder')
    if ($hostFolderNode) {
        $hostFolderNode.InnerText = $mappedFolder
        $xml.Save($destFile)
    } else {
        throw 'HostFolder element not found in the XML.'
    }
    return $destFile
}

# get the full path to the mapped-folder

$wsbToLaunch = CopyAndUpdateWsb -templateFile $templateFile -mappedFolder $mappedFolder

start "$wsbToLaunch"