$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageName    = 'Acoustica 8'
$company        = 'Acon Digital'
$softwareName   = "$company $packageName"
$checksum       = '1BD333C97E85E7FF11C264E630F9EE5DD2677AE0B3821C825AC32E57A3BCD744'
$url            = 'https://downloads.acondigital.com/Acoustica_Win64_8_0_5.exe'

# The installer does not have an option for custom VST2 paths but reads defaults from the registry
function Set-RegValue([string]$Key, [string]$Name, [string]$Value) {
    if (-not (Test-Path $Key)) { New-Item -Path $Key -Force | Out-Null }
    New-ItemProperty -Path $Key -Name $Name -Value $Value -PropertyType String -Force | Out-Null
}

$pp = Get-PackageParameters

# VST2 path via registry (installer reads HKLM:\SOFTWARE\VST\VSTPluginsPath)
if (-not [string]::IsNullOrEmpty($pp["Vst2Path"])) {
    Set-RegValue "HKLM:\SOFTWARE\VST" "VSTPluginsPath" $pp["Vst2Path"]
}

$packageArgs = @{
    packageName  = $packageName
    fileType     = 'exe'
    url          = $url
    softwareName = $softwareName
    checksum     = $checksum
    checksumType = 'sha256'
    silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
}

# Custom install directory (convenience — can also be set via -ia '/Dir=...')
if (-not [string]::IsNullOrEmpty($pp["CompanyPath"])) {
    $packageArgs.silentArgs += " /Dir=`"$($pp["CompanyPath"])\${packageName}`""
}

Install-ChocolateyPackage @packageArgs
