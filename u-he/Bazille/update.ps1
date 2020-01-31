$packageName = 'Bazille'
$softwareName = "${packageName}"
$company = 'u-he'
$url32        = 'https://uhedownloads-heckmannaudiogmb.netdna-ssl.com/releases/Bazille_11_3898_Win.zip'
$releases = 'https://u-he.com/products/bazille/'
$checksum32 = 'cd067938bcd14df3bdf4ace4b4783691f273ff48e69cfbc4d69262cb13f88497'
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
$unzipInstVersion = '11'
$unzInstPath = "${packageName}_Win\${packageName}${unzipInstVersion}Winstaller.exe"
$zipSuffix = "Win.zip"

# This needs to be wrapped into a function so this object also has the data from the package parameters
function CreateRegistryObjects () { $global:regKeys =
  # The installer does not have an option for custom paths so we need to create the registry entry before
  @{'path'=$vst2PathReg.key;                                        'key'=$vst2PathReg.name;      'value'="$vst2Path";                    'bit'=64;     'validpp'="NoVst2x64"; 'delete'=$false},
  @{'path'=$vst2x86_64PathReg.key;                                  'key'=$vst2x86_64PathReg.name;'value'="$vst2x86BitAware";             'bit'=64,32;  'validpp'="NoVst2x86"; 'delete'=$false}
}
function CreateRegistryFileObjects () { $global:regKeyFileObjects }
function CreateShortcutObjects () { $global:shortcuts =
  @{'linkPath'="$vst2Path";        'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64,32; 'validpp'="NoVst2x64","NoVst2x86"},
  @{'linkPath'="$vst2x86BitAware"; 'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64;    'validpp'="NoVst2x86"},
  @{'linkPath'="$aaxPath\$packageName.aaxplugin\Contents\x64";          'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64; 'validpp'="NoAaxx64"},
  @{'linkPath'="$aaxx86BitAware\$packageName.aaxplugin\Contents\x64";   'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=64; 'validpp'="NoAaxx86"},
  @{'linkPath'="$aaxx86BitAware\$packageName.aaxplugin\Contents\Win32"; 'linkName'="$packageName.data.lnk"; 'destPath'="$companyPath\$packageName.data"; 'bit'=32; 'validpp'="NoAaxx86"}
}
function CreateSymlinkObjects () { $global:symlinks =
  @{'linkPath'="$companyPath\$packageName.data\Presets\$packageName"; 'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Presets";   'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Tunefiles";            'linkName'="${env:username}"; 'destPath'="$userFolderPath\$company\$packageName\Tunefiles"; 'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data";                      'linkName'="Support";         'destPath'="$userFolderPath\$company\$packageName\Support";   'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")},
  @{'linkPath'="$companyPath\$packageName.data\Presets\$packageName"; 'linkName'="Third Party Libs";'destPath'="$companyPath\Third Party Presets\$packageName";   'validpp'='Always'; 'bit'=64,32; 'dropIfNull'=@("$userFolderPath")}
}
function CreateInstallerObjects () { $global:installerComponentsList =
  #Warning: The order of the list *is* important
  @{'value'="vst2_32";   'bit'=64,32; 'validpp'="NoVst2x86"},
  @{'value'="vst2_64";   'bit'=64;    'validpp'="NoVst2x64"},
  @{'value'="aax_32";    'bit'=64,32; 'validpp'="NoAaxx86"},
  @{'value'="aax_64";    'bit'=64;    'validpp'="NoAaxx64"},
  @{'value'="presets";   'bit'=64,32; 'validpp'="NoPresets"}
}
function CreatePackageRessourcePathObjects () { $global:PackageRessourcePathList }
function CreateTxtFileObjects () {
  $global:PackageNewFiles = @{ 'key'="$env:ChocolateyPackageFolder\uninstall.txt";'value'=
"$companyPath\$packageName.data\Data
$companyPath\$packageName.data\Extras
$companyPath\$packageName.data\NKS
$companyPath\$packageName.data\PresetDatabase
$companyPath\$packageName.data\license.txt
$companyPath\$packageName.data\$packageName user guide.pdf
$vst2Path\$packageName(x64).dll
$vst2Path\$packageName.data.lnk
$vst2x86BitAware\$packageName.dll
$vst2x86BitAware\$packageName.data.lnk
$aaxPath\$packageName.aaxplugin
$aaxx86BitAware\$packageName.aaxplugin"
;'encoding'="UTF8"; 'bom'=$false; 'validpp'="Always"; 'bit'=64,32}
  If (-not ($userFolderPath -eq "" -or $userFolderPath -eq $null)) {
    $global:PackageNewFiles["value"] +=
"
$companyPath\$packageName.data\Support
$companyPath\$packageName.data\Presets\$packageName\${env:username}
$companyPath\$packageName.data\Tunefiles\${env:username}
$companyPath\$packageName.data\Presets\$packageName\Third Party Libs
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
import-module au

function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases #1
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
