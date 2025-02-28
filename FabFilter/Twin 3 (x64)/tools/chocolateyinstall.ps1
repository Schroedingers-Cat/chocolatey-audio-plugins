$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/fftwin305x64.exe'
    softwareName   = 'FabFilter Twin 3 (x64)*'
    checksumType   = 'sha256'
    checksum       = 'd8351dbf04aa1ffa92b8cd721f84039c7bc22c9306e6f4ac6304ee4d4897b8f9'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
