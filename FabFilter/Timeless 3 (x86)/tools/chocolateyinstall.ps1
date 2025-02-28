$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/fftimeless308.exe'
    softwareName   = 'FabFilter Timeless 3 (x86)*'
    checksumType   = 'sha256'
    checksum       = '677b4b8e488d044df328ec2b4e0b2cb03eea606fcb082d263f194686165bacfe'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
