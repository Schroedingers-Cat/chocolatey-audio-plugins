import-module Chocolatey-AU
. tools\chocolateyvariables.ps1

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    $regex = "$zipSuffix" + '$'
    $urlTemp = $download_page.links | ? href -match $regex | select -First 1 -expand href
    $url = "https://dmgaudio.com" + $urlTemp
    Write-Host "Download URL: $url"

    $versionAtUrl = ((($url.Split('/') | select -Last 1).Replace("${packageName}Win_v", "")).Replace(".zip", ""))

    if ($versionAtUrl -ne $version) {
        $checksum32 = Get-RemoteChecksum -Url $url -Algorithm SHA256
        Write-Host "Calculated Checksum (via Get-RemoteChecksum): $checksum32"
    }

    return @{
        Version     = $versionAtUrl
        URL32       = $url
        Checksum32  = $checksum32
        PackageName = "dmgaudio-tracklimit"
    }
}

function global:au_SearchReplace {
    # Get the current year
    $currentYear = (Get-Date).Year

    @{
        "tools\chocolateyvariables.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]version\s*=\s*)('.*')"    = "`$1'$($global:Latest.VERSION)'"
        }
        "tracklimit.nuspec"   = @{
            '(<copyright>Copyright \(c\) DMGAudio 2011-)\d{4}' = '${1}' + "$currentYear"
        }
    }
}

# Run the update process
# no automatic checksumming, we manually checksummed to workaround chocolateyInstall.ps1 required to be present in the tools directory at update time
update -ChecksumFor none

Move-Item (${packageName} + "*" + ".nupkg") ..\ -Force
