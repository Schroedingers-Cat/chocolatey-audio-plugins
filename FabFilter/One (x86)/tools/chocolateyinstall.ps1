$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffone340.exe'
    softwareName   = 'FabFilter One (x86)*'
    checksumType   = 'sha256'
    checksum       = '2e224ad4fbb890cba1299b653f86c71d0238a414f8e86fac11e2b9868b5141b6'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
