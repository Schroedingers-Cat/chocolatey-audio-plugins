$ErrorActionPreference = 'Stop'

$chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))

$UninstallerSuffix = '4.02 (32-bit)'
$TemplateVariable = '[[' + 'UninstallerSuffix' + ']]'
if ($UninstallerSuffix -eq $TemplateVariable) {
  $UninstallerSuffix = ""
} else {
  $UninstallerSuffix = " $UninstallerSuffix"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = "FabFilter Pro-Q" + $UninstallerSuffix
  fileType      = 'EXE'
  validExitCodes= @(0)
  silentArgs   = '/Unattended'
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % {
    $packageArgs['file'] = "$($_.UninstallString)"
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}
