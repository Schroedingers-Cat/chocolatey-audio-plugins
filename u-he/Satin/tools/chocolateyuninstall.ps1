$ErrorActionPreference = 'Stop';
$osBitness = Get-ProcessorBits
. $env:ChocolateyPackageFolder\tools\chocolateyfunctions.ps1
. $env:ChocolateyPackageFolder\tools\chocolateyvariables.ps1

#Create the registry and shortcut objects
CreateRegistryFileObjects
CreateRegistryObjects
CreateShortcutObjects
Foreach ($item in $regKeys) { DeleteRegKeyFromObjects($item) }
DeleteDataFromTxtFile($env:ChocolateyPackageFolder + "\uninstall.txt")
