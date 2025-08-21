$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'http://madronalabs.com/media/sumu/SumuInstaller1.1.1.exe'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url64bit       = $url64

  softwareName   = 'Sumu version*'

  checksumType64 = 'sha256'
  checksum64     = '5ea47c50ff11dec537baebb4a487965f72da11b3ff99bd9c27c0b53b3f422bdb'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
