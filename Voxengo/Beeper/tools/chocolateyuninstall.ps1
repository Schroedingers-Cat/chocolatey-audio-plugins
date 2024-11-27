$ErrorActionPreference = 'Stop'

$chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))
. $chocolateyPackageFolder\tools\chocolateyfunctions.ps1
. $chocolateyPackageFolder\tools\chocolateyvariables.ps1
. $chocolateyPackageFolder\tools\helpers-regkey.ps1

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Voxengo Beeper*'
  fileType      = 'EXE'
  validExitCodes= @(0)
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
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

CreateRegistryObjects
Foreach ($item in $regKeys) { DeleteRegKeyFromObjects($item) }
