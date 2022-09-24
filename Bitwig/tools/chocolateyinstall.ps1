$ErrorActionPreference = 'Stop';

$packageName= 'Bitwig'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64  = 'https://www.bitwig.com/dl/?id=500&os=installer_windows'
$checksum64 = 'e0133df98100180b176c207bd53f0377b060cdfeeb94c7af5931cee540a04e44'

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
