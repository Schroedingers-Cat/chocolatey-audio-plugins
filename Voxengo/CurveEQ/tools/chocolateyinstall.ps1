$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageName    = 'CurveEQ'
$company        = 'Voxengo'
$softwareName   = "$company $packageName"
$checksum       = '2c38a32012c6b3e39aa0ee694c5901541b2650c2471ae8328184e4e658fe5539'
$url            = 'https://www.voxengo.com/files/VoxengoCurveEQ_316_Win32_64_VST_VST3_AAX_setup.exe'

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
