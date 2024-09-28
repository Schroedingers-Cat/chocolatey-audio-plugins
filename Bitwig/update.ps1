import-module Chocolatey-AU

function global:au_GetLatest {
    $releases = "https://www.bitwig.com/previous_releases/"
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases
    $regexVersion = '(\d[.]\d[.]?\d?)\/installer_windows\/'
    # Filter the links, extract the version and store the URL
    $link = $download_page.links |
        Where-Object { $_.href -match $regexVersion } |
        Select-Object -First 1

    # Extract the version from the selected link
    $version = [regex]::Match($link.href, $regexVersion).Groups[1].Value
    $fullVersion = $version
    # Check for Bitwig's "public" versioning style avoiding a .0 followed by another .0, e.g. 4.0 instead of 4.0.0
    if ($fullVersion.Length -eq 3) {
        $fullVersion = $fullVersion + ".0"
    }

    # Store the URL of the selected link
    $url = $link.href
    
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
            "<releaseNotes>https:\/\/www\.bitwig\.com\/dl\/Bitwig\%20Studio\/\d+\.\d+\.*(\d+)*\/release_notes\/<\/releaseNotes>"  = "<releaseNotes>https://www.bitwig.com/dl/Bitwig%20Studio/$($Latest.PublicVersion)/release_notes/</releaseNotes>"
        }
    }
}

update -ChecksumFor none
