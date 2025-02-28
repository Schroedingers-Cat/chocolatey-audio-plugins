$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/fftimeless239x64.exe'
    softwareName   = 'FabFilter Timeless 2 (x64)*'
    checksumType   = 'sha256'
    checksum       = '4551a4cd36463071e47a2760d195d72f71d8a99e4747e6cff18adfaa693dd84f'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
