import-module Chocolatey-AU

$releases = 'https://www.meldaproduction.com/downloads'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*\`$url64\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
        ".\mpluginmanager.nuspec" = @{
            "(?i)(^\s*<version>).*(<\/version>)" = "`${1}$($Latest.Version)`$2"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regex = "MPluginManager_\d\d_\d\d_setup\.exe"
    $url64 = ($download_page.links | Where-Object href -match $regex | Select-Object -First 1 -ExpandProperty href).Trim()

    if (-not $url64) {
        throw "Installer URL not found on the releases page."
    }

    # Ensure the URL is absolute
    if ($url64 -notmatch '^https?://') {
        $baseUri = [System.Uri]$releases
        $url64 = [System.Uri]::new($baseUri, $url64).AbsoluteUri
    }

    # Decode URL so &amp; becomes &
    $url64 = [System.Net.WebUtility]::HtmlDecode($url64)

    $versionRegex = "MPluginManager_(\d\d)_(\d\d)_setup\.exe"
    if ($url64 -match $versionRegex) {
        $versionMajor = $matches[1]
        $versionMajor = $versionMajor -replace '^0?', ''
        $versionMinor = $matches[2]
        $versionMinor = $versionMinor -replace '^0?', ''
        $version = "${versionMajor}.${versionMinor}"
    }

    Write-Host "Version is " $version
    Write-Host "URL is $url64"

    return @{
        URL64          = $url64
        Version        = $version
        ChecksumType64 = 'sha256'
        PackageName    = "meldaproduction-mpluginmanager"
        SoftwareName   = "MeldaProduction MPluginManager"
    }
}

function global:au_BeforeUpdate {
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64
}

update -ChecksumFor none
