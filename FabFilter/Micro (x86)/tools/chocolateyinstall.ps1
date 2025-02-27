$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffmicro129.exe'
    softwareName   = 'FabFilter Micro (x86)*'
    checksumType   = 'sha256'
    checksum       = '3f4feb6b60ee4639c9e07b12bd2d6027e5e74f6c6f696b707516f2b5e8987f28'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
