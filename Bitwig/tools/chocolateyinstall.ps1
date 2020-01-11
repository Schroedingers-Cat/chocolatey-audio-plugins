$ErrorActionPreference = 'Stop';

$packageName= 'Bitwig'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64  = 'https://downloads.bitwig.com/stable/3.1.2/Bitwig%20Studio%203.1.2.msi'
$checksum64 = 'f29d1de15119cb96eca43bbcd6340d2ca2a40ac29f8ec5a7e6e7f0fbdb517c4b'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url64bit      = $url64
  softwareName  = 'Bitwig Studio' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  checksum64    = $checksum64
  checksumType64= 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
