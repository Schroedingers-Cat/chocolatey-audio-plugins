$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://madronalabs.com/media/aaltoverb/AaltoverbInstaller2.0.3.exe'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url64bit       = $url64

  softwareName   = 'Aaltoverb version*'

  checksumType64 = 'sha256'
  checksum64     = '4EA1B274A4C3039F6E3A1FBF31375BEB4FC2651F522790154963C8809C40CCEC'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
