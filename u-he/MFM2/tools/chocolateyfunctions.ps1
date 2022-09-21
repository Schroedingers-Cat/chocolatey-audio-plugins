# Installer Functions
# Comments to this script have been added upon request by the chocolatey community reviewer
function CreateShortcut ($shortcutObject) {
  if($shortcutObject.execute -eq $true) {
    $TemporaryWorkaroundFile = $false;
    $tempShortcutPathAndName = "" + $shortcutObject.linkPath + "\" + $shortcutObject.linkName
    If (-not(Test-Path -Path $shortcutObject.destPath)) {
      If ([string]::IsNullOrWhiteSpace([System.IO.Path]::GetExtension($shortcutObject.destPath))) {
        Write-Debug "Target path does not exist and has no file type extension. Assuming a folder. Creating it first."
        New-Item -ItemType Directory -Force -Path $shortcutObject.destPath
      } else {
        New-Item -ItemType File -Force $shortcutObject.destPath
        $TemporaryWorkaroundFile = $true;
      }
    }
    Write-Debug "This is the Shortcut Full Path:"; Write-Debug $tempShortcutPathAndName
    Install-ChocolateyShortcut -ShortcutFilePath $tempShortcutPathAndName -TargetPath $shortcutObject.destPath
    If ($TemporaryWorkaroundFile -eq $true) {
      Write-Debug "Deleting temporary workaround file."
      Remove-Item $shortcutObject.destPath -Force
    }
  }
}

function CreateSymlink ($symlinkObject) {
  if($symlinkObject.execute -eq $true) {
    $tempSymlinkPathAndName = $symlinkObject.linkPath + "\" + $symlinkObject.linkName
    If ($tempSymlinkPathAndName -eq $symlinkObject.destPath) {
      Write-Error ("Target and Destination Paths of an overwritten parameter and an internal parameter are the same.")
      return
    }
    if (Test-Path -Path $symlinkObject.destPath) {
      Write-Debug ("Destination Path " + $symlinkObject.destPath + " already exists.")
    } else {
      Write-Debug ("Creating " + $symlinkObject.destPath)
      New-Item $symlinkObject.destPath -ItemType Directory -Force
    }
    if (Test-Path -Path $tempSymlinkPathAndName) {
      if((Get-Item $tempSymlinkPathAndName).Attributes.ToString() -Match "ReparsePoint") {
        Write-Debug ("Link Path " + $tempSymlinkPathAndName + " already exists as SymbolicLink. Will overwrite SymbolicLink.")
      } else {
        Write-Debug ("Link Path " + $tempSymlinkPathAndName + " already exists. Will move to destination path and link afterwards.")
        If (Test-Path $tempSymlinkPathAndName -pathType leaf) {
          Write-Debug ("Link Path " + $tempSymlinkPathAndName + " is a file.")
          Move-Item -Path $tempSymlinkPathAndName -Destination $symlinkObject.destPath -Force
        } ElseIf (Test-Path $tempSymlinkPathAndName -pathType container) {
          Write-Debug ("Link Path " + $tempSymlinkPathAndName + " is a folder.")
          Move-Item -Path "$tempSymlinkPathAndName\*" -Destination $symlinkObject.destPath -Force
          Remove-Item -Path "$tempSymlinkPathAndName"
        } Else {
          Write-Error ("Link Path " + $tempSymlinkPathAndName + " is neither file nor folder.")
          return
        }
      }
    }
    Write-Debug ("Linking " + $tempSymlinkPathAndName + " to " + $symlinkObject.destPath)
    New-Item -Type SymbolicLink -Path "$tempSymlinkPathAndName" -Value $symlinkObject.destPath -Force
  }
}

function CreateRegKey ($regKeyObject) {
  If ([string]::IsNullOrWhiteSpace($regKeyObject.path)) {
    Write-Warning ("Given Registry Object Path is NULL.")
    return
  }

  if($regKeyObject.execute -eq $true) {
    # Determine value type
    if (${regKeyObject}.value -is [String]) {
      $registryValueType = "String"
      Write-Debug("Registry value type is String.")
    } elseif (${regKeyObject}.value -is [Int32]) {
      $registryValueType = "DWORD"
      Write-Debug("Registry value type is DWORD.")
    } else {
      $registryValueType = "String"
      Write-Warning("Registry value type unknown. Using String as type.")
    }

    # Write reg key
    if($regKeyObject.key -eq '') {
      New-Item -Path ${regKeyObject}.path -Value ${regKeyObject}.value -Force
    } else {
      if (Test-Path ${regKeyObject}.path) { } else { New-Item ${regKeyObject}.path -force }
      New-ItemProperty -PropertyType $registryValueType -Path ${regKeyObject}.path -Name ${regKeyObject}.key -Value ${regKeyObject}.value -force
    }
  }
}

function CreateRegKeyFromFile ($regKeyFileObject) {
  if($regKeyFileObject.execute -eq $true) {
    Write-Debug ("Creating registry entry from file " + $env:ChocolateyPackageFolder + "\" + $regKeyFileObject.path)
    regedit.exe /S ($env:ChocolateyPackageFolder + "\" + $regKeyFileObject.path)
  }
}

<#
.SYNOPSIS
Create the component list that will be parsed to the installer.

.DESCRIPTION
Create the component list that will be parsed to the installer. A component is a tickable box in an installer.
The resulting component list depends on the 'execute' bool that should be set before handing the installer
component into this function.

.PARAMETER instParamObject
An installer parameter object/action defined in the chocolateyvariables.ps1.

.NOTES
Comment added because reviewer asked to do so.
#>
function CreateInstallerParameters ($instParamObject) {
  if($instParamObject.execute -eq $true) {
    Write-Debug "Checking Installer Components for: "; Write-Debug $instParamObject.value
    $global:installerComponents += $instParamObject.value
    $global:installerComponents += ","
    Write-Debug ("These are the current installerComponents: " + $global:installerComponents + ".")
  }
}

function CopyPackageRessources ($PackageResourcePathObject) {
  if($PackageResourcePathObject.execute -eq $true) {
    Write-Debug ("Preparing Package Ressource Path for: " + $PackageResourcePathObject.value + ".")
    $tempPath = ($env:ChocolateyPackageFolder + "\" + ($PackageResourcePathObject.value).ToString())
    if((Test-Path $tempPath) -eq $false) {
      Write-Debug ("The resource object " + $PackageResourcePathObject.value + " does not exist.")
      return
    }
    # We create the target directory first as Copy-Item behaves differently when the target path doesn't exist as directory
    New-Item $PackageResourcePathObject.installPath -ItemType Directory -Force
    if($tempPath -Match "zip") {
      Get-ChocolateyUnzip -FileFullPath "$tempPath" -Destination $PackageResourcePathObject.installPath
    } else {
      Move-Item -Path $tempPath -Destination $PackageResourcePathObject.installPath -Force -Recurse
      Write-Debug ("Copying all files from Package\" + $PackageResourcePathObject.value + " to " + $PackageResourcePathObject.installPath + ".")
    }
  }
}

function CreateTxtFiles ($txtFileObject) {
  if($txtFileObject.execute -eq $true) {
    Write-Debug ("Creating txt file in " + $txtFileObject.key + " with the content: " + $txtFileObject.value)
    Remove-Item $txtFileObject.key -ErrorAction SilentlyContinue
    New-Item $txtFileObject.key -ItemType file -Force
    [System.IO.File]::WriteAllLines($txtFileObject.key, $txtFileObject.value, (New-Object ("System.Text." + $txtFileObject.encoding + "Encoding") $txtFileObject.bom))
  }
}

<#
.SYNOPSIS
Checks for default installer values
#>
function GetDefaultValues () {
  $newDefaultPath = GetDefaultVst2Directory(64)
  If (![string]::IsNullOrWhiteSpace($newDefaultPath)) {
    Write-Debug("Default VST2 64 Path found: " + $newDefaultPath)
    $global:vst2DefaultPath = $newDefaultPath
  }
  $newDefaultPath = GetDefaultVst2Directory(32)
  If (![string]::IsNullOrWhiteSpace($newDefaultPath)) {
    Write-Debug("Default VST2 32 Path found: " + $newDefaultPath)
    $global:vst2x86_64DefaultPath = $newDefaultPath
  }
}
<#
.SYNOPSIS
If default values were found (for instance in the registry) and no overrides have been given, set default installer settings

.DESCRIPTION
If default values were found (for instance in the registry) and no overrides have been given, set default installer settings

#>
function PickDefaultValuesFromSystem () {
  If ([string]::IsNullOrWhiteSpace($pp["Vst2Path"])) {
    If (![string]::IsNullOrWhiteSpace($global:vst2DefaultPath)) {
      Write-Debug("Overwriting VST2 path with value found in registry: " + $vst2DefaultPath)
      $global:vst2Path = $global:vst2DefaultPath
    }
  }

  If ([string]::IsNullOrWhiteSpace($pp["Vst2x86Path"])) {
    If (![string]::IsNullOrWhiteSpace($global:vst2x86_64DefaultPath)) {
      Write-Debug("Overwriting VST2x86 path with value found in registry: " + $global:vst2x86_64DefaultPath)
      $global:vst2x86_64Path = $global:vst2x86_64DefaultPath
    }
  }

  If ($pp["CompanyPath"] -eq $false) {
    # Some installers have an automatic detection mechanism for this path next to a default
    Write-Debug "Checking if automatic install path detection is implemented ..."
    if (Get-Command InstallerCompanyPathAutomaticDetection -errorAction SilentlyContinue) {
      Write-Debug "Method has been implemented!"

      InstallerCompanyPathAutomaticDetection
      If ($autoInstDetectionCompanyPath) {
        Write-Debug("AutoInstDetectionCompanyPath: " + $autoInstDetectionCompanyPath)
        $global:companyPath = $autoInstDetectionCompanyPath
      }
    }
  }
}

<#
.SYNOPSIS
Checks if a given path is a kind of link and returns its value resolved

.DESCRIPTION
Checks if a given path is a kind of link and returns its value resolved. Also returns the path if it's a directory or a file. Returns $null if it doesn't exist.

.NOTES
Comment added because reviewer asked to do so.
#>
function ResolvePath($target) {
  $targetpath = $null

  If (!(Test-Path $target)) {
    Write-Debug ("Ended prematurely")
    Write-Debug ("$targetpath")
    return $targetpath
  }

  if($target.EndsWith(".lnk")) {
    $sh = new-object -com wscript.shell
    $fullpath = resolve-path $target
    $targetpath = $sh.CreateShortcut($fullpath).TargetPath
    Write-Debug ("Target ended with lnk and is " + "$targetpath")
    return $targetpath
  }

  If ((Get-ItemPropertyValue -Path $target -Name LinkType) -eq "SymbolicLink") {
    return $targetpath = Get-ItemPropertyValue -Path $target -Name Target
  } ElseIf (Test-Path $target -pathType leaf) {
    return $targetpath = (Get-Item $target).DirectoryName
  } ElseIf (Test-Path $target -pathType container) {
    return $targetpath = $target
  }

  Write-Debug ($targetpath)
  return $targetpath
}

<#
.SYNOPSIS
Checks if given an array of paths has an entry with a kind of link and returns the first value resolved

.DESCRIPTION
Checks if a given an array of paths it checks for link and returns the first value resolved. Also returns the first path if it's a directory or a file. Returns $null if nothing exists.

.NOTES
Comment added because reviewer asked to do so.
#>
function ResolvePaths([String[]] $Paths) {
  Foreach ($path in $Paths) {
    If (ResolvePath($path)) {
      Write-Debug ("Successfully resolved path " + "$path")
      return ResolvePath($path)
      break
    }
  }
  Write-Debug ("Returning NULL path ")
  return $null
}

<#
.SYNOPSIS
Returns a given registry key/name's value

.DESCRIPTION
Returns a given registry key/name's value

.NOTES
Comment added because reviewer asked to do so.
#>
function ResolveRegPath($reg) {
  If (!(Test-Path -Path $reg.key)) {
    Write-Debug ("Given key is NULL")
    return $null
  }
  $value = Get-ItemProperty -Path $reg.key -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $reg.name -ErrorAction SilentlyContinue
  If ([string]::IsNullOrWhiteSpace($value)) {
    Write-Debug ("Given key's name is NULL")
    return $null
  }

  Write-Debug ("Value found: " + $value)
  return $value
}

<#
.SYNOPSIS
Try to find the default VST2 directory

.DESCRIPTION
Try to find the default VST2 directory

.PARAMETER bitToCheck
Wether to find the default 32 bit or 64 bit directory

.NOTES
Comment added because reviewer asked to do so.
#>
function GetDefaultVst2Directory ($bitToCheck) {
  If ($bitToCheck -eq 32) {
    $defaultRegBasePath = "HKLM:\\SOFTWARE\WOW6432Node\VST"
    $installerDefaultRegPath = $vst2x86_64PathReg
  } ElseIf ($bitToCheck -eq 64) {
    $defaultRegBasePath = "HKLM:\\SOFTWARE\VST"
    $installerDefaultRegPath = $vst2PathReg
  }

  $returnVst2Path = $null

  If (Test-Path -Path $defaultRegBasePath) {
    $newVst2Path = Get-ItemProperty -Path $defaultRegBasePath -ErrorAction SilentlyContinue | Select-Object -ExpandProperty VstPluginsPath -ErrorAction SilentlyContinue
    If (![string]::IsNullOrWhiteSpace($newVst2Path)) {
      If ($vst2AddSubfolder) {
        $newVst2Path += "\$companyPath"
      }
      $returnVst2Path = $newVst2Path
    }
  }

  If (![string]::IsNullOrWhiteSpace($installerDefaultRegPath.key)) {
    $newVst2Path = Get-ItemProperty -Path $installerDefaultRegPath.key -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $installerDefaultRegPath.name -ErrorAction SilentlyContinue
    If (![string]::IsNullOrWhiteSpace($newVst2Path)) {
      $returnVst2Path = $newVst2Path
    }
  }

  return $returnVst2Path
}

function RunInstallerWithPackageParametersObject ($packageParameterObject) {
  $installerPathViaPP = (Test-Path $pp["InstallerPath"])
  ## Does the following check work for 32 bit installers??
  $installerEmbedded = ((Test-Path ($env:ChocolateyPackageFolder + "\" + $packageParameterObject.file)) -And ($packageParameterObject.file64 -ne $null) -And (Test-Path ($env:ChocolateyPackageFolder + "\" + $packageParameterObject.file64)))
  $installerDownload = (($packageParameterObject.url -ne $null) -Or ($packageParameterObject.url64 -ne $null))
  $installerDownloadExe = (($packageParameterObject.url -ne $null) -And ($packageParameterObject.url).EndsWith(".exe"))
  Write-Debug ("This is the InstallerPath Variable: " + $pp["InstallerPath"])

  if($installerPathViaPP -eq $true) {
    Write-Debug "Installer overridden via package parameter"
    $packageParameterObject["file"] = $fileLocation
    Install-ChocolateyInstallPackage @packageParameterObject # https://chocolatey.org/docs/helpers-install-chocolatey-install-package
    return
  }

  if($installerEmbedded -eq $true) {
    Write-Debug "Installer is embedded"
    $packageParameterObject.file = ($env:ChocolateyPackageFolder + "\" + $packageParameterObject.file)
    $packageParameterObject.file64 = ($env:ChocolateyPackageFolder + "\" + $packageParameterObject.file64)
    Write-Debug ("Installer (32 bit referenced) embedded path: " + $packageParameterObject.file)
    Write-Debug ("Installer (64 bit referenced) embedded path: " + $packageParameterObject.file64)
    Install-ChocolateyInstallPackage @packageParameterObject
    return
  }

  if($installerDownload -eq $true -And $installerPathViaPP -eq $false) {
    Write-Debug ("Installer needs to be downloaded from " + $packageParameterObject.url)
    if($installerDownloadExe -eq $true) { 
      Write-Debug "Installer is exe, running now..."
      Install-ChocolateyPackage @packageParameterObject # https://chocolatey.org/docs/helpers-install-chocolatey-package
    } else { 
      Write-Debug "Installer inside zip"
      Write-Debug ("UnzipLocation is: " + $packageParameterObject.unzipLocation)
      $packageParameterObject["file"] = $fileLocation
      Install-ChocolateyZipPackage @packageParameterObject
      Install-ChocolateyInstallPackage @packageParameterObject
    }
    return
  }

  Write-Warning ("No installer found!");
}

function RemoveInstallerObjects ($packageParameterObject) {
  Write-Debug "Starting cleanup of installer files"

  if($packageParameterObject.removePostInstall) {
    ("Entries to remove: " + ($packageParameterObject.removePostInstall | Out-String -stream)) | Write-Debug

    foreach($entry in $packageParameterObject.removePostInstall) {
      $pathToRemove = $env:ChocolateyPackageFolder + "\" + $entry
      Write-Debug "Trying to delete $pathToRemove"
      Write-Debug (Test-Path ($pathToRemove) -ErrorAction Ignore)

      if(Test-Path ($pathToRemove) -ErrorAction Ignore){
        Write-Debug "Deleting $pathToRemove"
        if(Test-Path $pathToRemove -pathType leaf) {
          $directoryName = (Get-Item $pathToRemove).DirectoryName
          Write-Debug "$pathToRemove will be deleted."
          Remove-Item "$pathToRemove" -Force
        }
        if(Test-Path $pathToRemove -pathType container) {
          $parentDirectory = (Get-ItemProperty $pathToRemove).Parent.FullName
          Write-Debug "$pathToRemove will be deleted."
          #Remove-Item "$pathToRemove" -Recurse -Force #fails if folder contains a symlink -.-
          [System.IO.Directory]::Delete("$pathToRemove", $true)
        }
      }
    }
  } else {
    # ATM, keep old behaviour when no removePostInstall variable has been defined
    if($packageParameterObject.file) {
      if(Test-Path ($packageParameterObject.file) -ErrorAction Ignore){
        Remove-Item $packageParameterObject.file -Force -ErrorAction SilentlyContinue
      }
    }
    if($packageParameterObject.file64) {
      if(Test-Path ($packageParameterObject.file64) -ErrorAction Ignore){
        Remove-Item $packageParameterObject.file64 -Force -ErrorAction SilentlyContinue
      }
    }
  }
}

function RemoveTemporaryFiles ($PackageResourcePathObject) {
  Write-Debug ("Deleting temp package files: " + $env:ChocolateyPackageFolder + "\" + $PackageResourcePathObject.value + " and" + $env:ChocolateyPackageFolder + "\" + $PackageResourcePathObject.value + ".txt")
  Remove-Item ($env:ChocolateyPackageFolder + "\" + $PackageResourcePathObject.value) -Force -ErrorAction SilentlyContinue
  Remove-Item ($env:ChocolateyPackageFolder + "\" + $PackageResourcePathObject.value + ".txt") -Force -ErrorAction SilentlyContinue
}

function HandlePackageArgs ($packageParameterObject) {
  if ($global:installerComponents) {
    If ($global:installerComponents.EndsWith(',')) {
      Write-Debug ("Components list ends with , - removing.")
      $global:installerComponents = $global:installerComponents.Substring(0,$global:installerComponents.Length-1)
    }
    $packageParameterObject["silentArgs"] += " /Components=$global:installerComponents"
  }
  Write-Debug "This are the silentArgs"; Write-Debug $packageParameterObject["silentArgs"]
}

# Creates txt file containing all zip files and where they have been copied to.
# Also checks whether extracted zip content should be uninstalled or not (.delete=$false).
function WriteUninstallData ($PackageResourcePathObject) {
  if($PackageResourcePathObject.delete -ne $false) {
    foreach($line in Get-Content ($env:ChocolateyPackageFolder + "\" + $PackageResourcePathObject.value + ".txt")) {
      Add-Content -Path ($env:ChocolateyPackageFolder + "\uninstall.txt") -Value ($PackageResourcePathObject.installPath + "\" + $line)
    }
  }
}

# Creates/Overwrites bit-aware variables, so x86 files can use the same path-var on both platforms
function CreateBitAwareVariables () {
  if($osBitness -eq 64) {
    $global:vst2x86BitAware = "$vst2x86_64Path"
    $global:vst3x86BitAware = "$vst3x86_64Path"
    $global:aaxx86BitAware  = "$aaxx86_64Path"
    $global:vst2x86PathRegBitAware = "$vst2x86_64PathReg"
    $global:rtasBitaware = "${env:COMMONPROGRAMFILES(x86)}\Digidesign\DAE\Plug-Ins"
  }
  if($osBitness -eq 32) {
    $global:vst2x86BitAware = "$vst2Path"
    $global:vst3x86BitAware = "$vst3Path"
    $global:aaxx86BitAware  = "$aaxPath"
    $global:vst2x86PathRegBitAware = "$vst2PathReg"
    $global:rtasBitaware = "${env:COMMONPROGRAMFILES}\Digidesign\DAE\Plug-Ins"
  }
}

# Uninstaller Functions
function Test-Registry ($path, $value) {
  try {
    Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
    return $true
  } catch {
    return $false
  }
}

function DeleteFolders ($folderPath) {
  if([string]::IsNullOrWhiteSpace($folderPath)) {
    Write-Debug "Path variable is null."
    return
  }
  if(Test-Path -path "$folderPath") {
    Write-Debug "$folderPath will be deleted."
    # "Archive" seems to be a lnk file
    if((Get-Item ($folderPath).ToString()).Attributes.ToString() -Match "Archive" ) {
      Remove-Item $folderPath -Force -Recurse
    } else {
      [System.IO.Directory]::Delete("$folderPath", $true)
    }
  }
}

# Checks, if a folder is empty and if true, deletes that folder. Also checks three levels upwards. -Force is not necessary.
function DeleteFoldersIfEmpty ($folderPath) {
  Write-Debug ("Checking " + $folderPath)
  if([string]::IsNullOrWhiteSpace($folderPath)) {
    Write-Debug "Path variable is null."
    return
  }
  if((Test-Path -Path "$folderPath") -eq $false) {
    Write-Debug "$folderPath does not exist."
    return
  }
  $parentFolder = (Get-ItemProperty $folderPath).Parent.FullName
  $parentParentFolder = (Get-ItemProperty $folderPath).Parent.Parent.FullName
  $folderList = "$folderPath", "$parentFolder", "$parentParentFolder"
  Foreach ($path in $folderList) {
    Write-Debug ("Checking if path exists and is empty: " + $path)
    if($path -ne '' -and $path -ne $null) {
      if(((Test-Path "$path") -and (Get-ChildItem "$path") -eq $null)) {
        Write-Debug "$path is empty and will be deleted."
        Remove-Item "$path"
      }
    }
  }
}

function DeleteDataFromTxtFile ($uninstallFile) {
  Foreach($path in Get-Content $uninstallFile) {
    If ([string]::IsNullOrWhiteSpace($path)) {
      return
    }
    Write-Debug ("About to delete " + $path)
    if(Test-Path $path -pathType leaf) {
      $directoryName = (Get-Item $path).DirectoryName
      Write-Debug "$path will be deleted."
      Remove-Item "$path" -Force
      DeleteFoldersIfEmpty($directoryName)
    }
    if(Test-Path $path -pathType container) {
      $parentDirectory = (Get-ItemProperty $path).Parent.FullName
      Write-Debug "$path will be deleted."
      #Remove-Item -Recurse -Force fails if folder contains a symlink -.-
      [System.IO.Directory]::Delete("$path", $true)
      DeleteFoldersIfEmpty($parentDirectory)
    }
  }
}

# Removes all registry entires in a given registry file from the registry
function DeleteRegKeysFromFile ($file) {
  if(Test-Path $file) {
    (Get-Content $file) -replace "^\[","[-" | out-file $file
    regedit.exe /S ($file)
  }
}

# Deletes a registry key or property, if it exists and is not marked as delete=$false
function DeleteRegKeyFromObjects ($regKey) {
  Write-Debug ("About to delete Registry Entry: " + $regKey.path + $regKey.key)
  if($regKey.ContainsKey("delete")) {
    return
  }
  If ([string]::IsNullOrWhiteSpace($regKey.path)) {
    Write-Debug("Given Registry Path is null or empty.")
    return
  }
  if((Test-Path -Path $regKey.path) -eq $false) {
    Write-Debug ("Registry Entry does not exist anymore.")
    return
  }
  if(($regKey.key -eq "")) {
    Write-Debug ("Deleting " + $regKey.path)
    Remove-Item -Path $regKey.path -Force
    return
  }
  if ($regKey.key -ne "") {
    Write-Debug ("Deleting Key " + $regKey.key + " at Path " + $regKey.path)
    Remove-ItemProperty -Path $regKey.path -Name $regKey.key -Force -ErrorAction SilentlyContinue
    return
  }

  If (([string]::IsNullOrWhiteSpace((Get-Item -Path $regKey.path | Get-ItemProperty))) -And ([string]::IsNullOrWhiteSpace((Get-ChildItem -Path $regKey.path)))) {
    Write-Debug ("Deleting orphaned key " + $regKey.path)
    Remove-Item -Path $regKey.path
    return
  }
}

# Deletes a file, if it exists
function DeleteFile ($pathToFile) {
  Write-Debug ("Checking " + $pathToFile)
  if(Test-Path $pathToFile) {
    Write-Debug ("Deleting " + $pathToFile)
    Remove-Item $pathToFile -Force
  }
}

# Packaging functions
function CreateFileList ($packagePaths, $targetPath) {
  Remove-Item ($targetPath + ".txt") -ErrorAction SilentlyContinue
  Foreach ($path in $packagePaths) {
    #Add-Content -Path ($targetPath + ".txt") -Value (Get-ChildItem -Path "$path" -Recurse -Name) -Force
    Add-Content -Path ($targetPath + ".txt") -Value ((Get-Item -Path "$path").Name) -Force
  }
}
function CreateDataArchive ($packagePaths, $targetPath) {
  # This cmdlet does not include hidden files/folders https://github.com/PowerShell/Microsoft.PowerShell.Archive/issues/66
  Compress-Archive $packagePaths $targetPath -CompressionLevel Optimal -Force
}

function CreateDataArchiveAndFileList ($packagePaths, $targetPath) {
  if ((Test-Path $targetPath) -eq $false ) {
    New-Item $targetPath -Force
    Remove-Item $targetPath -Force
  }
  CreateDataArchive $packagePaths $targetPath
  CreateFileList $packagePaths $targetPath
}

<#
.SYNOPSIS
Reduces the nupkg package file by deleting big binaries from the file.

.DESCRIPTION
  Reduces the nupkg package file by deleting all files from the .nupkg file that are not necessary anymore like installer files or 7z binaries.
  It keeps the following files and folders:
  /package/
  /tools/
  _rels
  *.nuspec
  [Content_Types].xml

  The rest will be removed from the nupkg file.

.NOTES
Comment added because reviewer asked to do so.
#>
#
function ReducePackageSize () {
  .$env:ChocolateyInstall\tools\7z.exe d ($env:ChocolateyPackageFolder + "\" + $env:ChocolateyPackageName + ".nupkg")  * -r  -xr!package -xr!tools -xr!_rels -x!"*.nuspec" -x!"[Content_Types].xml" | out-null
}
<#
.SYNOPSIS
Which installation steps are actually necessary for the given OS and package parameters?

.DESCRIPTION
Checks the current OS bitness and the given package parameters and marks all steps from the chocolateyvariables file to be actually executed by setting their 'execute' bit.

.PARAMETER objectsList
A list of objects with a 'validpp' key and a 'bit' key from the chocolateyvariables.ps1 file.

.NOTES
Comment added because reviewer asked to do so.
#>

function DetermineExecutionOfAllObjects ($objectsList) {
  Foreach($object in $objectsList) {
    $object.Add('execute', $false)
    $bitStatus = ($object.bit -eq $null) -Or ($object.bit -Contains $osBitness)
    $ppIndependent = (($object.validpp -eq $null) -Or ($object.validpp -Like "Always"))
    Write-Debug ("ppindependent: " + $ppIndependent)
    Write-Debug ("bitStatus: " + $bitStatus)

    Foreach($packageParameter in $object.validpp) {
      Write-Debug ("Status of evaluated package parameter:" + $packageParameter)
      if((Test-Path variable:pp.packageParameter) -eq $true) {
        Write-Debug $pp[$packageParameter]
        Write-Debug ($pp[$packageParameter] -eq $false)
      }
      if(($pp[$packageParameter] -eq $false) -And $bitStatus) {
        $object.execute = $true
      }
    }

    if($ppIndependent -And $bitStatus) {
      $object.execute = $true
    }

    If ($object.ContainsKey("dropIfNull")) {
      Write-Debug ("Object $object contains a dropIfNull!")

      Foreach ($variableToCheck in $object.dropIfNull) {
        If ([string]::IsNullOrWhiteSpace($variableToCheck)) {
          Write-Debug ("Dependent variable is NULL")
          $object.execute = $false
        } else {
          Write-Debug ("Dependent variable is $variableToCheck")
        }
      }
    }
  }
}

<#
.SYNOPSIS
Create the protocol file for the uninstallation

.DESCRIPTION
Writes a list of files that have been extracted from zip files embedded in this package. Is empty if no zip files have been embedded.

.NOTES
Comment added because reviewer asked to do so.
#>
function CreateUninstallFile () {
  # Create empty uninstall file
  Out-File -FilePath ($env:ChocolateyPackageFolder + "\uninstall.txt")
}
