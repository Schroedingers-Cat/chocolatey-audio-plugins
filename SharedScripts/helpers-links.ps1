# Helper functions for managing symbolic links and shortcuts

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
  