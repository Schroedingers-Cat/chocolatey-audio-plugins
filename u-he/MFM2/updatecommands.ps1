import-module au

function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases #1
     $regex   = "$zipSuffix" + '$'
     $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href #2
     Write-Host "$url"
     $version = ((($url.Split('/') | select -Last 1).Replace("${packageName}_","")).Replace("_${zipSuffix}","")).Replace("_",".")
     Write-Host "$version"
     return @{ Version = $version; URL32 = $url }
}

function global:au_BeforeUpdate() {
   $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyvariables.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
        }
    }
}

update -ChecksumFor none
