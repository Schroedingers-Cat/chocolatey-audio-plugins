$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/fftwin239.exe'
    softwareName   = 'FabFilter Twin 2 (x86)*'
    checksumType   = 'sha256'
    checksum       = 'a9a944ca8ba38c408fc7435b4644467e18e621af617ff5ecd2afb5a62c01434f'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
