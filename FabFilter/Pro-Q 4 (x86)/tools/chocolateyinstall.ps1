$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffproq402.exe'
    softwareName   = 'FabFilter Pro-Q 4 (x86)*'
    checksumType   = 'sha256'
    checksum       = '46e0d1412fbfeb1e33fe18d17cbc7654f1830d0d47cf3ef2377494b957305210'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
