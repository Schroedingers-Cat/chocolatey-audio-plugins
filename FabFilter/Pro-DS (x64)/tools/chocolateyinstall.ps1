$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffprods124x64.exe'
    softwareName   = 'FabFilter Pro-DS (x64)*'
    checksumType   = 'sha256'
    checksum       = 'c8edfaa6fe96ea62fc903805d9585337ceb16117d6ffc1d43dcb1ed2c4ae95b1'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
