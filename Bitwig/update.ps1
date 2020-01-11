import-module au

function global:au_GetLatest {
    $releases = "https://www.bitwig.com/en/previous_releases.html"
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases
    $regex   = '.msi$'
    $url     = $download_page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href
    $url     = "https:" + $url
    $url     = $url.Replace(" ", "%20")
    $version = $url.Split('/')[-2]
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
