$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://www.meldaproduction.com/downloads/down?name=MPluginManager_03_01_setup.exe&platform=win&version=03.01&mirror=bunnycdn&url=https%3A%2F%2Fmeldaproduction.b-cdn.net%2Fdownload%2Fmpluginmanager%2FMPluginManager_03_01_setup.exe&checksum=457653a09de9fc73e05aae8186e3da6b6544c563'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64
  softwareName  = 'MPluginManager*'
  checksum64    = '622674278d47be7e305b809956f29645d204e07247e8e430664dcfb55e7ded35'
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
