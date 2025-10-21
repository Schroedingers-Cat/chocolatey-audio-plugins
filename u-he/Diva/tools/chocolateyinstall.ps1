$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageNameFull = 'Diva'
$version = '1.4.8'
$company = 'u-he'
$packageName = $packageNameFull.Replace(" ", "")
$softwareName = "$packageName ${version}"
$versionWithoutDots = $version -replace "\.", ""
$revision = '16519'
$urls = (
    "https://u-he.com/downloads/releases/Diva_${versionWithoutDots}_${revision}_Win.zip", 
    "https://u-he.com/downloads/release-archive//diva//Diva_${versionWithoutDots}_${revision}_Win.zip"
)
$unzInstPath = "${packageName}_Win\${packageName}-${versionWithoutDots}-Winstaller.exe"

$zipArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  checksum      = 'eec5ffc36bb7379a66fa3c03e9f475a63b1b3f9e4d2097115fd44f8b75735086'
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
    $regKeyValue = Join-Path $pp["DataPath"] -ChildPath "$packageName.data"  # literal ".data" suffix
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
