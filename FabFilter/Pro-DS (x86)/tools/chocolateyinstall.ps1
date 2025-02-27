$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffprods124.exe'
    softwareName   = 'FabFilter Pro-DS (x86)*'
    checksumType   = 'sha256'
    checksum       = '980dac42ee80c4fa1b1bfcc5487bbfc72d161c3f73c31197e8a34f3e1dbf28a4'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
