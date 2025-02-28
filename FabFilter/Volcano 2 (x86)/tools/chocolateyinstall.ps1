$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffvolcano239.exe'
    softwareName   = 'FabFilter Volcano 2 (x86)*'
    checksumType   = 'sha256'
    checksum       = '9bc036ffba4154572ea85e73af97b7ca15b9e08c20c3699561d3d51f2e57b9c0'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
