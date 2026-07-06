$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzipPath  = Join-Path -Path $toolsDir -ChildPath "ReasonInstaller"
New-Item -Path $unzipPath -ItemType Directory -Force

$url64 = 'https://cdn.reasonstudios.com/update/Stable/Reason_1402_d25-Stable-854-Win.zip'
$url64NoSB = 'https://cdn.reasonstudios.com/update/Stable/Reason_1402_d25-Stable-854-without_soundbanks-Win.zip'
$checksum64 = '11f47f4841fb7962b48cb7a2f717b8f4621632e1df3f448030b6185e8c0d4267'
$checksum64NoSB = '0a75d4147861a6f5a7003bd5325a31acb112107ca6d68988ef2e9157f863cd7e'

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
