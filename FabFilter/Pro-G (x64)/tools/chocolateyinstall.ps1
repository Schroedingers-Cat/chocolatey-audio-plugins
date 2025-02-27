$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffprog134x64.exe'
    softwareName   = 'FabFilter Pro-G (x64)*'
    checksumType   = 'sha256'
    checksum       = '2d1aca830ff9e7dae3707f28fbd630541d17eb177e27a9dfacb6bfa8f088247f'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
