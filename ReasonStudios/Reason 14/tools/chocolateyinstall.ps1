$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzipPath  = Join-Path -Path $toolsDir -ChildPath "ReasonInstaller"
New-Item -Path $unzipPath -ItemType Directory -Force

$url64 = 'https://cdn.reasonstudios.com/update/Stable/Reason_1401_d47-Stable-842-Win.zip'
$url64NoSB = 'https://cdn.reasonstudios.com/update/Stable/Reason_1401_d47-Stable-842-without_soundbanks-Win.zip'
$checksum64 = 'a2c866d6aa970aa2b70a7df9552b053a48adcb17042f503c93075f0671d6c972'
$checksum64NoSB = 'eedf7f5c3c9f98ffdb758747755a40cf2762b45bce50220ea3e9f7bf83ce0eea'

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
