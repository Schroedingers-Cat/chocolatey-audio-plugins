$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageName    = 'Beeper'
$company        = 'Voxengo'
$softwareName   = "$company $packageName"
$checksum       = 'd8d1bc9cbdaeffa0e41df038e39bd371a7dbe3c0dcc6d7e7722629f87c817879'
$url            = 'https://www.voxengo.com/files/VoxengoBeeper_213_Win32_64_VST_VST3_AAX_setup.exe'

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
