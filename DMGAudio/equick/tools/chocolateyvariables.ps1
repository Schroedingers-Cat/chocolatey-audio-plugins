﻿$packageName = 'EQuick'
$softwareName = "${packageName}*"
$company = 'DMGAudio'
$url32        = 'https://dmgaudio.com/dl/EQuick_v1.18/EQuickWin_v1.18.zip'
$releases = 'https://dmgaudio.com/products_equick.php'
$checksum32 = '65e71bf54ea616f054e0d3e231f6342f6c37438e7f2579a13b7078efb8968715'
$global:companyPath = "${env:PROGRAMFILES}\$company"
$global:vst2Path = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"
$vst3Path = "${env:COMMONPROGRAMFILES}\VST3\$company"
$vst3x86_64Path = "${env:COMMONPROGRAMFILES(x86)}\VST3\$company"
$userFolderPath = "" ## implement empty user folder check
$presetProducts = "" ## implement empty check
$unzipInstVersion = '1.18'
$unzInstPath = "${packageName}Win_v${unzipInstVersion}.exe"
$zipSuffix = "Win_v*.*.zip"
# This needs to be wrapped into a function so this object also has the data from the package parameters
function CreateRegistryObjects () {
  $global:regKeys =
  # The installer does not have an option for custom paths so we need to create the registry entry before
  @{'path'="HKCU:\SOFTWARE\DMGAudio\InstallPaths"; 'key'="VST_64";  'value'="$vst2Path";                 'bit'=64;    'validpp'="NoVst2x64"},
  @{'path'="HKCU:\SOFTWARE\DMGAudio\InstallPaths"; 'key'="VST_32";  'value'="$vst2x86_64Path";           'bit'=64;    'validpp'="NoVst2x86"},
  @{'path'="HKCU:\SOFTWARE\DMGAudio\InstallPaths"; 'key'="VST_32";  'value'="$vst2Path";                 'bit'=32;    'validpp'="NoVst2x86"},
  @{'path'="HKCU:\SOFTWARE\DMGAudio\InstallPaths"; 'key'="VST3_64"; 'value'="$vst3Path";                 'bit'=64;    'validpp'="NoVst3x64"},
  @{'path'="HKCU:\SOFTWARE\DMGAudio\InstallPaths"; 'key'="VST3_32"; 'value'="$vst3x86_64Path";           'bit'=64;    'validpp'="NoVst3x86"},
  @{'path'="HKCU:\SOFTWARE\DMGAudio\InstallPaths"; 'key'="VST3_32"; 'value'="$vst3Path";                 'bit'=32;    'validpp'="NoVst3x86"},
  @{'path'="HKCU:\SOFTWARE\DMGAudio\$packageName"; 'key'="Path";    'value'="$companyPath\$packageName"; 'bit'=64,32; 'validpp'="NoVst2x64", "NoVst2x86", "NoVst3x64", "NoVst3x86", "NoAaxx86", "NoAaxx64"}
}
function CreateRegistryFileObjects () { $global:regKeyFileObjects }
function CreateShortcutObjects () { $global:shortcuts }
function CreateSymlinkObjects () { $global:symlinks }
# DMG doesn't support silent switches for specific plugin versions
function CreateInstallerObjects () { }
function CreatePackageRessourcePathObjects () { $global:PackageRessourcePathList }
function CreateTxtFileObjects () { $global:PackageNewFiles }
function CreatePackageParametersObjects () {
  $global:packageArgs = @{
    packageName   = $packageName
    unzipLocation = $unzPath
    fileType      = 'exe'
    url           = $url32
    url64bit      = $url64
    softwareName  = "$company $packageName*" #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
    checksum      = $checksum32
    checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  }
  $global:packageParametersObjectsList = $packageArgs
}
