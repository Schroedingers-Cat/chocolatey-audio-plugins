# Functions for resolving paths (e.g. from a symbolic link)

<#
.SYNOPSIS
Checks if a given path is a kind of link and returns its value resolved

.DESCRIPTION
Checks if a given path is a kind of link and returns its value resolved. Also returns the path if it's a directory or a file. Returns $null if it doesn't exist.
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
  