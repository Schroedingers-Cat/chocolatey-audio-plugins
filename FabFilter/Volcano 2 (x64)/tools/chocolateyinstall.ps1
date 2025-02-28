$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffvolcano239x64.exe'
    softwareName   = 'FabFilter Volcano 2 (x64)*'
    checksumType   = 'sha256'
    checksum       = '15a92f813f34d3346c4f5a2a9b2b3a94bfa55add7c910c9659099ccc119d0b83'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
