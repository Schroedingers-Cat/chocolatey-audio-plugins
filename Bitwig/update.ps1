import-module au

function global:au_GetLatest {
    $releases = "https://www.bitwig.com/previous_releases/"
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases
    $regex   = '.installer_windows$'
    $url     = $download_page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href
    $url     = $url.Replace('&amp;', "&")
    $regexVersion = 'Release-Notes-'
    $version = $download_page.links | Where-Object href -Match $regexVersion | Select-Object -First 1
    $version = $version -split '-|/stable/' | select -Last 1
    $version = $version.Replace(".html}", "")
    $version = $version.Replace(".html; target=_blank}", "")
    $version = $version.Replace(".html; target=_blank; rel=noopener}", "")
    $fullVersion = $version
    # Check for Bitwig's "public" versioning style avoiding a .0 followed by another .0, e.g. 4.0 instead of 4.0.0
    if ($fullVersion.Length -eq 3) {
        $fullVersion = $fullVersion + ".0"
    }
    # Workaround because AU changes package ID in the nuspec to the folder name without asking
    $global:workaroundPackageName = (Split-Path -Leaf $PSScriptRoot).ToLower()
    return @{ Version = $fullVersion; URL64 = $url; PackageName = $workaroundPackageName; PublicVersion = $version }
}

function global:au_BeforeUpdate() {
   $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyinstall.ps1" = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]publicVersion\s*=\s*)('.*')" = "`$1'$($Latest.PublicVersion)'"
        };
        "tools\chocolateyuninstall.ps1" = @{
            "(^[$]publicVersion\s*=\s*)('.*')" = "`$1'$($Latest.PublicVersion)'"
        };
        "tools\chocolateybeforemodify.ps1" = @{
            "(^[$]publicVersion\s*=\s*)('.*')" = "`$1'$($Latest.PublicVersion)'"
        };
        "bitwig.nuspec" = @{
            "<releaseNotes>https://downloads.bitwig.com/\d+.\d+?.?\d+/Release-Notes-\d+.\d+?.?\d+.html</releaseNotes>"  = "<releaseNotes>https://downloads.bitwig.com/$($Latest.PublicVersion)/Release-Notes-$($Latest.PublicVersion).html</releaseNotes>"
        }
    }
}

update -ChecksumFor none
