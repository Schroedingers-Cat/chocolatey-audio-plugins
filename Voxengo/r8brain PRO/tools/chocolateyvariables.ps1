$packageName    = 'r8brain PRO'
$company        = 'Voxengo'
$softwareName   = "$company $packageName"
$url32          = 'https://www.voxengo.com/files/Voxengor8brainPRO_212_Win64_setup.exe'
$releases       = 'https://www.voxengo.com/product/r8brainpro/'
$checksum32     = '28b5d15aaf9d46cd7bba36cbf6a26d1f7c9c3f440abcf4c45d82888c6d3b1b59'

function CreateInstallerObjects () {
  $global:installerComponentsList =
  @{'value'="exec_64";   'bit'=64; 'validpp'="Always"},
  @{'value'="guides";    'bit'=64,32; 'validpp'="Always"},
  @{'value'="shortcuts"; 'bit'=64,32; 'validpp'="NoShortcuts"},
  @{'value'="desktopsc"; 'bit'=64,32; 'validpp'="NoShortcuts"}
}

function CreatePackageParametersObjects () {
  $global:packageArgs = @{
    packageName   = $packageName
    unzipLocation = $unzPath
    fileType      = 'exe'
    url           = $url32
    softwareName  = $softwareName
    checksum      = $checksum32
    checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  }

  if ((Test-Path variable:global:companyPath) -and ($global:companyPath -is [string]) -and ($global:companyPath.Length -gt 0)) {
    $global:packageArgs.silentArgs += " /Dir=`"${global:companyPath}`""
  }

  $global:packageParametersObjectsList = $packageArgs
}
