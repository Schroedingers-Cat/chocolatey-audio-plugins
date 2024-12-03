param (
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path -Path $_ -PathType 'Container' })]
    [string]$SharedScriptsPath = "${PSScriptRoot}\..\SharedScripts"
)

$Author = "u-he"
$AuthorLowerNowhite = $Author.ToLower().Replace(" ", "")
$MaintainerName = "Schroedingers-Cat"

$products = @(
    @{
        SoftwareName  = "ACE"
        Version       = "1.4.2"
        Revision      = "16517"
        Tags          = "audio vst synthesizer aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/ace.png"
        Summary       = "A virtual-analog synthesizer by u-he."
    },
    @{
        SoftwareName  = "Bazille"
        Version       = "1.1.2"
        Revision      = "16517"
        Tags          = "audio vst synthesizer aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/4b30c7aff8a221d68aabd4c647849ffe1aa6424b/Icons/u-he/bazille.png"
        Summary       = "A modular synthesizer by u-he."
    },
    @{
        SoftwareName  = "Colour Copy"
        Version       = "1.0.1"
        Revision      = "12092"
        Tags          = "audio vst effect delay aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a38c089d2a528cb75df73ef9ea46269589782c91/Icons/u-he/colourcopy.png"
        Summary       = "A virtual-analog delay effect by u-he."
    },
    @{
        SoftwareName  = "Diva"
        Version       = "1.4.7"
        Revision      = "16517"
        Tags          = "audio vst synthesizer aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/diva.png"
        Summary       = "A virtual-analog synthesizer by u-he."
    },
    @{
        SoftwareName  = "Filterscape"
        Version       = "1.5.0"
        Revision      = "15663"
        Tags          = "audio vst effect synthesizer instrument filter delay aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/aaaf7224b53830e9217e0d2ad3d950b56dc11c76/Icons/u-he/filterscape.png"
        Summary       = "Morphing EQ based effect and instrument by u-he."
    },
    @{
        SoftwareName  = "Hive"
        Version       = "2.1.1"
        Revision      = "15663"
        Tags          = "audio vst synthesizer aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/hive2.png"
        Summary       = "A wavetable synthesizer by u-he."
    },
    @{
        SoftwareName  = "MFM2"
        Version       = "2.5.0"
        Revision      = "13385"
        Tags          = "more feedback machine audio vst vst3 aax clap effect delay admin trial"
        Checksum      = "20f69db8f978efa1efe46b6c4215c314837c18621a6e9e80a66c3a39ad55aa7c"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/mfm2.png"
        Summary       = "A virtual-analog delay effect by u-he."
    },
    @{
        SoftwareName  = "Presswerk"
        Version       = "1.1.4"
        Revision      = "12091"
        Tags          = "audio vst synthesizer aax admin trial"
        Checksum      = "20f69db8f978efa1efe46b6c4215c314837c18621a6e9e80a66c3a39ad55aa7c"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a38c089d2a528cb75df73ef9ea46269589782c91/Icons/u-he/presswerk.png"
        Summary       = "A flexible compressor by u-he."
    },
    @{
        SoftwareName  = "Repro"
        Version       = "1.1.1"
        Revision      = "12091"
        Tags          = "audio vst synthesizer aax admin trial"
        Checksum      = "20f69db8f978efa1efe46b6c4215c314837c18621a6e9e80a66c3a39ad55aa7c"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/repro.png"
        Summary       = "A virtual-analog synthesizer by u-he."
    },
    @{
        SoftwareName  = "Twangstrom"
        Version       = "1.0.1"
        Revision      = "12092"
        Tags          = "audio vst effect delay aax admin trial"
        Checksum      = "2329d06a90c2b2a521a730d75a181a7099a04c43a711c7239683c3f71629e827"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a38c089d2a528cb75df73ef9ea46269589782c91/Icons/u-he/twangstrom.png"
        Summary       = "A spring reverb by u-he."
    },
    @{
        SoftwareName  = "Satin"
        Version       = "1.3.2"
        Revision      = "15720"
        Tags          = "audio vst effects aax admin trial"
        Checksum      = "2329d06a90c2b2a521a730d75a181a7099a04c43a711c7239683c3f71629e827"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a38c089d2a528cb75df73ef9ea46269589782c91/Icons/u-he/satin.png"
        Summary       = "A recording tape simulator by u-he."
    },
    @{
        SoftwareName  = "Uhbik"
        Version       = "1.3.0"
        Revision      = "3897"
        Tags          = "audio vst effects aax admin trial"
        Checksum      = "2329d06a90c2b2a521a730d75a181a7099a04c43a711c7239683c3f71629e827"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/4b30c7aff8a221d68aabd4c647849ffe1aa6424b/Icons/u-he/uhbik.png"
        Summary       = "A suite of effects by u-he."
    },
    @{
        SoftwareName  = "Zebra2"
        Version       = "2.9.2"
        Revision      = "10409"
        Tags          = "audio vst synthesizer aax admin trial"
        Checksum      = "B5C62286D0AE38C384ACF8B1BD5495E1CEF169ED2C64ABBC2C5BFCD9CD475AD5"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b695ca94b0b4c3825450d24e027a79bc80e211dc/Icons/u-he/zebra2.png"
        Summary       = "A virtual-analog synthesizer by u-he."
        PackageNameUrl = "Zebra_Legacy"
        PackageAlternativeUrlDirectory = "zebra2"
        ProductPageName = "zebra-legacy"
    },
    @{
        SoftwareName  = "ZebraHZ"
        Version       = "2.9.2"
        Revision      = "10409"
        Tags          = "audio vst synthesizer aax admin trial"
        Checksum      = "B5C62286D0AE38C384ACF8B1BD5495E1CEF169ED2C64ABBC2C5BFCD9CD475AD5"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c2c3274a3c3d3b1affe2e0293e2dfcef2a27d59f/Icons/u-he/zebrahz.png"
        Summary       = "A virtual-analog synthesizer by u-he."
        PackageNameUrl = "Zebra_Legacy"
        PackageAlternativeUrlDirectory = "zebra2"
        ProductPageName = "zebra-legacy"
    }
)

foreach ($product in $products) {
    $PackageId = $product.SoftwareName.Replace(" ", "-").ToLower()
    $PackageNameNoWhite = $product.SoftwareName.Replace(" ", "").ToLower()
    
    # Some products break the naming scheme, so those will need to be detected on a case by case basis
    if($product.PackageNameUrl -eq $null) {
        $PackageNameUrl = $product.SoftwareName.Replace(" ", "")
    }
    else {
        $PackageNameUrl = $product.PackageNameUrl
    }

    if($product.PackageAlternativeUrlDirectory -eq $null) {
        $PackageAlternativeUrlDirectory = $product.SoftwareName.Replace(" ", "").ToLower()
    }
    else {
        $PackageAlternativeUrlDirectory = $product.PackageAlternativeUrlDirectory
    }

    if($product.ProductPageName -eq $null) {
        $ProductPageName = $PackageNameNoWhite
    }
    else {
        $ProductPageName = $product.ProductPageName
    }
    
    # Construct the choco new command as a single line string
    $command = "choco new '$($product.SoftwareName)' -t uhe.template " +
    "Version='$($product.Version)' " +
    "Author='$($Author)' " +
    "AuthorLowerNowhite='$($AuthorLowerNowhite)' " +
    "MaintainerName='$($MaintainerName)' " +
    "Tags='$($product.Tags)' " +
    "Checksum='$($product.Checksum)' " +
    "UrlIcon='$($product.UrlIcon)' " +
    "Summary='$($product.Summary)' " +
    "Revision='$($product.Revision)' " +
    "PackageId='$($PackageId)' " +
    "PackageNameNoWhite='$($PackageNameNoWhite)' " +
    "PackageNameUrl='$($PackageNameUrl)' " +
    "PackageAlternativeUrlDirectory='$($PackageAlternativeUrlDirectory)' " +
    "ProductPageName='$($ProductPageName)' " +
    "--force"

    Write-Debug $command
    Invoke-Expression $command

    $nuspecFilePath = "$PSScriptRoot\$($product.SoftwareName)\$($product.SoftwareName.ToLower()).nuspec"
    $nuspecDir = [System.IO.Path]::GetDirectoryName((Resolve-Path -Path $nuspecFilePath).Path)

    # Set the current location to the directory of the .nuspec file temporarily
    Push-Location -Path $nuspecDir

    # Get the relative path from the .nuspec directory to the shared scripts path
    $relativePath = Resolve-Path -Path $SharedScriptsPath -Relative

    # Replace remaining variables in .nuspec file and create package
    (Get-Content -Path $nuspecFilePath -Raw) `
        -replace '\$sharedscripts\$', $relativePath `
        -replace '\\+', '\' | Set-Content -Path $nuspecFilePath

    # Return to the previous location
    Pop-Location
    
    choco pack $nuspecFilePath
}
