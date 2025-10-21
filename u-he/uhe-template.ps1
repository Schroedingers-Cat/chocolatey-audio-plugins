param (
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path -Path $_ -PathType 'Container' })]
    [string]$SharedScriptsPath = "${PSScriptRoot}\..\SharedScripts"
)

$Author = "u-he"
$AuthorLowerNowhite = $Author.ToLower().Replace(" ", "")
$MaintainerName = "Schroedingers-Cat"
$DescriptionShared = @"
## Installer Arguments
If you want to select which formats and other components to install, add ``-ia '/COMPONENTS=vst3_64,clap_64,presets,nks'`` as parameter. The following components can be set:

* ``vst3_32`` - Install the x86 (32 bit) VST3 version
* ``vst3_64`` - Install the x64 (64 bit) VST3 version
* ``clap_64`` - Install the x64 (64 bit) CLAP version
* ``aax_64``  - Install the x64 (64 bit) AAX version
* ``presets`` - Install the presets
* ``nks``     - Install the NKS integration

## Package Parameters

* ``/DataPath:`` - Path to the .Data directory containing the program files. Override if you want to have the program files at a custom location. Careful: u-he program files are expected to be directly writeable (no UAC involved) by the user running the software.

For example:
``````powershell
choco install uhe-package --package-parameters """'/DataPath:${env:PUBLIC}\Documents\u-he'"""
``````
"@

function CreateInstallerObjects () { $global:installerComponentsList =
  #Warning: The order of the list *is* important
  @{'value'="vst3_32";   'bit'=64,32; 'validpp'="NoVst3x86"},
  @{'value'="vst3_64";   'bit'=64;    'validpp'="NoVst3x64"},
  @{'value'="clap_64";   'bit'=64;    'validpp'="NoClapx64"},
  @{'value'="aax_64";    'bit'=64;    'validpp'="NoAaxx64"},
  @{'value'="presets";   'bit'=64,32; 'validpp'="NoPresets"},
  @{'value'="nks";       'bit'=64,32; 'validpp'="NoNks"}
}

$products = @(
    @{
        SoftwareName  = "ACE"
        Version       = "1.0.0"
        Revision      = "16517"
        Tags          = "audio clap vst synthesizer aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/ace.png"
        Summary       = "A virtual-analog synthesizer by u-he."
        NoNks         = $true
        Description   = "ACE: Any cable everywhere
ACE is a gateway into the world of modular synthesizers. Compact, clear, a careful selection of modules and semi-modular architecture makes ACE easy to learn. Simple but not simplistic. Compact but not limited. Clear but definitely not underpowered. With the ability to connect any output into any input (any cable everywhere), ACE is a powerful synth with tools and features ready for beginners or seasoned users.
"
    },
    @{
        SoftwareName  = "Bazille"
        Version       = "1.0.0"
        Revision      = "16517"
        Tags          = "audio clap vst synthesizer aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/4b30c7aff8a221d68aabd4c647849ffe1aa6424b/Icons/u-he/bazille.png"
        Summary       = "A modular synthesizer by u-he."
        NoNks         = $true
        Description   = "Bazille: Monster from the deep
The second spawn of the Berlin Modular project, Bazille is a large polyphonic modular system with digital (PD, FM based) oscillators, multimode filters and plenty of modulation options. With so much connectivity to explore, patching in Bazille should keep you fascinated for many years - it's definitely a ''geek machine''!
"
    },
    @{
        SoftwareName  = "Colour Copy"
        Version       = "1.0.0"
        Revision      = "12092"
        Tags          = "audio clap vst effect delay aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a38c089d2a528cb75df73ef9ea46269589782c91/Icons/u-he/colourcopy.png"
        Summary       = "A virtual-analog delay effect by u-he."
        Description   = "Colour Copy: a bucketful of delay
A virtual analog effect inspired by classic bucket-brigade delays (BBD), but extended with modern features. We called our new baby 'Colour Copy' because it can deliver the kind of colouration people still love in classic BBD units, but with a wider variety of colours. Colour Copy started life as the little delay unit called 'Lyrebird' we built into Repro-1, but the sound was too good not to be developed further and become an FX plug-in.
"
    },
    @{
        SoftwareName  = "Diva"
        Version       = "1.0.0"
        Revision      = "16517"
        Tags          = "audio clap vst synthesizer aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/diva.png"
        Summary       = "A virtual-analog synthesizer by u-he."
        Description   = "Diva: Dinosaur Impersonating Virtual Analogue synthesizer.
Diva captures the spirit of five decades of analogue synthesizers. Oscillators, filters, and envelopes from some of the greatest monophonic and polyphonic synths of yesteryear were meticulously modelled for unmatched analogue sound. Diva is more than a single synthesizer: Recreate an old favourite or mix-and-match modules to design your own unique hybrid.
"
    },
    @{
        SoftwareName  = "Filterscape"
        Version       = "1.0.0"
        Revision      = "15663"
        Tags          = "audio clap vst effect synthesizer instrument filter delay aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/aaaf7224b53830e9217e0d2ad3d950b56dc11c76/Icons/u-he/filterscape.png"
        Summary       = "Morphing EQ based effect and instrument by u-he."
        NoNks         = $true
        Description   = "Filterscape 1.5: A trio of plug-ins with morphing EQ
At the core of all three plugins is the distinctive EQ, capable of seamlessly transitioning between 8 different 'snapshots'. Each EQ band's frequency and amplitude can be dynamically modulated, even from different sources for each snapshot! With a sleek and future-proof new design, Filterscape has become more visually appealing and more comfortable to use. 
"
    },
    @{
        SoftwareName  = "Hive"
        Version       = "1.0.0"
        Revision      = "15663"
        Tags          = "audio clap vst synthesizer aax admin trial"
        Checksum      = "05cc1ffd7bcbdd14c4eac223d4584b8eb9ed4ed55049f0714e788ee85a16e978"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/hive2.png"
        Summary       = "A wavetable synthesizer by u-he."
        Description   = "Hive: Built for fast results
With its effortless workflow and low processor usage, you can create your patches in next to no time at all. Hive is quick and uncomplicated but that doesn't mean sacrificing flexibility, sound quality or creativity. It's packed with features and controls - with a dazzling character that delivers stunning sound.
"
    },
    @{
        SoftwareName  = "MFM2"
        Version       = "1.0.0"
        Revision      = "13385"
        Tags          = "more feedback machine audio clap vst vst3 aax clap effect delay admin trial"
        Checksum      = "20f69db8f978efa1efe46b6c4215c314837c18621a6e9e80a66c3a39ad55aa7c"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/mfm2.png"
        Summary       = "A virtual-analog delay effect by u-he."
        NoNks         = $true
        Description   = "MFM2: More Feedback Machine
MFM2 is our over-the-top digital delay plug-in. You can create anything from subtle textured echos to huge spacey reverbs, from wild tonal steps on a pad to rhythmic deconstruction of a drum track. As a regular delay MFM2 already offers as much control and inspiration as possible, while the advanced features in version 2.5 open up wider horizons. More feedback, more control, more inspiration! 
"
    },
    @{
        SoftwareName  = "Presswerk"
        Version       = "1.0.0"
        Revision      = "12091"
        Tags          = "audio clap vst synthesizer aax admin trial"
        Checksum      = "20f69db8f978efa1efe46b6c4215c314837c18621a6e9e80a66c3a39ad55aa7c"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a38c089d2a528cb75df73ef9ea46269589782c91/Icons/u-he/presswerk.png"
        Summary       = "A flexible compressor by u-he."
        Description   = "Presswerk: Dynamics processor with musical soul
Presswerk is more than an emulation of a single hardware compressor. Like Satin, Presswerk is a toolkit, drawing ideas and inspiration from a number of sources. It starts with warmth of classic analogue units and adds features only possible in the digital realm. The result is a powerful compressor with a rich feature set and a very musical soul.
Presswerk was designed to fit into any workflow, no matter what task you throw at it. Presswerk gives you the tools for better sound.
"
    },
    @{
        SoftwareName  = "Repro"
        Version       = "1.0.0"
        Revision      = "12091"
        Tags          = "audio clap vst synthesizer repro-1 repro-5 aax admin trial"
        Checksum      = "20f69db8f978efa1efe46b6c4215c314837c18621a6e9e80a66c3a39ad55aa7c"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/cea53d40c0ed5cabb4a17af985954f315bce6bea/Icons/u-he/repro.png"
        Summary       = "A virtual-analog synthesizer by u-he."
        Description   = "Repro: analogue, meticulously recreated
Repro dives into the past for analogue inspiration, meticulously modelling two famous synthesizers. Every detail of the original was captured using component-level modelling technology to create the most authentic model possible. All the subtle characteristics and quirks found in the originals are present in Repro. One product, one installer, two synths.
"
    },
    @{
        SoftwareName  = "Twangstrom"
        Version       = "1.0.0"
        Revision      = "12092"
        Tags          = "audio clap vst effect delay aax admin trial"
        Checksum      = "2329d06a90c2b2a521a730d75a181a7099a04c43a711c7239683c3f71629e827"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a38c089d2a528cb75df73ef9ea46269589782c91/Icons/u-he/twangstrom.png"
        Summary       = "A spring reverb by u-he."
        Description   = "This is Twangström, a flexible spring-reverb box-of-tricks. If you're familiar with Bazille you might already have come across its built-in spring unit. We took that one, and modelled two more reverb tanks, paired it with drive section, filter stage, envelope, and mod matrix.
In Twangström, tanks are based on 'physical modelling'. As opposed to plug-ins using impulse responses (IRs) of actual devices but being limited in expression and manipulation, our approach mimics the actual physics of mechanical reverberation. Thus we're not reproducing sonic results, we're actually simulating their origin. And it's all controllable in realtime, on a per-sample-basis. Which boils down to quite some power at your fingertips.
"
    },
    @{
        SoftwareName  = "Satin"
        Version       = "1.0.0"
        Revision      = "15720"
        Tags          = "audio clap vst effects aax admin trial"
        Checksum      = "2329d06a90c2b2a521a730d75a181a7099a04c43a711c7239683c3f71629e827"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a38c089d2a528cb75df73ef9ea46269589782c91/Icons/u-he/satin.png"
        Summary       = "A recording tape simulator by u-he."
        Description   = "Satin: Tape machine
Nothing else quite sounds like tape. Satin puts the legacy of tape recording in your hands: from top-of-the-line multi-track consoles to humble cassette decks. All the good (saturation, transient smoothing, compression) as well as the bad (noise modulation, flutter, hiss) qualities are under your control. Construct your (im)perfect tape machine.
"
    },
    @{
        SoftwareName  = "Uhbik"
        Version       = "1.0.0"
        Revision      = "3897"
        Tags          = "audio clap vst effects aax admin trial"
        Checksum      = "2329d06a90c2b2a521a730d75a181a7099a04c43a711c7239683c3f71629e827"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/2ba5e3e32e784fd687045ccb7ed34c703f55a369/Icons/u-he/uhbik.png"
        Summary       = "A suite of effects by u-he."
        NoNks         = $true
        Description   = "Sleek, intuitive and powerful
A collection of ten sophisticated effects with support for surround formats up to 7.1. Perfect for adding the finishing touches to your regular projects or for building wild, experimental quadraphonic effect chains… Whether you need subtle nuance or strong impact, Uhbik has you covered!
"
    },
    @{
        SoftwareName  = "Zebra2"
        Version       = "1.0.0"
        Revision      = "10409"
        Tags          = "audio clap vst synthesizer aax admin trial"
        Checksum      = "B5C62286D0AE38C384ACF8B1BD5495E1CEF169ED2C64ABBC2C5BFCD9CD475AD5"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b695ca94b0b4c3825450d24e027a79bc80e211dc/Icons/u-he/zebra2.png"
        Summary       = "A virtual-analog synthesizer by u-he."
        PackageNameUrl = "Zebra_Legacy"
        PackageAlternativeUrlDirectory = "zebra2"
        ProductPageName = "zebra-legacy"
        Description   = "Zebra2: A synth of all stripes
Zebra2 is a sound-design playground. The powerful, high quality (but still CPU friendly) sound engine and the numerous sound sculpting tools make Zebra2 capable of a near-limitless range of new sounds and textures. A favourite amongst soundtrack composers, producers and sound designers, Zebra2 provides all the tools you need - the rest is up to you.
"
    },
    @{
        SoftwareName  = "ZebraHZ"
        Version       = "1.0.0"
        Revision      = "10409"
        Tags          = "audio clap vst synthesizer aax admin trial"
        Checksum      = "B5C62286D0AE38C384ACF8B1BD5495E1CEF169ED2C64ABBC2C5BFCD9CD475AD5"
        UrlIcon       = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c2c3274a3c3d3b1affe2e0293e2dfcef2a27d59f/Icons/u-he/zebrahz.png"
        Summary       = "A virtual-analog synthesizer by u-he."
        PackageNameUrl = "Zebra_Legacy"
        PackageAlternativeUrlDirectory = "zebra2"
        ProductPageName = "zebra-legacy"
        Description   = "ZebraHZ is an expanded version of Zebra2 made for a well known Hollywood composer featuring: 
- 8 extra filters based on Diva models
- 4 comb filter modules instead of 2
- 8 MSEGs instead of 2
- 24 modulation matrix slots instead of 12
- X/Y pads also appear as regular modulation sources
- 4 polyphonic compressors, one for each lane of the main grid
- 3 resonators with additional full-range band
- 'The Dark Zebra' soundset
"
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
    
    # Pre-process description variables to escape special characters
    $cleanDescription = $product.Description -replace "'", "''"
    $cleanDescriptionShared = $DescriptionShared -replace "'", "''"
    
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
    "Description='$cleanDescription' " +
    "DescriptionShared='$cleanDescriptionShared' " +
    "--force"

    Write-Debug $command
    Invoke-Expression $command

    $nuspecFilePath = "$PSScriptRoot\$($product.SoftwareName)\$($product.SoftwareName.ToLower()).nuspec"
    $nuspecDir = [System.IO.Path]::GetDirectoryName((Resolve-Path -Path $nuspecFilePath).Path)

    # Set the current location to the directory of the .nuspec file temporarily
    Push-Location -Path $nuspecDir

    # Get the relative path from the .nuspec directory to the shared scripts path
    #$relativePath = Resolve-Path -Path $SharedScriptsPath -Relative

    # Replace remaining variables in .nuspec file and create package
    # $nuspecContent = (Get-Content -Path $nuspecFilePath -Raw) `
    #     -replace '\$sharedscripts\$', $relativePath `
    #     -replace '\\+', '\'

    $nuspecContent = [System.IO.File]::ReadAllText($nuspecFilePath, [System.Text.Encoding]::UTF8)
    $nuspecContent = $nuspecContent -replace '\\+', '\'

    # Check if NoNks is set and remove the NoNks parameter line from nuspec file
    if ($product.NoNks -eq $true) {
        $nuspecContent = $nuspecContent -replace '.*NoNks.*\r?\n', ''
    }

    [System.IO.File]::WriteAllText($nuspecFilePath, $nuspecContent, [System.Text.Encoding]::UTF8)

    # Return to the previous location
    Pop-Location
    
    choco pack $nuspecFilePath
}
