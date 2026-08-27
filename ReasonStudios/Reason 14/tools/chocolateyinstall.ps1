$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzipPath  = Join-Path -Path $toolsDir -ChildPath "ReasonInstaller"
New-Item -Path $unzipPath -ItemType Directory -Force

$url64 = 'https://cdn.reasonstudios.com/update/Stable/Reason_1410_d100-Stable-886-Win.zip'
$url64NoSB = 'https://cdn.reasonstudios.com/update/Stable/Reason_1410_d100-Stable-886-without_soundbanks-Win.zip'
$checksum64 = '974c1a31fe6db07f5f5856803350374922e3e5183bc260a35d7a9ec0f8c22d73'
$checksum64NoSB = '9b5a701bcd101963c057e3709bb59e9b9600da41cdf74e51a22cdef577de611a'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $unzipPath
  fileType       = 'exe'
  url64bit       = $url64
  file64         = "${unzipPath}\Install Reason 14.exe"
  softwareName   = 'Reason 14 14.*'
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

$componentsList = "standalone,companion,vst,aax"
if ($pp['WithoutSoundbanks']) {
    $packageArgs.url64bit =  $url64NoSB
    $packageArgs.checksum64 =  $checksum64NoSB
    # The installer without soundbanks has no companion component
    $componentsList = "standalone,vst,aax"
}

if ($pp['NoVst']) { $componentsList = $componentsList -replace ",vst","" }
if ($pp['NoAax']) { $componentsList = $componentsList -replace ",aax","" }
$packageArgs.silentArgs += " /Components=${componentsList}"

# Run Install
Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs

# Cleanup
Remove-Item $unzipPath -Recurse -Force -ErrorAction SilentlyContinue
