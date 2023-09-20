$packageName = 'Filterscape'
$version = "1.5.0"
$softwareName = "$packageName $version"
$company = 'u-he'
$url32        = 'https://dl.u-he.com/releases/Filterscape_150_15011_Win.zip'
$releases = 'https://u-he.com/products/filterscape/'
$checksum32 = 'BBD37490139C986D2CDA1833DF1F9A8ABED15685BBEE11D19E2C4B7E8DF29500'
$global:companyPath = "${env:SYSTEMDRIVE}\VstPlugins\$company"
$global:vst2Path = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"
$global:vst2AddSubfolder = $true
$vst3Path = "${env:COMMONPROGRAMFILES}\VST3"
$vst3x86_64Path = "${env:COMMONPROGRAMFILES(x86)}\VST3"
$clapPath = "${env:COMMONPROGRAMFILES}\CLAP\u-he"
$aaxPath = "${env:COMMONPROGRAMFILES}\Avid\Audio\Plug-Ins"
$aaxx86_64Path = "${env:COMMONPROGRAMFILES(x86)}\Avid\Audio\Plug-Ins"
$global:vst2DefaultPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2x86_64DefaultPathReg = @{'key'="HKLM:\SOFTWARE\WOW6432Node\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2ProductPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\$packageName"; 'name'="VSTPluginsPath"}
$global:uheDataPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\VST"; 'name'="DataPath"}
$global:uheProductDataPathReg = @{'key'="HKCU:\SOFTWARE\U-HE\$packageName"; 'name'="DataPath"}
$global:userFolderPath = $null
$unzipInstVersion = '150'
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
  @{'linkPath'="$aaxPath\$packageName.aaxplugin\Contents\x64";          'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64; 'validpp'="NoAaxx64"},
  @{'linkPath'="$aaxx86BitAware\$packageName.aaxplugin\Contents\x64";   'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64; 'validpp'="NoAaxx86"},
  @{'linkPath'="$aaxx86BitAware\$packageName.aaxplugin\Contents\Win32"; 'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=32; 'validpp'="NoAaxx86"}
}
function CreateSymlinkObjects () { $global:symlinks =
  @{'linkPath'="$companyPath\$packageName.data\UserPresets\$packageName";  'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Presets\Filterscape";    'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\UserPresets\FilterscapeVA"; 'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Presets\FilterscapeVA";  'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\UserPresets\FilterscapeQ6"; 'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Presets\FilterscapeQ6";  'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data";                           'linkName'="Support";         'destPath'="$userFolderPath\$company\$packageName\Support";                'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")}
}
function CreateInstallerObjects () { $global:installerComponentsList =
  #Warning: The order of the list *is* important
  @{'value'="vst2_32";   'bit'=64,32; 'validpp'="NoVst2x86"},
  @{'value'="vst2_64";   'bit'=64;    'validpp'="NoVst2x64"},
  @{'value'="vst3_32";   'bit'=64,32; 'validpp'="NoVst3x86"},
  @{'value'="vst3_64";   'bit'=64;    'validpp'="NoVst3x64"},
  @{'value'="clap_64";   'bit'=64;    'validpp'="NoClapx64"},
  @{'value'="aax_64";    'bit'=64;    'validpp'="NoAaxx64"},
  @{'value'="presets";   'bit'=64,32; 'validpp'="NoPresets"}
}
function CreatePackageRessourcePathObjects () { $global:PackageRessourcePathList }
function CreateTxtFileObjects () {
  $chocolateyPackageFolder = (Get-EnvironmentVariable -Name 'ChocolateyPackageFolder' -Scope Process)

# Finally, an official uninstaller!
  $global:PackageNewFiles <# = @{ 'key'="$chocolateyPackageFolder\uninstall.txt";'value'=
"$companyPath\$packageName.data\Data
$companyPath\$packageName.data\Documentation\license.txt
$companyPath\$packageName.data\Documentation\$softwareName user guide.pdf
$companyPath\$packageName.data\Presets
$companyPath\$packageName.data\PresetDatabase
$vst2Path\Filterscape(x64).dll
$vst2Path\FilterscapeVA(x64).dll
$vst2Path\FilterscapeQ6(x64).dll
$vst2Path\$packageName.data.lnk
$vst2x86BitAware\$packageName.dll
$vst2x86BitAware\FilterscapeVA.dll
$vst2x86BitAware\FilterscapeQ6.dll
$vst2x86BitAware\$packageName.data.lnk
$vst3Path\Filterscape(x64).vst3
$vst3Path\$packageName.data.lnk
$clapPath\$packageName.clap
$clapPath\$packageName.data.lnk
$vst3x86BitAware\$packageName.vst3
$vst3x86BitAware\$packageName.data.lnk
$aaxPath\$packageName.aaxplugin"
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
    softwareName  = "$softwareName" #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
    checksum      = $checksum32
    checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /Dir=`"${companyPath}\${packageName}.data`" " # Inno Setup
  }
  $global:packageParametersObjectsList = $packageArgs
}
function InstallerCompanyPathAutomaticDetection () {
  $global:autoInstDetectionCompanyPath = (ResolvePaths @("$vst2Path\$packageName.data.lnk", "$vst2x86_64Path\$packageName.data.lnk", "$vst3Path\$packageName.data.lnk", "$vst3x86_64Path\$packageName.data.lnk", "$clapPath\$packageName.data.lnk", "$aaxPath\$packageName.data.lnk")).Parent.FullName
}
