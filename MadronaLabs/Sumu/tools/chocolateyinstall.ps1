$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'http://madronalabs.com/media/sumu/SumuInstaller1.1.0.exe'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url64bit       = $url64

  softwareName   = 'Sumu version*'

  checksumType64 = 'sha256'
  checksum64     = '2cdc7e770d300305933622a2bfda223e398d8d16e161a426503cc3bfd266f1c7'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
