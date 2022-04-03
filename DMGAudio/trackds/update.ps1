import-module au
. tools\chocolateyvariables.ps1


function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases #1
     $regex   = "$zipSuffix" + '$'
     $urlTemp     = $download_page.links | ? href -match $regex | select -First 1 -expand href #2
     $url = "https://dmgaudio.com" + $urlTemp
     Write-Host "$url"
     $version = ((($url.Split('/') | select -Last 1).Replace("${packageName}Win_v","")).Replace(".zip",""))
     return @{ Version = $version; URL32 = $url }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyvariables.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
            "(^[$]unzipInstVersion\s*=\s*)('.*')" = "`$1'$($global:Latest.VERSION)'"
        }
    }
}

update -ChecksumFor all
Move-Item (${packageName} + "*" + ".nupkg") ..\ -Force
