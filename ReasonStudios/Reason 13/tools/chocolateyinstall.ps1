$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzipPath  = Join-Path -Path $toolsDir -ChildPath "ReasonInstaller"
New-Item -Path $unzipPath -ItemType Directory -Force

$url64 = 'https://cdn.reasonstudios.com/update/Stable/Reason_1310_d330-Stable-929-Win.zip'
$url64NoSB = 'https://cdn.reasonstudios.com/update/Stable/Reason_1310_d330-Stable-929-without_soundbanks-Win.zip'
$checksum64 = '3d5ba2a342c14f47ff36a5c45afdf066be426e42e3126b8c27ef64a77118746c'
$checksum64NoSB = 'fc21d7e2e22c0027f9b38c54fbc5fd91f5be58c931ad14497988a30a42f6ba2b'

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
Remove-Item $unzipPath -Recurse -Force
