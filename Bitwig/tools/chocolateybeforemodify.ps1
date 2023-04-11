$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'Bitwig'
$publicVersion = '4.4.10'
$softwareName = "Bitwig Studio $($publicVersion)"

# Create temp version variable
Install-ChocolateyEnvironmentVariable -VariableName "CHOCO_PACKAGE_VERSION_BITWIG_STUDIO" -VariableValue "$($publicVersion)" -VariableType User
