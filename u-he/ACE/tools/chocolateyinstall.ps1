$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageNameFull = 'ACE'
$version = '1.4.3'
$company = 'u-he'
$packageName = $packageNameFull.Replace(" ", "")
$softwareName = "$packageName ${version}"
$versionWithoutDots = $version -replace "\.", ""
$revision = '16518'
$urls = (
    "https://u-he.com/downloads/releases/ACE_${versionWithoutDots}_${revision}_Win.zip", 
    "https://u-he.com/downloads/release-archive//ace//ACE_${versionWithoutDots}_${revision}_Win.zip"
)
$unzInstPath = "${packageName}_Win\${packageName}-${versionWithoutDots}-Winstaller.exe"

$zipArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  checksum      = '341ae2deae654b1cf154a2f777124bae9a64f823f51e3288e02906c52e17c45e'
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
