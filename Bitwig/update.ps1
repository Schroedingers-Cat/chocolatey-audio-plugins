import-module au

function global:au_GetLatest {
    $releases = "https://www.bitwig.com/previous_releases/"
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases
    $regex   = '.installer_windows$'
    $url     = $download_page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href
    $url     = "https://www.bitwig.com" + $url
    $url     = $url.Replace('&amp;', "&")
    $regexVersion = 'Release-Notes-'
    $version = $download_page.links | Where-Object href -Match $regexVersion | Select-Object -First 1
    $version = $version -split '-|/stable/' | select -Last 1
    $version = $version.Replace(".html}", "")
    # Workaround because AU changes package ID in the nuspec to the folder name without asking
    $global:workaroundPackageName = (Split-Path -Leaf $PSScriptRoot).ToLower()
    return @{ Version = $version; URL64 = $url; PackageName = $workaroundPackageName }
}

function global:au_BeforeUpdate() {
   $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyinstall.ps1" = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

update -ChecksumFor none
