$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzipPath  = Join-Path -Path $toolsDir -ChildPath "ReasonInstaller"
New-Item -Path $unzipPath -ItemType Directory -Force

$url64 = 'https://cdn.reasonstudios.com/update/Stable/Reason_1331_d44-Stable-467-Win.zip'
$url64NoSB = 'https://cdn.reasonstudios.com/update/Stable/Reason_1331_d44-Stable-467-without_soundbanks-Win.zip'
$checksum64 = '44cfab08d51f06e1269ea2313e8fc4a48edf2aace664b13dbed20d6952f5a6aa'
$checksum64NoSB = '5f7dac7555fc87b859a2af74c87b1188644277ff0a0e9b69660fb08d5f50a1fa'

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
