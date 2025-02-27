$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffmicro129x64.exe'
    softwareName   = 'FabFilter Micro (x64)*'
    checksumType   = 'sha256'
    checksum       = '114dd3968d974585066ce66b841117e370ea4c39bf5713b7c0c87205a3415316'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
