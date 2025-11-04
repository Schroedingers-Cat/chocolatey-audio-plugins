$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzipPath  = Join-Path -Path $toolsDir -ChildPath "ReasonInstaller"
New-Item -Path $unzipPath -ItemType Directory -Force

$url64 = 'https://cdn.reasonstudios.com/update/Stable/Reason_1333_d36-Stable-561-Win.zip'
$url64NoSB = 'https://cdn.reasonstudios.com/update/Stable/Reason_1333_d36-Stable-561-without_soundbanks-Win.zip'
$checksum64 = 'a5813f66ba5e1625cc49bf01fd121c7a5ea2281d0a4b2f6d3ef6aa8eeab7de9e'
$checksum64NoSB = 'b224ff80f9c3fce60755faa5d27abbc89da81f392698616fe1ab10441502a90b'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $unzipPath
  fileType       = 'exe'
  url64bit       = $url64
  file64         = "${unzipPath}\Install Reason 13.exe"
  softwareName   = 'Reason 13 13.*'
  checksumType64 = 'sha256'
  checksum64     = $checksum64
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes = @(0)
}

# Package Parameters
$pp = Get-PackageParameters

if ($pp['InstallationPath']) { 
  $installPath = $pp['InstallationPath']
  $packageArgs.silentArgs += " /Dir=`"${installPath}`"" 
}
if ($pp['NoDesktopIcon']) { $packageArgs.silentArgs += " /TASKS=" }
if ($pp['WithoutSoundbanks']) { 
  $packageArgs.url64bit =  $url64NoSB
  $packageArgs.checksum64 =  $checksum64NoSB
}

$componentsList = "standalone,vst,aax"
if ($pp['NoVst']) { $componentsList = $componentsList -replace ",vst","" }
if ($pp['NoAax']) { $componentsList = $componentsList -replace ",aax","" }
$packageArgs.silentArgs += " /Components=${componentsList}"

# Run Install
Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs

# Cleanup
Remove-Item $unzipPath -Recurse -Force -ErrorAction SilentlyContinue
