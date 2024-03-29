﻿$packageName = 'Repro'
$softwareName = "Repro-1"
$company = 'u-he'
$url32        = 'https://dl.u-he.com/releases/Repro_112_12092_Win.zip'
$releases = 'https://u-he.com/products/repro/'
$checksum32 = '9720268c6c2ca769ccd9dd383f2114bb3c1ec0aa3b0a949ffa17a8ecf4e4a418'
$global:companyPath = "${env:SYSTEMDRIVE}\VstPlugins\$company"
$global:vst2Path = "${env:PROGRAMFILES}\Steinberg\VSTPlugins\$company"
$global:vst2x86_64Path = "${env:ProgramFiles(x86)}\Steinberg\VSTPlugins\$company"
$global:vst2AddSubfolder = $true
$vst3Path = "${env:COMMONPROGRAMFILES}\VST3"
$vst3x86_64Path = "${env:COMMONPROGRAMFILES(x86)}\VST3"
$aaxPath = "${env:COMMONPROGRAMFILES}\Avid\Audio\Plug-Ins"
$aaxx86_64Path = "${env:COMMONPROGRAMFILES(x86)}\Avid\Audio\Plug-Ins"
$global:vst2PathReg = @{'key'="HKLM:\SOFTWARE\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:vst2x86_64PathReg = @{'key'="HKLM:\SOFTWARE\WOW6432Node\U-HE\VST"; 'name'="VSTPluginsPath"}
$global:userFolderPath = $null
$unzipInstVersion = '112'
$unzInstPath = "Repro-1_Win\${packageName}${unzipInstVersion}Winstaller.exe"
$zipSuffix = "Win.zip"

# This needs to be wrapped into a function so this object also has the data from the package parameters
function CreateRegistryObjects () { $global:regKeys =
  # The installer does not have an option for custom paths so we need to create the registry entry before
  @{'path'=$vst2PathReg.key;                                        'key'=$vst2PathReg.name;      'value'="$vst2Path";                    'bit'=64;     'validpp'="NoVst2x64"; 'delete'=$false},
  @{'path'=$vst2x86_64PathReg.key;                                  'key'=$vst2x86_64PathReg.name;'value'="$vst2x86BitAware";             'bit'=64,32;  'validpp'="NoVst2x86"; 'delete'=$false}
}
function CreateRegistryFileObjects () { $global:regKeyFileObjects }
function CreateShortcutObjects () { $global:shortcuts =
  @{'linkPath'="$vst2Path";        'linkName'="$softwareName.data.lnk"; 'destPath'="$companyPath\$softwareName.data"; 'bit'=64,32; 'validpp'="NoVst2x64","NoVst2x86"},
  @{'linkPath'="$vst2x86BitAware"; 'linkName'="$softwareName.data.lnk"; 'destPath'="$companyPath\$softwareName.data"; 'bit'=64;    'validpp'="NoVst2x86"},
  @{'linkPath'="$vst3Path";        'linkName'="$softwareName.data.lnk"; 'destPath'="$companyPath\$softwareName.data"; 'bit'=64,32; 'validpp'="NoVst3x64","NoVst3x86"},
  @{'linkPath'="$vst3x86BitAware"; 'linkName'="$softwareName.data.lnk"; 'destPath'="$companyPath\$softwareName.data"; 'bit'=64;    'validpp'="NoVst3x86"},
  @{'linkPath'="$aaxPath\$packageName.aaxplugin\Contents\x64";          'linkName'="$softwareName.data.lnk"; 'destPath'="$companyPath\$softwareName.data"; 'bit'=64; 'validpp'="NoAaxx64"},
  @{'linkPath'="$aaxx86BitAware\$packageName.aaxplugin\Contents\x64";   'linkName'="$softwareName.data.lnk"; 'destPath'="$companyPath\$softwareName.data"; 'bit'=64; 'validpp'="NoAaxx86"},
  @{'linkPath'="$aaxx86BitAware\$packageName.aaxplugin\Contents\Win32"; 'linkName'="$softwareName.data.lnk"; 'destPath'="$companyPath\$softwareName.data"; 'bit'=32; 'validpp'="NoAaxx86"}
}
function CreateSymlinkObjects () { $global:symlinks =
  @{'linkPath'="$companyPath\$softwareName.data\UserPresets\Repro-1";  'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Presets\Repro-1";      'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$softwareName.data\UserPresets\Repro-5";  'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Presets\Repro-5";      'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$softwareName.data\Tunefiles";            'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Tunefiles";            'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$softwareName.data";                      'linkName'="Support";         'destPath'="$userFolderPath\$company\$packageName\Support";              'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$softwareName.data\Presets\Repro-1";      'linkName'="Third Party Libs";'destPath'="$companyPath\Third Party Presets\Repro-1";                   'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$softwareName.data\Presets\Repro-5";      'linkName'="Third Party Libs";'destPath'="$companyPath\Third Party Presets\Repro-5";                   'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")}
}
function CreateInstallerObjects () { $global:installerComponentsList =
  #Warning: The order of the list *is* important
  @{'value'="vst2_32";   'bit'=64,32; 'validpp'="NoVst2x86"},
  @{'value'="vst2_64";   'bit'=64;    'validpp'="NoVst2x64"},
  @{'value'="vst3_32";   'bit'=64,32; 'validpp'="NoVst3x86"},
  @{'value'="vst3_64";   'bit'=64;    'validpp'="NoVst3x64"},
  @{'value'="aax_32";    'bit'=64,32; 'validpp'="NoAaxx86"},
  @{'value'="aax_64";    'bit'=64;    'validpp'="NoAaxx64"},
  @{'value'="presets";   'bit'=64,32; 'validpp'="NoPresets"},
  @{'value'="nks";       'bit'=64,32; 'validpp'="NoPresets"}
}
function CreatePackageRessourcePathObjects () { $global:PackageRessourcePathList }
function CreateTxtFileObjects () {
  $global:PackageNewFiles = @{ 'key'="$env:ChocolateyPackageFolder\uninstall.txt";'value'=
"$companyPath\$softwareName.data\Data
$companyPath\$softwareName.data\Modules
$companyPath\$softwareName.data\NKS
$companyPath\$softwareName.data\Presets
$companyPath\$softwareName.data\PresetDatabase
$companyPath\$softwareName.data\license.txt
$companyPath\$softwareName.data\$softwareName user guide.pdf
$companyPath\$softwareName.data\Repro-5 user guide.pdf
$vst2Path\$softwareName(x64).dll
$vst2Path\$packageName-5(x64).dll
$vst2Path\$softwareName.data.lnk
$vst2x86BitAware\$softwareName.dll
$vst2x86BitAware\$softwareName.data.lnk
$vst3Path\$softwareName(x64).vst3
$vst3Path\$softwareName.data.lnk
$vst3x86BitAware\$softwareName.vst3
$vst3x86BitAware\$softwareName.data.lnk
$aaxPath\$softwareName.aaxplugin
$aaxx86BitAware\$softwareName.aaxplugin"
;'encoding'="UTF8"; 'bom'=$false; 'validpp'="Always"; 'bit'=64,32}
  If (-not ($userFolderPath -eq "" -or $userFolderPath -eq $null)) {
    $global:PackageNewFiles["value"] +=
"
$companyPath\$softwareName.data\Support
$companyPath\$softwareName.data\UserPresets\$softwareName\${env:username}
$companyPath\$softwareName.data\UserPresets\Repro-5\${env:username}
$companyPath\$softwareName.data\Tunefiles\${env:username}
$companyPath\$softwareName.data\Presets\Repro-1\Third Party Libs
$companyPath\$softwareName.data\Presets\Repro-5\Third Party Libs
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
    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  }
  $global:packageParametersObjectsList = $packageArgs
}
function InstallerCompanyPathAutomaticDetection () {
  $global:autoInstDetectionCompanyPath = (ResolvePaths @("$vst2Path\$softwareName.data.lnk", "$vst2x86_64Path\$softwareName.data.lnk", "$vst3Path\$softwareName.data.lnk", "$vst3x86_64Path\$softwareName.data.lnk", "$aaxPath\$softwareName.data.lnk", "$aaxx86_64Path\$softwareName.data.lnk")).Parent.FullName
}
