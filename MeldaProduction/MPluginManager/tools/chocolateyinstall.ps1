$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://www.meldaproduction.com/downloads/down?name=MPluginManager_03_02_setup.exe&platform=win&version=03.02&mirror=bunnycdn&url=https%3A%2F%2Fmeldaproduction.b-cdn.net%2Fdownload%2Fmpluginmanager%2FMPluginManager_03_02_setup.exe&checksum=49b75d47403d257b13f0a7640815dae14a8172b2'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64
  softwareName  = 'MPluginManager*'
  checksum64    = 'e58a661d8ba67b02d9671c7cdb35d60f52e5520213ded8794570d816c986ce3f'
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
