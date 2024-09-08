$packageName = 'Hive'
$version = '2.1.2'
$softwareName = "${packageName} ${version}"
$company = 'u-he'
$url32        = 'https://u-he.com/downloads/releases/Hive_212_16520_Win.zip'
$releases = 'https://u-he.com/products/hive/'
$checksum32 = '8e467234f93fa8a073e3525f83f5c806bc1a825b75d130a86a7aa91e07c57470'
$global:companyPath = "${env:SYSTEMDRIVE}\VstPlugins\$company"
$global:vst2Path = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"
$global:vst2AddSubfolder = $true
$vst3Path = "${env:COMMONPROGRAMFILES}\VST3"
$vst3x86_64Path = "${env:COMMONPROGRAMFILES(x86)}\VST3"
$clapPath = "${env:COMMONPROGRAMFILES}\CLAP\u-he"
$aaxPath = "${env:COMMONPROGRAMFILES}\Avid\Audio\Plug-Ins"
$global:vst2DefaultPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2x86_64DefaultPathReg = @{'key'="HKLM:\SOFTWARE\WOW6432Node\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2ProductPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\$packageName"; 'name'="VSTPluginsPath"}
$global:uheDataPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\VST"; 'name'="DataPath"}
$global:uheProductDataPathReg = @{'key'="HKCU:\SOFTWARE\U-HE\$packageName"; 'name'="DataPath"}
$global:userFolderPath = $null
$unzipInstVersion = '212'
$unzInstPath = "${packageName}_Win\${packageName}-${unzipInstVersion}-Winstaller.exe"
$zipSuffix = "Win.zip"

# This needs to be wrapped into a function so this object also has the data from the package parameters
function CreateRegistryObjects () { $global:regKeys =
  # The installer does not have an option for custom paths so we need to create the registry entry before
  @{'path'=$vst2DefaultPathReg.key;       'key'=$vst2DefaultPathReg.name;       'value'="$vst2Path";                      'bit'=64;     'validpp'="NoVst2x64";              'delete'=$false},
  @{'path'=$vst2x86_64DefaultPathReg.key; 'key'=$vst2x86_64DefaultPathReg.name; 'value'="$vst2x86BitAware";               'bit'=64,32;  'validpp'="NoVst2x86";              'delete'=$false},
  @{'path'=$vst2ProductPathReg.key;       'key'=$vst2ProductPathReg.name;       'value'="$vst2Path";                      'bit'=64,32;  'validpp'="NoVst2x64","NoVst2x86";  'delete'=$true},
  @{'path'=$uheDataPathReg.key;           'key'=$uheDataPathReg.name;           'value'="$companyPath\$packageName.data"; 'bit'=64,32;  'validpp'="NoVst2x64","NoVst2x86";  'delete'=$false},
  @{'path'=$uheProductDataPathReg.key;    'key'=$uheProductDataPathReg.name;    'value'="$companyPath\$packageName.data"; 'bit'=64,32;  'validpp'="NoVst2x64","NoVst2x86";  'delete'=$true}
}
function CreateRegistryFileObjects () { $global:regKeyFileObjects }
function CreateShortcutObjects () { $global:shortcuts =
  @{'linkPath'="$vst2Path";        'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64,32; 'validpp'="NoVst2x64","NoVst2x86"},
  @{'linkPath'="$vst2x86BitAware"; 'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64;    'validpp'="NoVst2x86"},
  @{'linkPath'="$vst3Path";        'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64,32; 'validpp'="NoVst3x64","NoVst3x86"},
  @{'linkPath'="$vst3x86BitAware"; 'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64;    'validpp'="NoVst3x86"},
  @{'linkPath'="$clapPath";        'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64;    'validpp'="NoClapx64"},
  @{'linkPath'="$aaxPath\$packageName.aaxplugin\Contents\x64";          'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64; 'validpp'="NoAaxx64"}
}
function CreateSymlinkObjects () { $global:symlinks =
  @{'linkPath'="$companyPath\$packageName.data\UserPresets\$packageName"; 'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Presets";   'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Tunefiles";                'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Tunefiles"; 'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data";                          'linkName'="Support";         'destPath'="$userFolderPath\$company\$packageName\Support";   'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Presets\$packageName";     'linkName'="Third Party Libs";'destPath'="$companyPath\Third Party Presets\$packageName";   'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")}
}
function CreateInstallerObjects () { $global:installerComponentsList =
  #Warning: The order of the list *is* important
  @{'value'="vst2_32";   'bit'=64,32; 'validpp'="NoVst2x86"},
  @{'value'="vst2_64";   'bit'=64;    'validpp'="NoVst2x64"},
  @{'value'="vst3_32";   'bit'=64,32; 'validpp'="NoVst3x86"},
  @{'value'="vst3_64";   'bit'=64;    'validpp'="NoVst3x64"},
  @{'value'="clap_64";   'bit'=64;    'validpp'="NoClapx64"},
  @{'value'="aax_64";    'bit'=64;    'validpp'="NoAaxx64"},
  @{'value'="presets";   'bit'=64,32; 'validpp'="NoPresets"},
  @{'value'="nks";       'bit'=64,32; 'validpp'="NoNks"}
}
function CreatePackageRessourcePathObjects () { $global:PackageRessourcePathList }
function CreateTxtFileObjects () {
    $chocolateyPackageFolder = (Get-EnvironmentVariable -Name 'ChocolateyPackageFolder' -Scope Process)

# Finally, an official uninstaller!
  $global:PackageNewFiles <# = @{ 'key'="$chocolateyPackageFolder\uninstall.txt";'value'=
"$companyPath\$packageName.data\Data
$companyPath\$packageName.data\Documentation
$companyPath\$packageName.data\NKS
$companyPath\$packageName.data\Presets
$companyPath\$packageName.data\PresetDatabase
$companyPath\$packageName.data\license.txt
$companyPath\$packageName.data\$packageName user guide.pdf
$companyPath\$packageName.data\Hive Wavetables.pdf
$companyPath\$packageName.data\u-he Hive 2 Upgrade.pdf
$companyPath\$packageName.data\$packageName readme.rtf
$companyPath\$packageName.data\$packageName Preset Contributors.rtf
$vst2Path\$packageName(x64).dll
$vst2Path\$packageName.data.lnk
$vst2x86BitAware\$packageName.dll
$vst2x86BitAware\$packageName.data.lnk
$vst3Path\$packageName(x64).vst3
$vst3Path\$packageName.data.lnk
$vst3x86BitAware\$packageName.vst3
$vst3x86BitAware\$packageName.data.lnk
$aaxPath\$packageName.aaxplugin
$aaxx86BitAware\$packageName.aaxplugin"
;'encoding'="UTF8"; 'bom'=$false; 'validpp'="Always"; 'bit'=64,32}
  If (-not ($userFolderPath -eq "" -or $userFolderPath -eq $null)) {
    $global:PackageNewFiles["value"] +=
"
$companyPath\$packageName.data\Support
$companyPath\$packageName.data\UserPresets\$packageName\${env:username}
$companyPath\$packageName.data\Tunefiles\${env:username}
$companyPath\$packageName.data\Presets\$packageName\Third Party Libs
"
  } #>
}
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
    silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"${companyPath}\${packageName}.data`" " # Inno Setup
  }
  $global:packageParametersObjectsList = $packageArgs
}
function InstallerCompanyPathAutomaticDetection () {
  $global:autoInstDetectionCompanyPath = (ResolvePaths @("$vst2Path\$packageName.data.lnk", "$vst2x86_64Path\$packageName.data.lnk", "$vst3Path\$packageName.data.lnk", "$vst3x86_64Path\$packageName.data.lnk", "$clapPath\$packageName.data.lnk", "$aaxPath\$packageName.data.lnk")).Parent.FullName
}
import-module au

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases #1
  $regex   = "$zipSuffix" + '$'
  $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href #2
  $version = ((($url.Split('/') | select -Last 1).Replace("${packageName}_","")).Replace("_${zipSuffix}","")).Split('_') | select -First 1
#  since u-he version numbers aren't consistent (1.4 vs 1.4.1) this causes errors with the build number included (1.4.6987 
#  is a higher version number than 1.4.1.8978) so drop the build number alltogether
#  $build = ((($url.Split('/') | select -Last 1).Replace("${packageName}_","")).Replace("_${zipSuffix}","")).Split('_') | select -Last 1
  $stringLength = $version | measure-object -character | select -expandproperty characters
  $i = $stringLength
  while($i -gt 1) {
    $version = $version.ToString().Insert($i-1,'.')
    $i = $i -1
  }
  $global:workaroundPackageName = ("uhe-" + (Split-Path -Leaf $PSScriptRoot)).ToLower() -replace '\s+', '-'
  return @{ Version = $version; URL32 = $url; PackageName = $workaroundPackageName }
}

function global:au_BeforeUpdate() {
  $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
}

function global:au_SearchReplace {
  $versionWithoutDot = $($global:Latest.VERSION).Split('.')
  $versionWithoutDot = $versionWithoutDot -join ""
    @{
        "tools\chocolateyvariables.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
            "(^[$]unzipInstVersion\s*=\s*)('.*')" = "`$1'$($versionWithoutDot)'"
            "(^[$]version\s*=\s*)('.*')"      = "`$1'$($Latest.VERSION)'"
        }
    }
}

update -ChecksumFor none
Move-Item ($global:workaroundPackageName + "*" + ".nupkg") ..\ -Force
