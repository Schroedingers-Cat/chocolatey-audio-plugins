$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffone340x64.exe'
    softwareName   = 'FabFilter One (x64)*'
    checksumType   = 'sha256'
    checksum       = '41aed2a62e6b1535d53aa6de7c5a3d73a4a9e74333ea07d7e6fece264e406b73'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
