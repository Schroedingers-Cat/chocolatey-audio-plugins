$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = 'https://www.fabfilter.com/downloads/ffprog141x64.exe'
    softwareName   = 'FabFilter Pro-G (x64)*'
    checksumType   = 'sha256'
    checksum       = '9e1263690095d5abb6c090f452d28ee725ef66e4c1b270eb39aab6e9dd6adb30'
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
