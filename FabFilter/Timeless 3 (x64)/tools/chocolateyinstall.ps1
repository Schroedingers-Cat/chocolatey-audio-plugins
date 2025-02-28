$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/fftimeless308x64.exe'
    softwareName   = 'FabFilter Timeless 3 (x64)*'
    checksumType   = 'sha256'
    checksum       = 'a05a425a81b00c3394396b212267fb3d05f34e355e9a08d886b8a8c2e031149f'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
