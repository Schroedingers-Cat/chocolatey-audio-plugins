$packageName    = 'Spatifier'
$company        = 'Voxengo'
$softwareName   = "$company $packageName"
$url32          = 'https://www.voxengo.com/files/VoxengoSpatifier_19_Win32_64_VST_VST3_AAX_setup.exe'
$releases       = 'https://www.voxengo.com/product/spatifier/'
$checksum32     = '7485d6ecb7c6364d211cfffedfd1e53479a62a74977c49308c059d217e8082e7'
$global:companyPath    = "${env:PROGRAMFILES}\$company"
$global:vst2Path       = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"

function CreateRegistryObjects () {
  # The installer does not have an option for custom paths so we need to create the registry entry before
  $global:regKeys =
  @{'path'="HKLM:\Software\Voxengo\AudioPluginsInstall"; 'key'="DirVST2_64";  'value'="$vst2Path";        'bit'=64;    'validpp'="NoVst2x64"},
  @{'path'="HKLM:\Software\Voxengo\AudioPluginsInstall"; 'key'="DirVST2_32";  'value'="$vst2x86BitAware"; 'bit'=64,32; 'validpp'="NoVst2x86"}
}
function CreateRegistryFileObjects () { $global:regKeyFileObjects }
function CreateShortcutObjects () { $global:shortcuts }
function CreateSymlinkObjects () {
  if($pp["CompanyPath"] -ne $false) {
    $global:linkUserDataSupport = @{'linkPath'="$standardCompanyPath"; 'linkName'=""; 'destPath'=$companyPath; 'bit'=64,32; 'validpp'="NoVst2x64", "NoVst2x86", "NoVst3x64", "NoVst3x86", "NoAaxx86", "NoAaxx64"}
    $global:symlinks = $linkUserDataSupport
  } else {
    $global:symlinks
  }
}
function CreateInstallerObjects () {
  $global:installerComponentsList =
  @{'value'="shortcuts"; 'bit'=64,32; 'validpp'="NoShortcuts"},
  @{'value'="guides";    'bit'=64,32; 'validpp'="NoVst2x64", "NoVst2x86", "NoVst3x64", "NoVst3x86", "NoAaxx86", "NoAaxx64"},
  @{'value'="vst2_32";   'bit'=64,32; 'validpp'="NoVst2x86"},
  @{'value'="vst2_64";   'bit'=64;    'validpp'="NoVst2x64"},
  @{'value'="vst3_32";   'bit'=64,32; 'validpp'="NoVst3x86"},
  @{'value'="vst3_64";   'bit'=64;    'validpp'="NoVst3x64"},
  @{'value'="aax_32";    'bit'=64,32; 'validpp'="NoAaxx86"},
  @{'value'="aax_64";    'bit'=64;    'validpp'="NoAaxx64"}
}
function CreatePackageRessourcePathObjects () { $global:PackageRessourcePathList }
function CreateTxtFileObjects () { $global:PackageNewFiles }
function CreatePackageParametersObjects () {
  $global:packageArgs = @{
    packageName   = $packageName
    unzipLocation = $unzPath
    fileType      = 'exe'
    url           = $url32
    softwareName  = "$company $packageName*" #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
    checksum      = $checksum32
    checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  }
  $global:packageParametersObjectsList = $packageArgs
}
