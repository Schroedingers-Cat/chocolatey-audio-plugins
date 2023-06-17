$ErrorActionPreference = 'Stop';
$osBitness = Get-ProcessorBits
$chocolateyPackageFolder = (Get-EnvironmentVariable -Name 'ChocolateyPackageFolder' -Scope Process)

. $chocolateyPackageFolder\tools\chocolateyfunctions.ps1
. $chocolateyPackageFolder\tools\chocolateyvariables.ps1

#Create the registry and shortcut objects
CreateRegistryFileObjects
CreateRegistryObjects
CreateShortcutObjects
Foreach ($item in $regKeys) { DeleteRegKeyFromObjects($item) }
DeleteDataFromTxtFile($chocolateyPackageFolder + "\uninstall.txt")
