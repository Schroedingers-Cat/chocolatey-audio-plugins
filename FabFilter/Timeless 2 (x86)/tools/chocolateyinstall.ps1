$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/fftimeless239.exe'
    softwareName   = 'FabFilter Timeless 2 (x86)*'
    checksumType   = 'sha256'
    checksum       = '330d0a0612ffe21fc56e70db3c2ce88daf72ffe1dc2fcb3e890fd73e63ab44c6'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
