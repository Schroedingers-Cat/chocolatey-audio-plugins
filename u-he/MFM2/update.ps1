import-module Chocolatey-AU
. tools\chocolateyvariables.ps1

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases #1
  $regex = "$zipSuffix" + '$'
  $url = $download_page.links | ? href -match $regex | select -First 1 -expand href #2
  $version = ((($url.Split('/') | select -Last 1).Replace("MFM2_", "")).Replace("_${zipSuffix}", "")).Split('_') | select -First 1
  #  since u-he version numbers aren't consistent (1.4 vs 1.4.1) this causes errors with the revision number included (1.4.6987 
  #  is a higher version number than 1.4.1.8978) so drop the revision number alltogether
  $stringLength = $version | measure-object -character | select -expandproperty characters
  $i = $stringLength
  while ($i -gt 1) {
    $version = $version.ToString().Insert($i - 1, '.')
    $i = $i - 1
  }

  $versionWithoutDots = $version -replace "\.", ""
  $revision = ((($url.Split('/') | select -Last 1).Replace("MFM2_","")).Replace("_${zipSuffix}","")).Split('_') | select -Last 1

  return @{
    Version     = $version
    Revision    = $revision
    URL         = "https://u-he.com/downloads/releases/MFM2_${versionWithoutDots}_${revision}_Win.zip"
    Checksum    = $checksum
    PackageName = "uhe-mfm2"
  }
}

function global:au_BeforeUpdate() {
  # Disable progress bar to speedup downloads (https://github.com/chocolatey-community/chocolatey-au/issues/58)
  $global:ProgressPreference = 'SilentlyContinue'
  $Latest.Checksum = Get-RemoteChecksum $Latest.Url
}

function global:au_SearchReplace {
  $versionWithoutDot = $($global:Latest.VERSION).Split('.')
  $versionWithoutDot = $versionWithoutDot -join ""
  @{
    "tools\chocolateyvariables.ps1" = @{
      # For now, keep this disabled (u-he dl links have changed in the past a lot and only u-he.com/downloads/... stayed)
      # "(^[$]url\s*=\s*)("".*"")"      = "`$1`"$($Latest.URL)`""
      "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum)'"
      "(^[$]version\s*=\s*)('.*')"    = "`$1'$($Latest.VERSION)'"
      "(^[$]revision\s*=\s*)('.*')"   = "`$1'$($Latest.Revision)'"
    }
  }
}

update -ChecksumFor none
