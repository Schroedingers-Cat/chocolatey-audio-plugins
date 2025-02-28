$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/fftwin239x64.exe'
    softwareName   = 'FabFilter Twin 2 (x64)*'
    checksumType   = 'sha256'
    checksum       = 'befce24cfeb336d8d35f1e73da66543d0e5b5d708da2133245e51b7ccd8a0ace'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
