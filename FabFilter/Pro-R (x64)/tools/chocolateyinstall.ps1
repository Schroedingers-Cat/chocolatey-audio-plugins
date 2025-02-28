$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffpror118x64.exe'
    softwareName   = 'FabFilter Pro-R (x64)*'
    checksumType   = 'sha256'
    checksum       = '9899852b6e2340bac575385813ba2c66cc860f1968d5d054d0d9ea312691344e'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
