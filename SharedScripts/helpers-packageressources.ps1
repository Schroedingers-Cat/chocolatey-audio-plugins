# Helper functions for handling installing from zip archives

function CopyPackageRessources ($PackageResourcePathObject) {
    if ($PackageResourcePathObject.execute -eq $true) {
        Write-Debug ("Preparing Package Ressource Path for: " + $PackageResourcePathObject.value + ".")
        $chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))
        $tempPath = ($chocolateyPackageFolder + "\" + ($PackageResourcePathObject.value).ToString())
        if ((Test-Path $tempPath) -eq $false) {
            Write-Debug ("The resource object " + $PackageResourcePathObject.value + " does not exist.")
            return
        }
        # We create the target directory first as Copy-Item behaves differently when the target path doesn't exist as directory
        New-Item $PackageResourcePathObject.installPath -ItemType Directory -Force
        if ($tempPath -Match "zip") {
            Get-ChocolateyUnzip -FileFullPath "$tempPath" -Destination $PackageResourcePathObject.installPath
        }
        else {
            Move-Item -Path $tempPath -Destination $PackageResourcePathObject.installPath -Force -Recurse
            Write-Debug ("Copying all files from Package\" + $PackageResourcePathObject.value + " to " + $PackageResourcePathObject.installPath + ".")
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
    $chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))
    
    # Create empty uninstall file
    Out-File -FilePath ($chocolateyPackageFolder + "\uninstall.txt")
}

# Creates txt file containing all zip files and where they have been copied to.
# Also checks whether extracted zip content should be uninstalled or not (.delete=$false).
function WriteUninstallData ($PackageResourcePathObject) {
    if ($PackageResourcePathObject.delete -ne $false) {
        $chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))
  
        foreach ($line in Get-Content ($chocolateyPackageFolder + "\" + $PackageResourcePathObject.value + ".txt")) {
            Add-Content -Path ($chocolateyPackageFolder + "\uninstall.txt") -Value ($PackageResourcePathObject.installPath + "\" + $line)
        }
    }
}

function RemoveTemporaryFiles ($PackageResourcePathObject) {
    $chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))
    Write-Debug ("Deleting temp package files: " + $chocolateyPackageFolder + "\" + $PackageResourcePathObject.value + " and" + $chocolateyPackageFolder + "\" + $PackageResourcePathObject.value + ".txt")
    Remove-Item ($chocolateyPackageFolder + "\" + $PackageResourcePathObject.value) -Force -ErrorAction SilentlyContinue
    Remove-Item ($chocolateyPackageFolder + "\" + $PackageResourcePathObject.value + ".txt") -Force -ErrorAction SilentlyContinue
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
    $chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))
  
    .$env:ChocolateyInstall\tools\7z.exe d ($chocolateyPackageFolder + "\" + $env:ChocolateyPackageName + ".nupkg")  * -r  -xr!package -xr!tools -xr!_rels -x!"*.nuspec" -x!"[Content_Types].xml" | out-null
}
