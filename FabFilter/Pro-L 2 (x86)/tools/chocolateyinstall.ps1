$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffprol224.exe'
    softwareName   = 'FabFilter Pro-L 2 (x86)*'
    checksumType   = 'sha256'
    checksum       = '8d690de120f5d70458a2b0b18c6ade4d1d20770df2906ec5367632ade4c0e9d8'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
