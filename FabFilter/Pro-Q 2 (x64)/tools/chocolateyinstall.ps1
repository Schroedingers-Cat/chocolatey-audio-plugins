$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffproq228x64.exe'
    softwareName   = 'FabFilter Pro-Q 2 (x64)*'
    checksumType   = 'sha256'
    checksum       = 'bedc5b7ec78385069ad6a62417c42b4e5324748e7155d23300fba0d4c0ea47a9'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
