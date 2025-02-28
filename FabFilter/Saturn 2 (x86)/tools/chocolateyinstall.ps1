$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffsaturn211.exe'
    softwareName   = 'FabFilter Saturn 2 (x86)*'
    checksumType   = 'sha256'
    checksum       = 'd8f3fea9ddfa5e16471b9ea7084e1cf2f6be54b291ef04097cb7c1118eeed333'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
