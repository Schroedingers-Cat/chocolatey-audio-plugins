# Comments to this script have been added upon request by the chocolatey community reviewer
$ErrorActionPreference = 'Stop';
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzPath = "${env:TEMP}"
$osBitness = Get-ProcessorBits
if(Test-Path Env:\ChocolateyPackageFolder) {
  . $env:ChocolateyPackageFolder\tools\chocolateyfunctions.ps1
  . $env:ChocolateyPackageFolder\tools\chocolateyvariables.ps1
} else {
  . ((Get-Item -Path ".\" -Verbose).FullName + "\tools\chocolateyfunctions.ps1")
  . ((Get-Item -Path ".\" -Verbose).FullName + "\tools\chocolateyvariables.ps1")
}

# Check for any settings from previous installations of this package
CheckPreviousInstallerSettings
# Get default values that may or may not be already on the machein
GetDefaultValues

$pp = Get-PackageParameters
# Audio plugins can come in various formats for multiple platforms, all contained in one single installer with different control schemes at the CLI (if available).
# With the package parameters below it is possible for the user to have a single unified interface for all audio plugin packages I create.
# If the package parameter is set here and an equivalent installation action is found in the chocovariables.ps1 with the 'validpp' key being equal to the
# package parameter, the default behaviour of the package/installer can be changed.
# Not all possible package parameters here actually do something as this depends on the specific package/software vendor. If a package parameter either does
# not exist below or does not exist in a 'validpp'-key in the chocolateyvariables.ps1, it will be ignored and have no effect.
if ($pp["NoVst2x86"]      -eq $null -or $pp["NoVst2x86"] -eq '')     { $pp["NoVst2x86"] = $false }
if ($pp["NoVst2x64"]      -eq $null -or $pp["NoVst2x64"] -eq '')     { if($osBitness -eq 64) { $pp["NoVst2x64"] = $false }}
if ($pp["NoVst3x86"]      -eq $null -or $pp["NoVst3x86"] -eq '')     { $pp["NoVst3x86"] = $false }
if ($pp["NoVst3x64"]      -eq $null -or $pp["NoVst3x64"] -eq '')     { if($osBitness -eq 64) { $pp["NoVst3x64"] = $false }}
if ($pp["NoAaxx86"]       -eq $null -or $pp["NoAaxx86"] -eq '')      { $pp["NoAaxx86"] = $false }
if ($pp["NoAaxx64"]       -eq $null -or $pp["NoAaxx64"] -eq '')      { if($osBitness -eq 64) { $pp["NoAaxx64"] = $false }}
if ($pp["NoRtas"]         -eq $null -or $pp["NoRtas"] -eq '')        { $pp["NoRtas"] = $false }
if ($pp["NoPresets"]      -eq $null -or $pp["NoPresets"] -eq '')     { $pp["NoPresets"] = $false }
if ($pp["NoNks"]          -eq $null -or $pp["NoNks"] -eq '')         { $pp["NoNks"] = $false }
if ($pp["NoUserFolder"]   -eq $null -or $pp["NoUserFolder"] -eq '')  { $pp["NoUserFolder"] = $false }
if ($pp["NoShortcuts"]    -eq $null -or $pp["NoShortcuts"] -eq '')   { $pp["NoShortcuts"] = $false }
if ($pp["InstallerPath"]  -eq $null -or $pp["InstallerPath"] -eq '') { $fileLocation = "$unzPath\$unzInstPath"; $pp["InstallerPath"]=$false } else { $fileLocation = $pp["InstallerPath"] }
if ($pp["CompanyPath"]    -eq $null -or $pp["CompanyPath"] -eq '')   { $pp["CompanyPath"] = $false }                                          else { $standardCompanyPath=$global:companyPath; $global:companyPath = $pp["CompanyPath"] }
if ($pp["LibraryPath"]    -eq $null -or $pp["LibraryPath"] -eq '')   { $pp["LibraryPath"] = $false }                                          else { $libraryPath = $pp["LibraryPath"] }
if ($pp["UserFolderPath"] -eq $null -or $pp["UserFolderPath"] -eq ''){ }                                                                      else { $userFolderPath = $pp["UserFolderPath"]}
if ($pp["Vst2Path"]       -eq $null -or $pp["Vst2Path"] -eq '')      { }                                                                      else { $global:vst2Path = $pp["Vst2Path"] }
if ($pp["Vst2x86Path"]    -eq $null -or $pp["Vst2x86Path"] -eq '')   { }                                                                      else { $global:vst2x86_64Path = $pp["Vst2x86Path"] }
if ($pp["Vst3Path"]       -eq $null -or $pp["Vst3Path"] -eq '')      { }                                                                      else { $vst3Path = $pp["Vst3Path"] }
if ($pp["Vst3x86Path"]    -eq $null -or $pp["Vst3x86Path"] -eq '')   { }                                                                      else { $vst3x86_64Path = $pp["Vst3x86Path"] }

# Create/Overwrite bit-aware variables. These variables are used to access different paths across different OS bitnesses in a uniform way.
CreateBitAwareVariables

# Create all the necessary information for the setup after package parameters changed the packages default values.
# This includes registry keys to write, shortcuts to create or additional installer parameters to parse.

# Begin with handling the components of the installer so the settings can be written to registry afterwards
CreateInstallerObjects
CreatePackageParametersObjects
DetermineExecutionOfAllObjects($installerComponentsList)
Foreach ($item in $installerComponentsList)  { CreateInstallerParameters($item) }

# Now that previous settings have been gathered, the package parameters have been evaluated
# as well as the installer components, it's time to determine which settings will be used
#  during installation
CheckPreviousInstallerSettingsAgainstParameters

# Decision to use previous values or package parameters have been made. Whatever it is, finalize and append to installer call.
Foreach ($item in $packageParametersObjectsList) { HandlePackageArgs($item)     }

# Installer components are now fully evaluated and can be written to registry in case some installers don't save these settings on their own (needed for upgrades)
CreateRegistryObjects
CreateRegistryFileObjects
CreateShortcutObjects
CreateSymlinkObjects
CreatePackageRessourcePathObjects
CreateTxtFileObjects

# These functions are necessary for embedded installer and other embedded files, only. Nothing actually happens if
# this package doesn't include something in the 'bin' folder.
ReducePackageSize
CreateUninstallFile

# For each possible install action defined in chocolateyvariables.ps1 that can be customized via package parameter or depends on the OS bitness,
# it is determined if it is ultimately executed or not. Up until here including all DetermineExecutionOfAllObjects calls, nothing has actually
# happened on the system.
$objectsLists = $regKeys, $regKeyFileObjects, $shortcuts, $symlinks, $PackageRessourcePathList, $PackageNewFiles
Foreach($objectsList in $objectsLists) { DetermineExecutionOfAllObjects($objectsList) }

# Each possible install action defined in chocolateyvariables.ps1 with the execute-bit set to true is being executed by each corresponding function.
Foreach ($item in $regKeys)                  { CreateRegKey($item)              }
Foreach ($item in $regKeyFileObjects)        { CreateRegKeyFromFile($item)      }
Foreach ($item in $shortcuts)                { CreateShortcut($item)         }
Foreach ($item in $symlinks)                 { CreateSymlink ($item)         }
Foreach ($item in $PackageRessourcePathList) { CopyPackageRessources($item)     }
Foreach ($item in $PackageRessourcePathList) { WriteUninstallData($item)        }
Foreach ($item in $PackageRessourcePathList) { RemoveTemporaryFiles($item)      }
Foreach ($item in $PackageNewFiles)          { CreateTxtFiles($item)            }
Foreach ($item in $packageParametersObjectsList) { RunInstallerWithPackageParametersObject($item) }
Foreach ($item in $packageParametersObjectsList) { RemoveInstallerObjects($item) }
