$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffprol135.exe'
    softwareName   = 'FabFilter Pro-L (x86)*'
    checksumType   = 'sha256'
    checksum       = '02ad9487d44e7baf6cfaa82b05766dd27e89be3a711d52159846ccde4ee5aa12'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
