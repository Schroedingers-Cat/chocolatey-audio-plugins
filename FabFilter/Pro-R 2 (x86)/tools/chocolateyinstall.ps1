$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffpror204.exe'
    softwareName   = 'FabFilter Pro-R 2 (x86)*'
    checksumType   = 'sha256'
    checksum       = '66eebfcd22e11c1cbc95fc6b02c20693eb5aad5a2fe2c98648e19efcb9741953'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
