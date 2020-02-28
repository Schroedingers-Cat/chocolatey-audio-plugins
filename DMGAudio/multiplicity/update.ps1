$packageName = 'Multiplicity'
$softwareName = "${packageName}*"
$company = 'DMGAudio'
$url32        = 'https://dmgaudio.com/dl/Multiplicity_v1.05/MultiplicityWin_v1.05.zip'
$releases = 'https://dmgaudio.com/products_multiplicity.php'
$checksum32 = 'd20427eeb4c9bad775edd1a5380fcd9df4183954eafc1654c5a14cc3d983fabc'
$global:companyPath = "${env:PROGRAMFILES}\$company"
$global:vst2Path = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"
$vst3Path = "${env:COMMONPROGRAMFILES}\VST3\$company"
$vst3x86_64Path = "${env:COMMONPROGRAMFILES(x86)}\VST3\$company"
$userFolderPath = "" ## implement empty user folder check
$presetProducts = "" ## implement empty check
$unzipInstVersion = '1.05'
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
import-module au

function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases #1
     $regex   = "$zipSuffix" + '$'
     $urlTemp     = $download_page.links | ? href -match $regex | select -First 1 -expand href #2
     $url = "https://dmgaudio.com" + $urlTemp
     Write-Host "$url"
     $version = ((($url.Split('/') | select -Last 1).Replace("${packageName}Win_v","")).Replace(".zip",""))
     return @{ Version = $version; URL32 = $url }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyvariables.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
            "(^[$]unzipInstVersion\s*=\s*)('.*')" = "`$1'$($global:Latest.VERSION)'"
        }
    }
}

update
Move-Item (${packageName} + "*" + ".nupkg") ..\ -Force
