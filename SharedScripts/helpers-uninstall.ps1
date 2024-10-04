# Uninstaller Functions

function Test-Registry ($path, $value) {
    try {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function DeleteFolders ($folderPath) {
    if ([string]::IsNullOrWhiteSpace($folderPath)) {
        Write-Debug "Path variable is null."
        return
    }
    if (Test-Path -path "$folderPath") {
        Write-Debug "$folderPath will be deleted."
        # "Archive" seems to be a lnk file
        if ((Get-Item ($folderPath).ToString()).Attributes.ToString() -Match "Archive" ) {
            Remove-Item $folderPath -Force -Recurse
        }
        else {
            [System.IO.Directory]::Delete("$folderPath", $true)
        }
    }
}

# Deletes a file, if it exists
function DeleteFile ($pathToFile) {
    Write-Debug ("Checking " + $pathToFile)
    if (Test-Path $pathToFile) {
        Write-Debug ("Deleting " + $pathToFile)
        Remove-Item $pathToFile -Force
    }
}

# Checks, if a folder is empty and if true, deletes that folder. Also checks three levels upwards. -Force is not necessary.
function DeleteFoldersIfEmpty ($folderPath) {
    Write-Debug ("Checking " + $folderPath)
    if ([string]::IsNullOrWhiteSpace($folderPath)) {
        Write-Debug "Path variable is null."
        return
    }
    if ((Test-Path -Path "$folderPath") -eq $false) {
        Write-Debug "$folderPath does not exist."
        return
    }
    $parentFolder = (Get-ItemProperty $folderPath).Parent.FullName
    $parentParentFolder = (Get-ItemProperty $folderPath).Parent.Parent.FullName
    $folderList = "$folderPath", "$parentFolder", "$parentParentFolder"
    Foreach ($path in $folderList) {
        Write-Debug ("Checking if path exists and is empty: " + $path)
        if ($path -ne '' -and $path -ne $null) {
            if (((Test-Path "$path") -and (Get-ChildItem "$path") -eq $null)) {
                Write-Debug "$path is empty and will be deleted."
                Remove-Item "$path"
            }
        }
    }
}

function DeleteDataFromTxtFile ($uninstallFile) {
    Foreach ($path in Get-Content $uninstallFile) {
        If ([string]::IsNullOrWhiteSpace($path)) {
            return
        }
        Write-Debug ("About to delete " + $path)
        if (Test-Path $path -pathType leaf) {
            $directoryName = (Get-Item $path).DirectoryName
            Write-Debug "$path will be deleted."
            Remove-Item "$path" -Force
            DeleteFoldersIfEmpty($directoryName)
        }
        if (Test-Path $path -pathType container) {
            $parentDirectory = (Get-ItemProperty $path).Parent.FullName
            Write-Debug "$path will be deleted."
            #Remove-Item -Recurse -Force fails if folder contains a symlink -.-
            [System.IO.Directory]::Delete("$path", $true)
            DeleteFoldersIfEmpty($parentDirectory)
        }
    }
}
