$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://www.meldaproduction.com/downloads/down?name=MPluginManager_02_19_setup.exe&platform=win&version=02.19&mirror=bunnycdn&url=https%3A%2F%2Fmeldaproduction.b-cdn.net%2Fdownload%2Fmpluginmanager%2FMPluginManager_02_19_setup.exe&checksum=b82b297426885be3347cbb5418e5eb62f0371445'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64
  softwareName  = 'MPluginManager*'
  checksum64    = 'e17c284d947cb3d943412665dda3303c82b64bf29702274153eebfe538e599f7'
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
