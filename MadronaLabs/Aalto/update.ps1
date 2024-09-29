import-module Chocolatey-AU

$releases = 'https://madronalabs.com/products/aalto'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*\`$url64\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
        ".\aalto.nuspec" = @{
            "(?i)(^\s*<version>).*(<\/version>)" = "`${1}$($Latest.Version)`$2"
        }
    }
}

function global:au_GetLatest {
    $productName = $releases -replace '.*/products/([^/]+)/?$', '$1'
    $productName = $productName.ToLowerInvariant()

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regex = "$($productName)Installer.*\.exe$"
    $url64 = ($download_page.links | Where-Object href -match $regex | Select-Object -First 1 -ExpandProperty href).Trim()

    if (-not $url64) {
        throw "Installer URL not found on the releases page."
    }

    # Ensure the URL is absolute
    if ($url64 -notmatch '^https?://') {
        $baseUri = [System.Uri]$releases
        $url64 = [System.Uri]::new($baseUri, $url64).AbsoluteUri
    }

    $installerName = [System.IO.Path]::GetFileName($url64)

    $softwareName = $installerName -replace 'Installer.*', ''
    $softwareName = $softwareName.ToLowerInvariant()

    $packageName = 'madronalabs-' + $softwareName

    $version = $installerName -replace "$($productName)Installer", '' -replace '\.exe$', ''

    # Map beta versions to pre-release suffixes
    if ($version -match '(\d+\.\d+\.\d+)(b\d+)') {
        $baseVersion = $matches[1]
        $betaSuffix = $matches[2] -replace '^b', 'beta' # Converts 'b20' to 'beta20'
        $version = "${baseVersion}-${betaSuffix}"
    }

    return @{
        URL64          = $url64
        Version        = $version
        ChecksumType64 = 'sha256'
        PackageName    = $packageName
        SoftwareName   = $softwareName
    }
}

function global:au_BeforeUpdate {
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64
}

update -ChecksumFor none
