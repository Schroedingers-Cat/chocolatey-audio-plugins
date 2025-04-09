$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzipPath  = Join-Path -Path $toolsDir -ChildPath "ReasonInstaller"
New-Item -Path $unzipPath -ItemType Directory -Force

$url64 = 'https://cdn.reasonstudios.com/update/Stable/Reason_1321_d1-Stable-957-Win.zip'
$url64NoSB = 'https://cdn.reasonstudios.com/update/Stable/Reason_1321_d1-Stable-957-without_soundbanks-Win.zip'
$checksum64 = '0f29bbce87d81056c2d39bdc077ff4c9a8f9d8b10a57bf7941b6f65551621b38'
$checksum64NoSB = 'c13e13ee933fca975fd38e3c268441dd0306d21c459d2ac1f4c7c12c1bc5345e'

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
