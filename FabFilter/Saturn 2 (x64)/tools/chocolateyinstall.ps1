$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffsaturn211x64.exe'
    softwareName   = 'FabFilter Saturn 2 (x64)*'
    checksumType   = 'sha256'
    checksum       = '7bbe9e635ecef9c3569dc04b134ddbd4642378be0bf4d9ad3c977e30469706a1'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
