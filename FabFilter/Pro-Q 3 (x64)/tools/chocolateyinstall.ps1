$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffproq327x64.exe'
    softwareName   = 'FabFilter Pro-Q 3 (x64)*'
    checksumType   = 'sha256'
    checksum       = 'c4c0f816aa39d8e29b60dfed7d629a69a24ad1b07133c868233fbe031b35f6ba'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
