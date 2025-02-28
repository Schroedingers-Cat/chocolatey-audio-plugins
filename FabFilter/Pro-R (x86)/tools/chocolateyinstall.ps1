$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffpror118.exe'
    softwareName   = 'FabFilter Pro-R (x86)*'
    checksumType   = 'sha256'
    checksum       = '7c05aa6574b1ac19aaea8df2c074fa8b42b07882079b70e0ec3317c1e116e2a5'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
