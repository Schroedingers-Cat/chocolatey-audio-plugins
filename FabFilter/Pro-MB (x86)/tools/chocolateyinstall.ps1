$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffpromb131.exe'
    softwareName   = 'FabFilter Pro-MB (x86)*'
    checksumType   = 'sha256'
    checksum       = '602249a8a76457e49c74c9d29a674bca5c8c875ea45826356c457ed55ca19362'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
