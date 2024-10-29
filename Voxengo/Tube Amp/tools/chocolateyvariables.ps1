﻿$packageName    = 'Tube Amp'
$company        = 'Voxengo'
$softwareName   = "$company $packageName"
$url32          = 'https://www.voxengo.com/files/VoxengoTubeAmp_213_Win32_64_VST_VST3_AAX_setup.exe'
$releases       = 'https://www.voxengo.com/product/tubeamp/'
$checksum32     = '10c3ee971ffee884f90f3b7fdea0f42c158bfb7fcd0876408fc165024b8a25e1'

function CreateRegistryObjects () {
  # The installer does not have an option for custom paths so we need to create the registry entry before
  $global:regKeys

  if (![string]::IsNullOrWhiteSpace($global:vst2Path)) {
    $global:regKeys += @{'path' = "HKLM:\Software\Voxengo\AudioPluginsInstall"; 'key' = "DirVST2_64"; 'value' = "$global:vst2Path"; 'bit' = 64; 'validpp' = "NoVst2x64" }
  }

  if (![string]::IsNullOrWhiteSpace($global:vst2x86BitAware)) {
    $global:regKeys += @{'path' = "HKLM:\Software\Voxengo\AudioPluginsInstall"; 'key' = "DirVST2_32"; 'value' = "$global:vst2x86BitAware"; 'bit' = 64, 32; 'validpp' = "NoVst2x86" }
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

function CreatePackageParametersObjects () {
  $global:packageArgs = @{
    packageName   = $packageName
    unzipLocation = $unzPath
    fileType      = 'exe'
    url           = $url32
    softwareName  = $softwareName
    checksum      = $checksum32
    checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  }

  if ((Test-Path variable:global:companyPath) -and ($global:companyPath -is [string]) -and ($global:companyPath.Length -gt 0)) {
    $global:packageArgs.silentArgs += " /Dir=`"${global:companyPath}`""
  }

  $global:packageParametersObjectsList = $packageArgs
}
