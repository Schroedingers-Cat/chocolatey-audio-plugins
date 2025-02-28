$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffprol224x64.exe'
    softwareName   = 'FabFilter Pro-L 2 (x64)*'
    checksumType   = 'sha256'
    checksum       = 'e98cf757b97dfaeb8cf32975c0c48b27a7d27f17cebb9e4120648923e6160b17'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
