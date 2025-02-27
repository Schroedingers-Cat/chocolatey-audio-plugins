$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffpror204x64.exe'
    softwareName   = 'FabFilter Pro-R 2 (x64)*'
    checksumType   = 'sha256'
    checksum       = 'a20f969237165531b5ee939deb92b23c0fb8bbc8f4a8f6946a1b46e142d3d03b'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
