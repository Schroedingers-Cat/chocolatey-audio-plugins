$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffproc220x64.exe'
    softwareName   = 'FabFilter Pro-C 2 (x64)*'
    checksumType   = 'sha256'
    checksum       = 'd2cf3920a728e5f5917b378663248ca99b4a32d7dd425e0242dacb191c9ae305'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
