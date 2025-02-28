$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffproq327.exe'
    softwareName   = 'FabFilter Pro-Q 3 (x86)*'
    checksumType   = 'sha256'
    checksum       = 'f86891d97c0fe03622161033d1c43c3c74f84be753ece7bac47a916172641493'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
