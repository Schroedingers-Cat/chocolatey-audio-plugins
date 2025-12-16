$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://madronalabs.com/media/sumu/SumuInstaller1.2.0.exe'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url64bit       = $url64

  softwareName   = 'Sumu version*'

  checksumType64 = 'sha256'
  checksum64     = 'fa043328fac3288f6ea0f3a7fe2c5dff716814a53ff12037d9ff3944a269e66d'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
