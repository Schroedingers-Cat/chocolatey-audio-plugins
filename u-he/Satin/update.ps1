$packageName = 'Satin'
$softwareName = "${packageName}"
$company = 'u-he'
$url32        = 'https://dl.u-he.com/releases/Satin_133_15721_Win.zip'
$releases = 'https://u-he.com/products/satin/'
$checksum32 = 'a3e8662da4b883e7b7458cfdee93cde1ef384189894852f8f4bf2b1daa8efd45'
$global:companyPath = "${env:SYSTEMDRIVE}\VstPlugins\$company"
$global:vst2Path = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"
$global:vst2AddSubfolder = $true
$vst3Path = "${env:COMMONPROGRAMFILES}\VST3"
$vst3x86_64Path = "${env:COMMONPROGRAMFILES(x86)}\VST3"
$aaxPath = "${env:COMMONPROGRAMFILES}\Avid\Audio\Plug-Ins"
$global:vst2DefaultPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2x86_64DefaultPathReg = @{'key'="HKLM:\SOFTWARE\WOW6432Node\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2ProductPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\$packageName"; 'name'="VSTPluginsPath"}
$global:userFolderPath = $null
$unzipInstVersion = '133'
$unzInstPath = "${packageName}_Win\${packageName}-${unzipInstVersion}-Winstaller.exe"
$zipSuffix = "Win.zip"

# This needs to be wrapped into a function so this object also has the data from the package parameters
function CreateRegistryObjects () { $global:regKeys =
  # The installer does not have an option for custom paths so we need to create the registry entry before
  @{'path'=$vst2DefaultPathReg.key;       'key'=$vst2DefaultPathReg.name;       'value'="$vst2Path";        'bit'=64;     'validpp'="NoVst2x64";              'delete'=$false},
  @{'path'=$vst2x86_64DefaultPathReg.key; 'key'=$vst2x86_64DefaultPathReg.name; 'value'="$vst2x86BitAware"; 'bit'=64,32;  'validpp'="NoVst2x86";              'delete'=$false},
  @{'path'=$vst2ProductPathReg.key;       'key'=$vst2ProductPathReg.name;       'value'="$vst2Path";        'bit'=64,32;  'validpp'="NoVst2x64","NoVst2x86";  'delete'=$true}
}
function CreateRegistryFileObjects () { $global:regKeyFileObjects }
function CreateShortcutObjects () { $global:shortcuts =
  @{'linkPath'="$vst2Path";        'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64,32; 'validpp'="NoVst2x64","NoVst2x86"},
  @{'linkPath'="$vst2x86BitAware"; 'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64;    'validpp'="NoVst2x86"},
  @{'linkPath'="$vst3Path";        'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64,32; 'validpp'="NoVst3x64","NoVst3x86"},
  @{'linkPath'="$vst3x86BitAware"; 'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64;    'validpp'="NoVst3x86"},
  @{'linkPath'="$aaxPath\$packageName.aaxplugin\Contents\x64";          'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64; 'validpp'="NoAaxx64"}
}
function CreateSymlinkObjects () { $global:symlinks =
  @{'linkPath'="$companyPath\$packageName.data\UserPresets\$packageName"; 'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Presets"; 'validpp'='NoUserFolder'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data";                          'linkName'="Support";         'destPath'="$userFolderPath\$company\$packageName\Support"; 'validpp'='NoUserFolder'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")}
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
  @{'value'="nks";       'bit'=64,32; 'validpp'="NoPresets"}
}
function CreatePackageRessourcePathObjects () { $global:PackageRessourcePathList }

# Finally, an official uninstaller!
function CreateTxtFileObjects () {
    $chocolateyPackageFolder <# = (Get-EnvironmentVariable -Name 'ChocolateyPackageFolder' -Scope Process)

  $global:PackageNewFiles = @{ 'key'="$chocolateyPackageFolder\uninstall.txt";'value'=
"$companyPath\$packageName.data\Data
$companyPath\$packageName.data\Extras
$companyPath\$packageName.data\NKS
$companyPath\$packageName.data\Presets
$companyPath\$packageName.data\PresetDatabase
$companyPath\$packageName.data\license.txt
$companyPath\$packageName.data\$packageName user guide.pdf
$vst2Path\$packageName(x64).dll
$vst2Path\$packageName.data.lnk
$vst2x86BitAware\$packageName.dll
$vst2x86BitAware\$packageName.data.lnk
$vst3Path\$packageName(x64).vst3
$vst3Path\$packageName.data.lnk
$vst3x86BitAware\$packageName.vst3
$vst3x86BitAware\$packageName.data.lnk
$aaxPath\$packageName.aaxplugin
;'encoding'="UTF8"; 'bom'=$false; 'validpp'="Always"; 'bit'=64,32}
  If (-not ($userFolderPath -eq "" -or $userFolderPath -eq $null)) {
    $global:PackageNewFiles["value"] += "`n$companyPath\$packageName.data\Support`n$companyPath\$packageName.data\UserPresets\$packageName\${env:username}"
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
  $global:autoInstDetectionCompanyPath = (ResolvePaths @("$vst2Path\$softwareName.data.lnk", "$vst2x86_64Path\$softwareName.data.lnk", "$vst3Path\$softwareName.data.lnk", "$vst3x86_64Path\$softwareName.data.lnk", "$aaxPath\$softwareName.data.lnk")).Parent.FullName
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
        }
    }
}

update -ChecksumFor none
Move-Item ($global:workaroundPackageName + "*" + ".nupkg") ..\ -Force
