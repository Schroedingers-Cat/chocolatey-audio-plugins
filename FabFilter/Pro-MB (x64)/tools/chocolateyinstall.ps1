$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffpromb131x64.exe'
    softwareName   = 'FabFilter Pro-MB (x64)*'
    checksumType   = 'sha256'
    checksum       = '2526ce08cbfd49f16060a0770da99c588d0a4561289a09ba1d6272c4bf516831'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
