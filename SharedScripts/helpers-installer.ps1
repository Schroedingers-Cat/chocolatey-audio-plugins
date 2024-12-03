# Helper functions for managing installer

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
#>
function CreateInstallerParameters ($instParamObject) {
    if ($instParamObject.execute -eq $true) {
        Write-Debug "Checking Installer Components for: "; Write-Debug $instParamObject.value
        $global:installerComponents += $instParamObject.value
        $global:installerComponents += ","
        Write-Debug ("These are the current installerComponents: " + $global:installerComponents + ".")
    }
}


# This name is too generic, it actually handles the components argument of installers
function HandlePackageArgs ($packageParameterObject) {
    if ($global:installerComponents) {
        If ($global:installerComponents.EndsWith(',')) {
            Write-Debug ("Components list ends with , - removing.")
            $global:installerComponents = $global:installerComponents.Substring(0, $global:installerComponents.Length - 1)
        }
        $packageParameterObject["silentArgs"] += " /Components=$global:installerComponents"
    }
    Write-Debug "These are the silentArgs"; Write-Debug $packageParameterObject["silentArgs"]
}

function RunInstallerWithPackageParametersObject ($packageParameterObject) {
    $installerPathViaPP = (Test-Path $pp["InstallerPath"])
    $chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))
    $installerEmbedded = ((Test-Path ($chocolateyPackageFolder + "\" + $packageParameterObject.file)) -And ($packageParameterObject.file64 -ne $null) -And (Test-Path ($chocolateyPackageFolder + "\" + $packageParameterObject.file64)))
    $installerDownload = (($packageParameterObject.url -ne $null) -Or ($packageParameterObject.url64 -ne $null))
    $installerDownloadExe = (($packageParameterObject.url -ne $null) -And ($packageParameterObject.url).EndsWith(".exe"))
    Write-Debug ("This is the InstallerPath Variable: " + $pp["InstallerPath"])
  
    if ($installerPathViaPP -eq $true) {
        Write-Debug "Installer overridden via package parameter"
        $packageParameterObject["file"] = $fileLocation
        Install-ChocolateyInstallPackage @packageParameterObject
        return
    }
  
    if ($installerEmbedded -eq $true) {
        Write-Debug "Installer is embedded"
        $packageParameterObject.file = ($chocolateyPackageFolder + "\" + $packageParameterObject.file)
        $packageParameterObject.file64 = ($chocolateyPackageFolder + "\" + $packageParameterObject.file64)
        Write-Debug ("Installer (32 bit referenced) embedded path: " + $packageParameterObject.file)
        Write-Debug ("Installer (64 bit referenced) embedded path: " + $packageParameterObject.file64)
        Install-ChocolateyInstallPackage @packageParameterObject
        return
    }
  
    if ($installerDownload -eq $true -And $installerPathViaPP -eq $false) {
        Write-Debug ("Installer needs to be downloaded from " + $packageParameterObject.url)
        if ($installerDownloadExe -eq $true) { 
            Write-Debug "Installer is exe, running now..."
            try {
                Install-ChocolateyPackage @packageParameterObject
            }
            catch {
                Write-Host "Error running installer: " $_.Exception.Message
                if($packageParameterObject.ContainsKey('urlAlternative')) {
                    $packageParameterObject.url = $packageParameterObject.urlAlternative
                    Write-Host "Package contains alternative URL. Trying that."
                    Install-ChocolateyPackage @packageParameterObject
                } else {
                    throw $_
                }
            }
        }
        else { 
            Write-Debug "Installer inside zip"
            Write-Debug ("UnzipLocation is: " + $packageParameterObject.unzipLocation)
            $packageParameterObject["file"] = $fileLocation
            try {
                Install-ChocolateyZipPackage @packageParameterObject
            }
            catch {
                Write-Host "Error while downloading and unziping: " $_.Exception.Message
                if($_.Exception.Message -like "*404*" -and $packageParameterObject.ContainsKey('urlAlternative')) {
                    $packageParameterObject.url = $packageParameterObject.urlAlternative
                    Write-Host "Package contains alternative URL. Trying that."
                    Install-ChocolateyZipPackage @packageParameterObject
                } else {
                    throw $_
                }
            }

            Install-ChocolateyInstallPackage @packageParameterObject
        }
        return
    }
  
    Write-Warning ("No installer found!");
}

function RemoveInstallerObjects ($packageParameterObject) {
    Write-Debug "Starting cleanup of installer files"
  
    if ($packageParameterObject.removePostInstall) {
      ("Entries to remove: " + ($packageParameterObject.removePostInstall | Out-String -stream)) | Write-Debug
  
        foreach ($entry in $packageParameterObject.removePostInstall) {
            $chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))
            $pathToRemove = $chocolateyPackageFolder + "\" + $entry
            Write-Debug "Trying to delete $pathToRemove"
            Write-Debug (Test-Path ($pathToRemove) -ErrorAction Ignore)
  
            if (Test-Path ($pathToRemove) -ErrorAction Ignore) {
                Write-Debug "Deleting $pathToRemove"
                if (Test-Path $pathToRemove -pathType leaf) {
                    $directoryName = (Get-Item $pathToRemove).DirectoryName
                    Write-Debug "$pathToRemove will be deleted."
                    Remove-Item "$pathToRemove" -Force
                }
                if (Test-Path $pathToRemove -pathType container) {
                    $parentDirectory = (Get-ItemProperty $pathToRemove).Parent.FullName
                    Write-Debug "$pathToRemove will be deleted."
                    #Remove-Item "$pathToRemove" -Recurse -Force #fails if folder contains a symlink -.-
                    [System.IO.Directory]::Delete("$pathToRemove", $true)
                }
            }
        }
    }
    else {
        # ATM, keep old behaviour when no removePostInstall variable has been defined
        if ($packageParameterObject.file) {
            if (Test-Path ($packageParameterObject.file) -ErrorAction Ignore) {
                Remove-Item $packageParameterObject.file -Force -ErrorAction SilentlyContinue
            }
        }
        if ($packageParameterObject.file64) {
            if (Test-Path ($packageParameterObject.file64) -ErrorAction Ignore) {
                Remove-Item $packageParameterObject.file64 -Force -ErrorAction SilentlyContinue
            }
        }
    }
}
