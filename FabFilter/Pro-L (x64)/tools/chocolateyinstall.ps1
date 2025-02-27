$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffprol135x64.exe'
    softwareName   = 'FabFilter Pro-L (x64)*'
    checksumType   = 'sha256'
    checksum       = '77e6d642b55e416d95014f4682b392c47ad601e97191473cc9291ddae21fc687'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
