import-module Chocolatey-AU

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*\`$url64\s*=\s*)('.*')"   = "`$1'$($Latest.Url64)'"
            "(?i)(^\s*\`$url64NoSB\s*=\s*)('.*')"   = "`$1'$($Latest.UrlNoSB)'"
            "(?i)(^\s*\`$checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*\`$checksum64NoSB\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64NoSB)'"
        }
        ".\reason 14.nuspec" = @{
            "(?i)(^\s*<version>).*(<\/version>)" = "`${1}$($Latest.Version)`$2"
        }
    }
}

function global:au_GetLatest {
    # Install browser driver for powershell
    # Install-Module Selenium -Force
    Import-Module Selenium

    $url = "https://help.reasonstudios.com/hc/en-us/articles/360002216653-Download-using-BitTorrent"

    $Driver = Start-SeFirefox
    try {
        # Avoid indefinite page-load waits
        $Driver.Manage().Timeouts().PageLoad = [TimeSpan]::FromSeconds(45)

        $Driver.Navigate().GoToUrl($url)

        # Wait until the actual page (not CF challenge) contains the torrent link we need
        $torrentRegex = 'https://cdn\.reasonstudios\.com/torrents/Reason_14\d+_d\d+-Stable-\d+-Win.zip.torrent'

        $timeoutSec = 60
        $sw = [Diagnostics.Stopwatch]::StartNew()
        do {
            Start-Sleep -Milliseconds 250
            $html = $Driver.PageSource
        } while ($sw.Elapsed.TotalSeconds -lt $timeoutSec -and $html -notmatch $torrentRegex)

        if ($html -notmatch $torrentRegex) {
            throw "Timed out waiting for torrent link to appear in page source (still seeing Cloudflare challenge or page didn't load)."
        }

        # Build a links collection similar to your original, but from HTML
        # Capture href + inner text from <a ... href="...">TEXT</a>
        $aRegex = '(?is)<a\b[^>]*\bhref\s*=\s*"(?<href>[^"]+)"[^>]*>(?<text>.*?)</a>'
        $links = foreach ($m in [regex]::Matches($html, $aRegex)) {
            $href = $m.Groups['href'].Value
            $textRaw = $m.Groups['text'].Value

            # Strip nested HTML, decode entities, and trim
            $textNoTags = [regex]::Replace($textRaw, '(?is)<[^>]+>', '')
            $text = [System.Net.WebUtility]::HtmlDecode($textNoTags).Trim()

            [PSCustomObject]@{
                Href = $href
                Text = $text
            }
        }
    }
    finally {
        $Driver.Quit()
    }

    $regex = "Reason_14\d+_d\d+-Stable-\d+-Win.zip.torrent"
    # Find the first link that matches the regex pattern
    $linkData = $links | Where-Object { $_.Href -match $regex } | Select-Object -First 1

    # Trim any extra spaces
    $url64 = $linkData.Href.Trim()
    $linkText = $linkData.Text.Trim()

    if (-not $url64) {
        throw "Installer URL not found on the releases page."
    }

    # Output the results
    Write-Host "Href: $url64"
    Write-Host "Link Text: $linkText"

    $regexLinkText = "Reason 14\.(\d+\.?\d?) full installer for Windows"
    if ($linkText -match $regexLinkText) {
        $version = $Matches[1]
    }
    else {
        throw "Version not found in link text."
    }

    if ($version -match "\.") {
        $versionParts = $version -split "\."
        $versionMinor = $versionParts[0]
        $versionPatch = $versionParts[1]
    }
    else {
        $versionMinor = $version
        $versionPatch = 0
    }

    $version = "14.$versionMinor.$versionPatch"
    Write-Host "Minor: $versionMinor, Patch: $versionPatch"

    $regexUrl = "Reason_14(\d+)_(d\d+)-Stable-(\d+)-Win.zip.torrent"
    if ($url64 -match $regexUrl) {
        $newUrl = "https://cdn.reasonstudios.com/update/Stable/Reason_14"
        $newUrl += $Matches[1]
        $newUrl += "_"
        $newUrl += $Matches[2]
        $newUrl += "-"
        $newUrl += "Stable"
        $newUrl += "-"
        $newUrl += $Matches[3]
        $newUrlWithoutSoundbanks = $newUrl
        $newUrl += "-Win.zip"
        $newUrlWithoutSoundbanks += "-without_soundbanks-Win.zip"
        $versionSuffix = $Matches[2]
    }
    else {
        throw "Version not found in link text."
    }

    $response = Invoke-WebRequest -Uri $newUrl -Method Head -UseBasicParsing
    if ($response.StatusCode -eq 200) { Write-Output "URL $newUrl is valid" } else { Write-Output "URL $newUrl is not valid" }
    Write-Host "New URL is $newUrl"

    $response = Invoke-WebRequest -Uri $newUrlWithoutSoundbanks -Method Head -UseBasicParsing
    if ($response.StatusCode -eq 200) { Write-Output "URL $newUrlWithoutSoundbanks is valid" } else { Write-Output "URL $newUrlWithoutSoundbanks is not valid" }
    Write-Host "New URL is $newUrlWithoutSoundbanks"

    return @{
        Url64         = $newUrl
        UrlNoSB       = $newUrlWithoutSoundbanks
        Version       = $version
        VersionSuffix = $versionSuffix
        # ChecksumType64 = 'sha256'
        PackageName   = "reasonstudios-reason14"
    }
}

function global:au_BeforeUpdate {
    $fn = [System.IO.Path]::GetTempFileName()
    Start-BitsTransfer -Source $Latest.URL64 -Destination $fn

    $Latest.Checksum64 = (Get-FileHash $fn -Algorithm 'sha256' | ForEach-Object Hash).ToLower()

    Remove-Item $fn

    $fn2 = [System.IO.Path]::GetTempFileName()
    Start-BitsTransfer -Source $Latest.UrlNoSB -Destination $fn2

    $Latest.Checksum64NoSB = (Get-FileHash $fn2 -Algorithm 'sha256' | ForEach-Object Hash).ToLower()

    Remove-Item $fn2
}

update -ChecksumFor none
