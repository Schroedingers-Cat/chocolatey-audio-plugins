# Helper functions for managing registry keys

function CreateRegKey ($regKeyObject) {
    If ([string]::IsNullOrWhiteSpace($regKeyObject.path)) {
        Write-Warning ("Given Registry Object Path is NULL.")
        return
    }
  
    if ($regKeyObject.execute -eq $true) {
        # Determine value type
        if (${regKeyObject}.value -is [String]) {
            $registryValueType = "String"
            Write-Debug("Registry value type is String.")
        }
        elseif (${regKeyObject}.value -is [Int32]) {
            $registryValueType = "DWORD"
            Write-Debug("Registry value type is DWORD.")
        }
        else {
            $registryValueType = "String"
            Write-Warning("Registry value type unknown. Using String as type.")
        }
  
        # Write reg key
        if ($regKeyObject.key -eq '') {
            New-Item -Path ${regKeyObject}.path -Value ${regKeyObject}.value -Force
        }
        else {
            if (Test-Path ${regKeyObject}.path) { } else { New-Item ${regKeyObject}.path -force }
            New-ItemProperty -PropertyType $registryValueType -Path ${regKeyObject}.path -Name ${regKeyObject}.key -Value ${regKeyObject}.value -force
        }
    }
}
  
function CreateRegKeyFromFile ($regKeyFileObject) {
    if ($regKeyFileObject.execute -eq $true) {
        $chocolateyPackageFolder = ($(Get-ChocolateyPath -PathType 'PackagePath'))
        Write-Debug ("Creating registry entry from file " + $chocolateyPackageFolder + "\" + $regKeyFileObject.path)
        regedit.exe /S ($chocolateyPackageFolder + "\" + $regKeyFileObject.path)
    }
}
  
# Removes all registry entires in a given registry file from the registry
function DeleteRegKeysFromFile ($file) {
    if (Test-Path $file) {
      (Get-Content $file) -replace "^\[", "[-" | out-file $file
        regedit.exe /S ($file)
    }
}
  
# Deletes a registry key or property, if it exists and is not marked as delete=$false
function DeleteRegKeyFromObjects ($regKey) {
    Write-Debug ("About to delete Registry Entry: " + $regKey.path + $regKey.key)
    if ($regKey.ContainsKey("delete")) {
        return
    }
    If ([string]::IsNullOrWhiteSpace($regKey.path)) {
        Write-Debug("Given Registry Path is null or empty.")
        return
    }
    if ((Test-Path -Path $regKey.path) -eq $false) {
        Write-Debug ("Registry Entry does not exist anymore.")
        return
    }
    if (($regKey.key -eq "")) {
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
