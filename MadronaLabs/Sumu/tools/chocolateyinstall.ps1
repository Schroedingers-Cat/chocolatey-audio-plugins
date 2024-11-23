$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://madronalabs-earlyaccess.s3.amazonaws.com/SumuInstaller1.0.0.exe'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url64bit       = $url64

  softwareName   = 'Sumu version*'

  checksumType64 = 'sha256'
  checksum64     = '1e6a936179a88e67ec33c5c25ea57ba4e029fcb9b7a2f9e6fcd4871de9a07c00'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
