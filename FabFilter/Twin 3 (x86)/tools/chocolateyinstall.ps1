$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/fftwin305.exe'
    softwareName   = 'FabFilter Twin 3 (x86)*'
    checksumType   = 'sha256'
    checksum       = '81b5b749008d931cf63bcefd8517c36a451798c5276096d50909b1413af9649d'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
