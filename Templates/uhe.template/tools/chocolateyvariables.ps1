$packageNameFull = '[[PackageName]]'
$version = '[[Version]]'
$company = '[[Author]]'
$packageName = $packageNameFull.Replace(" ", "")
$softwareName = "$packageName ${version}"
$versionWithoutDots = $version -replace "\.", ""
$revision = '[[Revision]]'
$url        = "https://u-he.com/downloads/releases/[[PackageNameUrl]]_${versionWithoutDots}_${revision}_Win.zip"
$urlAlternative = "https://u-he.com/downloads/release-archive//[[PackageAlternativeUrlDirectory]]//[[PackageNameUrl]]_${versionWithoutDots}_${revision}_Win.zip"
$releases = 'https://u-he.com/products/[[ProductPageName]]/'
$checksum = '[[Checksum]]'
# The installer doesn't have a default value, causing installation to exit without success if we don't provide a default value
$global:vst2Path = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"
$global:vst2AddSubfolder = $true
$global:vst2DefaultPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2x86_64DefaultPathReg = @{'key'="HKLM:\SOFTWARE\WOW6432Node\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2ProductPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\$packageName"; 'name'="VSTPluginsPath"}
$global:uheDataPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\VST"; 'name'="DataPath"}
$global:uheProductDataPathReg = @{'key'="HKCU:\SOFTWARE\U-HE\$packageName"; 'name'="DataPath"}
$global:userFolderPath = $null
$unzInstPath = "${packageName}_Win\${packageName}-${versionWithoutDots}-Winstaller.exe"
$zipSuffix = "Win.zip"

# This needs to be wrapped into a function so this object also has the data from the package parameters
function CreateRegistryObjects () { $global:regKeys =
  # The installer does not have an option for custom paths so we need to create the registry entry before
  # We drop those keys if they're null, but as long as the u-he installer doesn't come with sensible default values (or actually, any default values at all), we practically always have to create the registry keys
  # @{'path'=$vst2DefaultPathReg.key;       'key'=$vst2DefaultPathReg.name;       'value'="$vst2Path";                      'bit'=64;     'validpp'="NoVst2x64";              'delete'=$false;  'dropIfNull'=@("$vst2Path")},
  # @{'path'=$vst2x86_64DefaultPathReg.key; 'key'=$vst2x86_64DefaultPathReg.name; 'value'="$vst2x86BitAware";               'bit'=64,32;  'validpp'="NoVst2x86";              'delete'=$false;  'dropIfNull'=@("$vst2x86BitAware")},
  # @{'path'=$vst2ProductPathReg.key;       'key'=$vst2ProductPathReg.name;       'value'="$vst2Path";                      'bit'=64,32;  'validpp'="NoVst2x64","NoVst2x86";  'delete'=$true;   'dropIfNull'=@("$vst2Path")},
  @{'path'=$uheDataPathReg.key;           'key'=$uheDataPathReg.name;           'value'="$companyPath\$packageName.data"; 'bit'=64,32;  'validpp'="Always";                 'delete'=$false;  'dropIfNull'=@("$companyPath")},
  @{'path'=$uheProductDataPathReg.key;    'key'=$uheProductDataPathReg.name;    'value'="$companyPath\$packageName.data"; 'bit'=64,32;  'validpp'="Always";                 'delete'=$true;   'dropIfNull'=@("$companyPath")}
}

function CreateInstallerObjects () { $global:installerComponentsList =
  #Warning: The order of the list *is* important
  # u-he's current installer stopped being able to pick up VST2 path values from the registry
  # That changes makes it mandatory to enter the VST2 path via the GUI breaking silent installation
  # So we disable the VST2 plugin option for now
  # @{'value'="vst2_32";   'bit'=64,32; 'validpp'="NoVst2x86"},
  # @{'value'="vst2_64";   'bit'=64;    'validpp'="NoVst2x64"},
  @{'value'="vst3_32";   'bit'=64,32; 'validpp'="NoVst3x86"},
  @{'value'="vst3_64";   'bit'=64;    'validpp'="NoVst3x64"},
  @{'value'="clap_64";   'bit'=64;    'validpp'="NoClapx64"},
  @{'value'="aax_64";    'bit'=64;    'validpp'="NoAaxx64"},
  @{'value'="presets";   'bit'=64,32; 'validpp'="NoPresets"},
  @{'value'="nks";       'bit'=64,32; 'validpp'="NoNks"}
}

function CreatePackageParametersObjects () {
  $global:packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $unzPath
    fileType       = 'exe'
    url            = $url
    urlAlternative = $urlAlternative
    softwareName   = $softwareName
    checksum       = $checksum
    checksumType   = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- " # Inno Setup
  }

  $global:packageParametersObjectsList = $packageArgs
}
