$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://madronalabs.com/media/aalto/AaltoInstaller1.9.4.exe'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url64bit       = $url64

  softwareName   = 'Aalto version*'

  checksumType64 = 'sha256'
  checksum64     = '4679B6EDD6F6D0F4772C53ED16E5057D9A63644F071D73B4FEF061BC083F8AC8'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
