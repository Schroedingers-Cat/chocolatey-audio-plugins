$packageName = 'ZebraHZ'
# Sometimes, ZebraHZ is referred to as The Dark Zebra (ZebraHZ + Soundset)
$packageNameAlternative = "The Dark Zebra"
$softwareName = "${packageName}"
$company = 'u-he'
$url32        = 'https://dl.u-he.com/releases/Zebra_Legacy_293_12092_Win.zip'
$releases = 'https://u-he.com/products/zebra-legacy/'
$checksum32 = 'B5C62286D0AE38C384ACF8B1BD5495E1CEF169ED2C64ABBC2C5BFCD9CD475AD5'
$global:companyPath = "${env:SYSTEMDRIVE}\VstPlugins\$company"
$global:vst2Path = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"
$global:vst2AddSubfolder = $true
$vst3Path = "${env:COMMONPROGRAMFILES}\VST3"
$vst3x86_64Path = "${env:COMMONPROGRAMFILES(x86)}\VST3"
$aaxPath = "${env:COMMONPROGRAMFILES}\Avid\Audio\Plug-Ins"
$aaxx86_64Path = "${env:COMMONPROGRAMFILES(x86)}\Avid\Audio\Plug-Ins"
$global:vst2DefaultPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2x86_64DefaultPathReg = @{'key'="HKLM:\SOFTWARE\WOW6432Node\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2ProductPathReg = @{'key'="HKLM:\SOFTWARE\U-HE\$packageName"; 'name'="VSTPluginsPath"}
$global:userFolderPath = $null
$unzipInstVersion = '2.9.3'
$unzInstPath = "02 ${packageNameAlternative}\${packageNameAlternative} ${unzipInstVersion} Win Installer.exe"
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
  @{'linkPath'="$aaxPath\$packageName.aaxplugin\Contents\x64";          'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64; 'validpp'="NoAaxx64"},
  @{'linkPath'="$aaxx86BitAware\$packageName.aaxplugin\Contents\x64";   'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64; 'validpp'="NoAaxx86"},
  @{'linkPath'="$aaxx86BitAware\$packageName.aaxplugin\Contents\Win32"; 'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=32; 'validpp'="NoAaxx86"}
}
function CreateSymlinkObjects () { $global:symlinks =
  @{'linkPath'="$companyPath\$packageName.data\UserPresets\$packageName"; 'linkName'="${env:username}";  'destPath'="$userFolderPath\$company\$packageName\Presets\$packageName"; 'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Modules\MSEG";             'linkName'="${env:username}";  'destPath'="$userFolderPath\$company\$packageName\Modules\MSEG";         'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Modules\Oscillator";       'linkName'="${env:username}";  'destPath'="$userFolderPath\$company\$packageName\Modules\Oscillator";   'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Tunefiles";                'linkName'="${env:username}";  'destPath'="$userFolderPath\$company\$packageName\Tunefiles";            'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data";                          'linkName'="Support";          'destPath'="$userFolderPath\$company\$packageName\Support";              'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Presets\$packageName";     'linkName'="Third Party Z2";   'destPath'="$companyPath\Third Party Presets\$packageName\Presets";      'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Modules\MSEG";             'linkName'="Third Party MSEGs";'destPath'="$companyPath\Third Party Presets\$packageName\MSEGs";        'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Modules\Oscillator";       'linkName'="Third Party OSCs"; 'destPath'="$companyPath\Third Party Presets\$packageName\OSCs";         'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")}
}
function CreateInstallerObjects () { $global:installerComponentsList =
  #Warning: The order of the list *is* important
  @{'value'="vst2_32";                'bit'=64,32; 'validpp'="NoVst2x86"},
  @{'value'="vst2_64";                'bit'=64;    'validpp'="NoVst2x64"},
  @{'value'="vst3_32";                'bit'=64,32; 'validpp'="NoVst3x86"},
  @{'value'="vst3_64";                'bit'=64;    'validpp'="NoVst3x64"},
  @{'value'="aax_32";                 'bit'=64,32; 'validpp'="NoAaxx86"},
  @{'value'="aax_64";                 'bit'=64;    'validpp'="NoAaxx64"},
  @{'value'="the_dark_zebra_presets"; 'bit'=64,32; 'validpp'="NoPresets"},
  @{'value'="nks";                    'bit'=64,32; 'validpp'="NoNks"}
}
function CreatePackageRessourcePathObjects () { $global:PackageRessourcePathList }
function CreateTxtFileObjects () {
    $chocolateyPackageFolder = (Get-EnvironmentVariable -Name 'ChocolateyPackageFolder' -Scope Process)

  $global:PackageNewFiles = @{ 'key'="$chocolateyPackageFolder\uninstall.txt";'value'=
"$companyPath\$packageName.data\Data
$companyPath\$packageName.data\Documentation\license.txt
$companyPath\$packageName.data\Documentation\$packageName user guide.pdf
$companyPath\$packageName.data\Modules\MSEG\Factory MSEGs
$companyPath\$packageName.data\Modules\Oscillator\Factory OSCs
$companyPath\$packageName.data\NKS
$companyPath\$packageName.data\Presets
$companyPath\$packageName.data\PresetDatabase
$companyPath\$packageName.data\license.txt
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
$companyPath\$packageName.data\UserPresets\$packageName\Zebra2
$companyPath\$packageName.data\Modules\Oscillator\${env:username}
$companyPath\$packageName.data\Modules\MSEG\${env:username}
$companyPath\$packageName.data\Tunefiles\${env:username}
$companyPath\$packageName.data\Presets\$packageName\Third Party Z2
$companyPath\$packageName.data\Modules\MSEG\Third Party MSEGs
$companyPath\$packageName.data\Modules\Oscillator\Third Party OSCs
"
  }
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
  $global:autoInstDetectionCompanyPath = (ResolvePaths @("$vst2Path\$softwareName.data.lnk", "$vst2x86_64Path\$softwareName.data.lnk", "$vst3Path\$softwareName.data.lnk", "$vst3x86_64Path\$softwareName.data.lnk", "$aaxPath\$softwareName.data.lnk", "$aaxx86_64Path\$softwareName.data.lnk")).Parent.FullName
}
