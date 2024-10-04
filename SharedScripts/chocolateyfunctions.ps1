# Installer Functions

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

<#
.SYNOPSIS
Which installation steps are actually necessary for the given OS and package parameters?

.DESCRIPTION
Checks the current OS bitness and the given package parameters and marks all steps from the chocolateyvariables file to be actually executed by setting their 'execute' bit.

.PARAMETER objectsList
A list of objects with a 'validpp' key and a 'bit' key from the chocolateyvariables.ps1 file.

.NOTES
#>

function DetermineExecutionOfAllObjects ($objectsList) {
  Foreach ($object in $objectsList) {
      $object.Add('execute', $false)
      $bitStatus = ($object.bit -eq $null) -Or ($object.bit -Contains $osBitness)
      $ppIndependent = (($object.validpp -eq $null) -Or ($object.validpp -Like "Always"))
      Write-Debug ("ppindependent: " + $ppIndependent)
      Write-Debug ("bitStatus: " + $bitStatus)

      Foreach ($packageParameter in $object.validpp) {
          Write-Debug ("Status of evaluated package parameter:" + $packageParameter)
          if ((Test-Path variable:pp.packageParameter) -eq $true) {
              Write-Debug $pp[$packageParameter]
              Write-Debug ($pp[$packageParameter] -eq $false)
          }
          if (($pp[$packageParameter] -eq $false) -And $bitStatus) {
              $object.execute = $true
          }
      }

      if ($ppIndependent -And $bitStatus) {
          $object.execute = $true
      }

      If ($object.ContainsKey("dropIfNull")) {
          Write-Debug ("Object $object contains a dropIfNull!")

          Foreach ($variableToCheck in $object.dropIfNull) {
              If ([string]::IsNullOrWhiteSpace($variableToCheck)) {
                  Write-Debug ("Dependent variable is NULL")
                  $object.execute = $false
              }
              else {
                  Write-Debug ("Dependent variable is $variableToCheck")
              }
          }
      }
  }
}
