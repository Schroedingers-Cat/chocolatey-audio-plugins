$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffvolcano307x64.exe'
    softwareName   = 'FabFilter Volcano 3 (x64)*'
    checksumType   = 'sha256'
    checksum       = '2564b65a0549fc2bb0d331cc9d0359f2082bbb3e591a8202817855bcd3575abb'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
