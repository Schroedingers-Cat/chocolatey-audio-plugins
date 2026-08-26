$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://www.meldaproduction.com/downloads/down?name=MPluginManager_02_29_setup.exe&platform=win&version=02.29&mirror=bunnycdn&url=https%3A%2F%2Fmeldaproduction.b-cdn.net%2Fdownload%2Fmpluginmanager%2FMPluginManager_02_29_setup.exe&checksum=e38f351532438a9fe3d3a4a054e10e70cd64fe4e'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64
  softwareName  = 'MPluginManager*'
  checksum64    = 'd60a4c78eeb2d0b0eb8a318775a7259de8dae27026be1c722831b6a75e097378'
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
