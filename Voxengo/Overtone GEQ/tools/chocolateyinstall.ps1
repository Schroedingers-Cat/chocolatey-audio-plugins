$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageName    = 'Overtone GEQ'
$company        = 'Voxengo'
$softwareName   = "$company $packageName"
$checksum       = 'e6181c8e0abda07eae3e4357c21a1692ddb7f7cc2191282261fb91fdb5d75412'
$url            = 'https://www.voxengo.com/files/VoxengoOvertoneGEQ_118_Win32_64_VST_VST3_AAX_setup.exe'

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
