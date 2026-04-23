$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://www.meldaproduction.com/downloads/down?name=MPluginManager_02_21_setup.exe&platform=win&version=02.21&mirror=bunnycdn&url=https%3A%2F%2Fmeldaproduction.b-cdn.net%2Fdownload%2Fmpluginmanager%2FMPluginManager_02_21_setup.exe&checksum=1543f02e1c237a160d7556466c1039c642304211'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64
  softwareName  = 'MPluginManager*'
  checksum64    = 'faefe7f545c53600e8527430aa53efa0d67eb1021e4b319b91b36759701ead11'
  checksumType64= 'sha256'
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

# Package Parameters
$pp = Get-PackageParameters

if ($pp['InstallationPath']) { 
  $installPath = $pp['InstallationPath']
  $packageArgs.silentArgs += " /Dir=`"${installPath}`"" 
}

if ($pp['NoDesktopIcon']) { 
  $packageArgs.silentArgs += " /TASKS=" 
} else {
  $packageArgs.silentArgs += " /TASKS=desktopicon"
}

Install-ChocolateyPackage @packageArgs
