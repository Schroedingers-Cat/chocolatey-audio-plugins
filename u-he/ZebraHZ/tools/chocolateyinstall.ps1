$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageNameFull = 'ZebraHZ'
$version = '2.9.4'
$company = 'u-he'
$packageName = $packageNameFull.Replace(" ", "")
$softwareName = "$packageName ${version}"
$versionWithoutDots = $version -replace "\.", ""
$revision = '16765'
$urls = (
    "https://u-he.com/downloads/releases/Zebra_Legacy_${versionWithoutDots}_${revision}_Win.zip", 
    "https://u-he.com/downloads/release-archive//zebra2//Zebra_Legacy_${versionWithoutDots}_${revision}_Win.zip"
)
$unzInstPath = "Zebra_Legacy_${versionWithoutDots}_${revision}_Win\02 The Dark Zebra\The Dark Zebra ${version} Win Installer.exe"

$zipArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  checksum      = '0ad40081c8fa0b4ef004371802b66d9259d54e4b6022a98d9295680c2ed46bfd'
  checksumType  = 'sha256'
}

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'exe'
  file          = (Join-Path $toolsDir $unzInstPath)
  softwareName  = $softwareName
  silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- " # Inno Setup
}

$pp = Get-PackageParameters
if (-not [string]::IsNullOrEmpty($pp["DataPath"])) { 
    # The installer does not have an option for custom data paths but reads defaults from the registry
    function Set-RegValue([string]$Key, [string]$Name, [string]$Value) {
        if (-not (Test-Path $Key)) { New-Item -Path $Key -Force | Out-Null }
        New-ItemProperty -Path $Key -Name $Name -Value $Value -PropertyType String -Force | Out-Null
    }
    $uheDataPathReg = @{'key' = "HKLM:\SOFTWARE\U-HE\VST"; 'name' = "DataPath" }
    $uheProductDataPathReg = @{'key' = "HKCU:\SOFTWARE\U-HE\$packageName"; 'name' = "DataPath" }
    $regKeyValue = "$($pp["DataPath"])\" + "$packageName.data"  # literal ".data" suffix
    Set-RegValue $uheDataPathReg['key'] $uheDataPathReg['name'] $regKeyValue
    Set-RegValue $uheProductDataPathReg['key'] $uheProductDataPathReg['name'] $regKeyValue
}

# Try each URL until one works (doesn't fail with a 404-like error)
$downloaded = $false
$lastError  = $null

foreach ($url in $urls) {
    try {
        $zipArgs.url = $url
        Write-Host "Attempting download from: $url"
        Install-ChocolateyZipPackage @zipArgs
        $downloaded = $true
        break
    }
    catch {
        $lastError = $_
        $msg = $_.Exception.Message
        if ($msg -match '(?i)\b404\b|not\s*found') {
            Write-Host "Got a 404 from $url - trying alternative URL..."
            continue
        } else {
            # Non-404 error: nothing that alternative URLs would fix
            throw
        }
    }
}

if (-not $downloaded) {
    throw "All URLs failed with a 404-like error. Last error: $($lastError.Exception.Message)"
}

Install-ChocolateyInstallPackage @packageArgs
