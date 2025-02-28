$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffvolcano307.exe'
    softwareName   = 'FabFilter Volcano 3 (x86)*'
    checksumType   = 'sha256'
    checksum       = '502e8e039a1cccd9dffc5f4a9589a13386c324730cdac44d324ecd04464e9ca6'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
