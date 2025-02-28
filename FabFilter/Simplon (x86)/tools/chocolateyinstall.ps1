$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffsimplon139.exe'
    softwareName   = 'FabFilter Simplon (x86)*'
    checksumType   = 'sha256'
    checksum       = 'ca5ca6c5a211f63d0828f74c4ee2a95699be172946baed71edf2e97918aacc8f'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
