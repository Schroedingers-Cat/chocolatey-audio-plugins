$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffsaturn129.exe'
    softwareName   = 'FabFilter Saturn (x86)*'
    checksumType   = 'sha256'
    checksum       = 'ba1c5a6f89e3ffe3ed28eda9004df22bbb1f4bdd80c013f38ab03230c2010840'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
