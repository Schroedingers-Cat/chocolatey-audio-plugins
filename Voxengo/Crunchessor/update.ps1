import-module Chocolatey-AU

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri 'https://www.voxengo.com/product/crunchessor/'
    $regex = '.exe$'
    $url = $download_page.links | ? href -match $regex | select -First 1 -expand href
    $version = $url.Split('_') | select -Index 1
    $i = $version.Length - 1
    $version = $version.Insert(1, ".")

    return @{ 
        Version     = $version; 
        URL         = $url; 
        # Workaround because AU changes package ID in the nuspec to the folder name without asking
        PackageName = "voxengo-crunchessor" 
    }
}

function global:au_BeforeUpdate() {
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
