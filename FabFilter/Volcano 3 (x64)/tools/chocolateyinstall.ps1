﻿$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffvolcano307x64.exe'
    softwareName   = 'FabFilter Volcano 3 (x64)*'
    checksumType   = 'sha256'
    checksum       = '2564b65a0549fc2bb0d331cc9d0359f2082bbb3e591a8202817855bcd3575abb'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

# FabFilter installers support customizing VST2 path via registry key
$registryPath  = 'HKCU:\Software\FabFilter'
$paths = @{
    "x64" = "VstPluginsPath64"
    "x86" = "VstPluginsPath32"
}
$registryValue = $paths["x64"]

$pp = Get-PackageParameters
$vst2Path = $pp['Vst2Path']

if (($vst2Path) -And (Test-Path -Path $pp['Vst2Path'] -IsValid)) {
    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath | Out-Null
    }
    Set-ItemProperty -Path $registryPath -Name $registryValue -Value $pp['Vst2Path'] -Type String -Force
}
elseif ((Test-Path $registryPath) -And ((Get-ItemProperty -Path $registryPath).PSObject.Properties.Name -contains $registryValue)) {
    Remove-ItemProperty -Path $registryPath -Name $registryValue -Force
}

Install-ChocolateyPackage @packageArgs
