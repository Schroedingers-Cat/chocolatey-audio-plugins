$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffsimplon139x64.exe'
    softwareName   = 'FabFilter Simplon (x64)*'
    checksumType   = 'sha256'
    checksum       = '16aec16370a824f44f412d06ce94bcf5642971cfdea4baed0012a7e6588196ff'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
