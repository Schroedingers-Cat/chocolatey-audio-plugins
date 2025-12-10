$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageName    = 'Stereo Touch'
$company        = 'Voxengo'
$softwareName   = "$company $packageName"
$checksum       = 'f0696d846f80b3acc8d46ae1a31010e2a72fc0c949b9c5a4387308f0938b16a1'
$url            = 'https://www.voxengo.com/files/VoxengoStereoTouch_219_Win32_64_VST_VST3_AAX_setup.exe'

# The installer does not have an option for custom data paths but reads defaults from the registry
function Set-RegValue([string]$Key, [string]$Name, [string]$Value) {
    if (-not (Test-Path $Key)) { New-Item -Path $Key -Force | Out-Null }
    New-ItemProperty -Path $Key -Name $Name -Value $Value -PropertyType String -Force | Out-Null
}

$pp = Get-PackageParameters
if (-not [string]::IsNullOrEmpty($pp["VST2x64Path"])) { 
    Set-RegValue "HKLM:\Software\Voxengo\AudioPluginsInstall" "DirVST2_64" $pp["VST2x64Path"]
}
if (-not [string]::IsNullOrEmpty($pp["VST2x86Path"])) { 
    Set-RegValue "HKLM:\Software\Voxengo\AudioPluginsInstall" "DirVST2_32" $pp["VST2x86Path"]
}

$packageArgs = @{
    packageName  = $packageName
    fileType     = 'exe'
    url          = $url
    softwareName = $softwareName
    checksum     = $checksum
    checksumType = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
}

if (-not [string]::IsNullOrEmpty($pp["CompanyPath"])) {
    $companyPath = $pp["CompanyPath"]
    $packageArgs.silentArgs += " /Dir=`"${companyPath}\${packageName}`""
}

Install-ChocolateyPackage @packageArgs
