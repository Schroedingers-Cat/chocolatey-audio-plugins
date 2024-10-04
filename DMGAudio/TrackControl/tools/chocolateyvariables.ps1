$packageName = "TrackControl"
$company = "DMGAudio"
$version = '1.13'
$softwareName  = "$company $packageName $version"
$releases = "https://dmgaudio.com/products_trackcontrol.php"
$url32 = 'https://dmgaudio.com/dl/TrackControl_v1.13/TrackControlWin_v1.13.zip'
$checksum32 = 'bca1e1c610185a8b5167c685c20a7891d6b91cb6edbbd26839a81023106b701c'
$global:companyPath = "${env:PROGRAMFILES}\$company"
$global:vst2Path = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"
$vst3Path = "${env:COMMONPROGRAMFILES}\VST3\$company"
$vst3x86_64Path = "${env:COMMONPROGRAMFILES(x86)}\VST3\$company"
$userFolderPath = "" ## implement empty user folder check
$presetProducts = "" ## implement empty check
$unzInstPath = "${packageName}Win_v${version}.exe"
$zipSuffix = "Win_v*.*.zip"
$global:installerType = 'exe'
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
# DMG doesn't support silent switches for specific plugin versions
function CreatePackageParametersObjects () {
  $global:packageArgs = @{
    packageName   = $packageName
    unzipLocation = $unzPath
    fileType      = $installerType
    url           = $url32
    softwareName  = $softwareName
    checksum      = $checksum32
    checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  }
  $global:packageParametersObjectsList = $packageArgs
}
