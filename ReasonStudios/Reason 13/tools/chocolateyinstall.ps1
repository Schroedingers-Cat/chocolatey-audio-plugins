$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzipPath  = Join-Path -Path $toolsDir -ChildPath "ReasonInstaller"
New-Item -Path $unzipPath -ItemType Directory -Force

$url64 = 'https://cdn.reasonstudios.com/update/Stable/Reason_1351_d12-Stable-757-Win.zip'
$url64NoSB = 'https://cdn.reasonstudios.com/update/Stable/Reason_1351_d12-Stable-757-without_soundbanks-Win.zip'
$checksum64 = 'ff679ac02b7bb55ce35d2747858358ab73f39040a03b1decd9cf1fd2e20731db'
$checksum64NoSB = '1a6159f20886bad70758d528f5bd976c8225e4155c8ee57a110007586cb04982'

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

$componentsList = "standalone,companion,vst,aax"
if ($pp['NoVst']) { $componentsList = $componentsList -replace ",vst","" }
if ($pp['NoAax']) { $componentsList = $componentsList -replace ",aax","" }
$packageArgs.silentArgs += " /Components=${componentsList}"

# Run Install
Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs

# Cleanup
Remove-Item $unzipPath -Recurse -Force -ErrorAction SilentlyContinue
