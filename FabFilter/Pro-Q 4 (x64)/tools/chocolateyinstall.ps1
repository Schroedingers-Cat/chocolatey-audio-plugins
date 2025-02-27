$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffproq402x64.exe'
    softwareName   = 'FabFilter Pro-Q 4 (x64)*'
    checksumType   = 'sha256'
    checksum       = '69a31fcc9236a4c84ecff1f89d529259f0c5ed9dab83e50bcad3c035a0b9bbca'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
