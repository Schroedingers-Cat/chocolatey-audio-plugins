$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffproc301.exe'
    softwareName   = 'FabFilter Pro-C 3 (x86)*'
    checksumType   = 'sha256'
    checksum       = '953e1ae3758495e89762b1d305580e9cd61962a543f2dbd84a37c56e1bcfcbaf'
    silentArgs     = '/Unattended' # FabFilter Installer
    validExitCodes = @(0)
}

# FabFilter installers support customizing VST2 path via registry key
$registryPath  = 'HKCU:\Software\FabFilter'
$paths = @{
    "x64" = "VstPluginsPath64"
    "x86" = "VstPluginsPath32"
}
$registryValue = $paths["x86"]

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
