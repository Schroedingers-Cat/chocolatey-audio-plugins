import-module Chocolatey-AU

$productPageUrl = 'https://acondigital.com/products/acoustica'
# Group 1 must capture the underscore version, e.g. Acoustica_Win64_(8_0_9).exe
$fileNameRegex  = 'Acoustica_Win64_(8_\d+_\d+)\.exe'

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $productPageUrl
    $candidates = [regex]::Matches($download_page.Content, "https://[^""' ]*$fileNameRegex") | ForEach-Object {
        [pscustomobject]@{
            Url     = $_.Value
            Version = [version]($_.Groups[1].Value -replace '_', '.')
        }
    }
    # The page also lists the legacy Acoustica 7 installer - take the highest match
    $latest = $candidates | Sort-Object Version -Descending | Select-Object -First 1
    if (-not $latest) { throw "No Acoustica_Win64 download URL found at $productPageUrl" }

    return @{
        Version     = $latest.Version.ToString()
        URL         = $latest.Url
        # Workaround because AU changes package ID in the nuspec to the folder name without asking
        PackageName = 'acondigital-acoustica-8'
    }
}

function global:au_BeforeUpdate() {
    # Disable progress bar to speedup downloads (https://github.com/chocolatey-community/chocolatey-au/issues/58)
    $global:ProgressPreference = 'SilentlyContinue'
    $Latest.Checksum = Get-RemoteChecksum $Latest.Url
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyinstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"           #1
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"      #2
        }
    }
}

update -ChecksumFor none -NoCheckChocoVersion
