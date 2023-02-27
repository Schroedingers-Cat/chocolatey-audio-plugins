$ErrorActionPreference = 'Stop';

$packageName= 'Bitwig'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64  = 'https://www.bitwig.com/dl/?id=512&os=installer_windows'
$checksum64 = '450adf02188347cc8ffc7dc8e8bb2505770a38ed173cebc1c05e7280c39c8005'
$publicVersion = '4.4.8'

# Uninstall prevously installed version (only if via chocolatey)
$versionToUninstall = Get-EnvironmentVariable -Name 'CHOCO_PACKAGE_VERSION_BITWIG_STUDIO' -Scope User
if ($versionToUninstall -ne "") {
  Write-Debug "Detected previous chocolatey package version: $($versionToUninstall)"
  $softwareName = "Bitwig Studio $($versionToUninstall)"
  $installerType = 'MSI'
  $silentArgs = '/qn /norestart'
  $validExitCodes = @(0, 3010, 1605, 1614, 1641)

  [array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName
  if ($key.Count -eq 1) {
    # This is from the uninstaller code
    # ToDo: Write into function
    $key | ForEach-Object {
      $file = "$($_.UninstallString)"
  
      if ($installerType -eq 'MSI') {
        $silentArgs = "$($_.PSChildName) $silentArgs"
        $file = ''
      }
  
      Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs "$silentArgs" -ValidExitCodes $validExitCodes -File "$file"
    }
  } elseif ($key.Count -eq 0) {
    Write-Warning "Previous version $versionToUninstall of $packageName has already been uninstalled by other means."
  } elseif ($key.Count -gt 1) {
    Write-Warning "Tried uninstalling the previous $versionToUninstall of $packageName but found $key.Count matches!"
    Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
    Write-Warning "Please alert package maintainer the following keys were matched:"
    $key | ForEach-Object {Write-Warning "- $_.DisplayName"}
  }
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url64bit      = $url64
  softwareName  = "Bitwig Studio $($publicVersion)" #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  checksum64    = $checksum64
  checksumType64= 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs

# Remove temp version variable
Uninstall-ChocolateyEnvironmentVariable -VariableName 'CHOCO_PACKAGE_VERSION_BITWIG_STUDIO' -VariableType User
