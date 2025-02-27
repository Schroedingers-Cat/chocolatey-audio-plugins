$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffproc220.exe'
    softwareName   = 'FabFilter Pro-C 2 (x86)*'
    checksumType   = 'sha256'
    checksum       = 'bda68661bdb695e19466189a77c3674429e0231f5f0ebfe7314a43ec03dfcf88'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
