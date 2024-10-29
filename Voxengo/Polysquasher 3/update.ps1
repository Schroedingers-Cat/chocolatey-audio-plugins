import-module Chocolatey-AU
. tools\chocolateyvariables.ps1

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases #1
    $regex = '.exe$'
    $url = $download_page.links | ? href -match $regex | select -First 1 -expand href #2
    $version = $url.Split('_') | select -Index 1 #3
    $i = $version.Length - 1
    $version = $version.Insert(1, ".")

    return @{ 
        Version     = $version; 
        URL32       = $url; 
        # Workaround because AU changes package ID in the nuspec to the folder name without asking
        PackageName = "voxengo-polysquasher3" 
    }
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

update -ChecksumFor none -NoCheckChocoVersion
