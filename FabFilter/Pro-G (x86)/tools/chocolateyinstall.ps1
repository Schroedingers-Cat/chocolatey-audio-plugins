$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffprog134.exe'
    softwareName   = 'FabFilter Pro-G (x86)*'
    checksumType   = 'sha256'
    checksum       = '6817783877146ea2982cc282ebe51cf9e2e6ca665a8f98fae1cd20340590078f'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
