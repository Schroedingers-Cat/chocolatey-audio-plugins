import-module Chocolatey-AU

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri 'https://www.fabfilter.com/download'
    $download_page_alternative = Invoke-WebRequest -UseBasicParsing -Uri 'https://www.fabfilter.com/support/downloads'
    $packageNameBase = "simplon"
    $packageNameBaseWithoutVersion = $packageNameBase
    if ($packageNameBaseWithoutVersion -match '\d+$') {
        $packageNameBaseWithoutVersion = $packageNameBaseWithoutVersion -replace '\d+$', ''
    }

    $regex = "ff"
    $regex += $packageNameBase
    if ($packageNameBase -ne 'totalbundle') {
        if ($packageNameBase -match '\d+$') {
            $regex += "\d\d"
        } else
        {
            if ($packageNameBase -eq 'one') {
                # "FabFilter One" is the only product with a version higher than 1 that is not in its product name
                $regex += "\d\d\d"
            }
            else {
                # Version 1 never has 1 in its product name, so add here so we can find the download link
                $regex += "1\d\d"
            }
        }
    }
    $regex += "x64.exe$"
    
    # Write-Host $regex
    $url = $download_page.links | ? href -match $regex | select -First 1 -expand href
    if(-not $url)
    {
        $url = $download_page_alternative.links | ? href -match $regex | select -First 1 -expand href
    }
    # Strip anything between https:// and fabfilter.com (cdn subdomains)
    $url = $url -replace '^(https:\/\/)(?:.*\.)?(fabfilter\.com)', '$1www.$2'

    $version = ""
    $versionFabFilter = ""
    # For Total Bundle: Detect via name, download file twice and check if checksum changed, then use version scheme year.month.day
    if ($packageNameBase -eq "totalbundle") {
        $content = $download_page.Content

        $regex = '<p>\s*All FabFilter plug-ins in one download\s*<br>\s*([A-Za-z]{3}\s+\d{1,2},\s+\d{4})\s*</p>'
        if ($content -match $regex) {
            $date = $Matches[1]
            # Write-Host "Gefundener Text mit Datum: $($Matches[0])"
            # Write-Host "Extrahiertes Datum: $date"

            $parsedDate = [datetime]::Parse($date)
            $formattedDate = $parsedDate.ToString("yyyy.MM.dd")
            # Write-Host $formattedDate
            $version = $formattedDate
            $versionFabFilter = $formattedDate
        }
        else {
            Write-Host "Failed getting the date for the FabFilter Total Bundle!"
        }
    }
    else {
        # Write-Host $url
        $version = $url.Split('/') | select -Last 1
        $version = $version.Replace("ff" + $packageNameBaseWithoutVersion, "")
        $version = $version -replace "x\d+.exe", ""
        $version = $version -replace ".exe", ""
        $version = $version.Insert(1, ".")
        $versionFabFilter = $version
        $version = $version.Insert(3, ".")
        # Write-Host $version
    }

    return @{ 
        Version          = $version;
        VersionFabFilter = $versionFabFilter
        URL              = $url;
        # Workaround because AU changes package ID in the nuspec to the folder name without asking
        PackageName      = "fabfilter-simplon-x64"
    }
}

function global:au_BeforeUpdate() {
    $Latest.Checksum = Get-RemoteChecksum $Latest.Url
}

function global:au_SearchReplace {
    # Create an empty hashtable for the uninstall file
    $uninstallReplacements = @{}

    $packageNameBase = "simplon"
    if ($packageNameBase -match '\d+$') {
        $packageNameBase = $packageNameBase -replace '\d+$', ''
    }
    # Check the condition and add the appropriate regex pattern
    if ($packageNameBase -eq "totalbundle") {
        # Nothing to do
        # $uninstallReplacements["^(\s*.UninstallerSuffix\s*=\s')(\d+.\d+.\d+)(\s*)(.*)'"] =
        # "`${1}$($Latest.VersionFabFilter)`${3}`${4}'"
    }
    else {
        $uninstallReplacements["^(\s*.UninstallerSuffix\s*=\s')(\d.\d+)(\s*)(.*)'"] =
        "`${1}$($Latest.VersionFabFilter)`${3}`${4}'"
    }

    @{
        "tools\chocolateyinstall.ps1"   = @{
            "^(\s*url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "^(\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }
        "tools\chocolateyuninstall.ps1" = $uninstallReplacements
    }
}

update -ChecksumFor none -NoCheckChocoVersion
