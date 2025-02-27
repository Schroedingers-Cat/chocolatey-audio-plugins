﻿$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://cdn-b.fabfilter.com/downloads/fftimeless300.exe'
    softwareName   = 'FabFilter Timeless 3 (x86)*'
    checksumType   = 'sha256'
    checksum       = '24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
