$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffsaturn129x64.exe'
    softwareName   = 'FabFilter Saturn (x64)*'
    checksumType   = 'sha256'
    checksum       = 'aa555f75f79c835a71902b9a1342f4d11b6c318e03a67cef6676df613174c33a'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
