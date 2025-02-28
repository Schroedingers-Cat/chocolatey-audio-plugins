$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffproq228.exe'
    softwareName   = 'FabFilter Pro-Q 2 (x86)*'
    checksumType   = 'sha256'
    checksum       = 'fa18f6399321e41e43f8072f2c26c7dadb444572699fac14c1d6bd3084b6ee7b'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
