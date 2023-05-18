$packageName    = 'r8brain PRO'
$company        = 'Voxengo'
$softwareName   = "$company $packageName"
$url32          = 'https://www.voxengo.com/files/Voxengor8brainPRO_211_Win64_setup.exe'
$releases       = 'https://www.voxengo.com/product/r8brainpro/'
$checksum32     = '1833d5ff8b6f1de18f2bdf42b3636c9465f4b5086a03b0f0f8b49b39efdb5e1a'
$global:companyPath    = "${env:PROGRAMFILES}\$company"

function CreateRegistryObjects () {
  $global:regKeys =
  @{'path'="HKLM:\\SOFTWARE\chocolatey\$env:ChocolateyPackageName"; 'key'="CompanyPath";          'value'="$global:companyPath";          'bit'=64,32;  'validpp'="NoVst2x64", "NoVst2x86", "NoVst3x64", "NoVst3x86", "NoAaxx86", "NoAaxx64"},
  @{'path'="HKLM:\\SOFTWARE\chocolatey\$env:ChocolateyPackageName"; 'key'="InstallerComponents";  'value'="$global:installerComponents";  'bit'=64,32;  'validpp'="Always"}
}
function CreateRegistryFileObjects () { $global:regKeyFileObjects }
function CreateShortcutObjects () { $global:shortcuts }
function CreateSymlinkObjects () {
  if($pp["CompanyPath"] -ne $false) {
    $global:linkUserDataSupport = @{'linkPath'="$standardCompanyPath"; 'linkName'=""; 'destPath'=$global:companyPath; 'bit'=64,32; 'validpp'="NoVst2x64", "NoVst2x86", "NoVst3x64", "NoVst3x86", "NoAaxx86", "NoAaxx64"}
    $global:symlinks = $linkUserDataSupport
  } else {
    $global:symlinks
  }
}
function CreateInstallerObjects () {
  $global:installerComponentsList =
  @{'value'="exec_64";   'bit'=64; 'validpp'="Always"},
  @{'value'="guides";    'bit'=64,32; 'validpp'="Always"},
  @{'value'="shortcuts"; 'bit'=64,32; 'validpp'="NoShortcuts"},
  @{'value'="desktopsc"; 'bit'=64,32; 'validpp'="NoShortcuts"}
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
