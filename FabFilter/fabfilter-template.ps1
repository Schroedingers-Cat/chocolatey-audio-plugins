param (
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path -Path $_ -PathType 'Container' })]
    [string]$SharedScriptsPath = "${PSScriptRoot}\..\SharedScripts"
)

$Author = "FabFilter"
$AuthorLowerNowhite = $Author.ToLower().Replace(" ", "")
$MaintainerName = "Schroedingers-Cat"
$DescriptionShared = "## Package Parameters
The following package parameters can be set:

* `/Vst2Path` - Set the path of the VST2 plugin directory to install the plugin(s) to. Leave empty or do not set if you want no VST2 plugins.

Note that the all of the installer''s plugin formats will always be available at ``C:\Program Files\FabFilter\[Product Name]\``.  

## Silent Install And Uninstall
FabFilter installers only have an unattended mode for the installer. This means that the installation will be automated but the installer window will still pop up on your machine (without manual interaction necessary).  
FabFilter uninstallers have no support for unattended mode and require user interaction to proceed.
"

# Use lower versions than the current to verify updating works
$products = @(
    @{
        SoftwareName = "Pro-Q 4"
        Version      = "4.00"
        Tags         = "eq dynamic equalizer filter vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-Q%204.jpg"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffproq4-manual.pdf"
        Url          = "https://www.fabfilter.com/downloads/ffproq400x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-q-4-equalizer-plug-in"
        Summary      = "A high-quality equalizer plug-in"
        Description  = "Top-quality EQ plug-in with perfect analog modeling, dynamic and spectral EQ, linear phase processing, and a gorgeous interface with unrivalled ease of use."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Pro-Q 3"
        Version      = "3.00"
        Tags         = "eq dynamic equalizer filter vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-Q%203.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffproq3-manual.pdf"
        Url          = "https://www.fabfilter.com/downloads/ffproq300x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-q-4-equalizer-plug-in"
        Summary      = "A high-quality equalizer plug-in"
        Description  = "Top-quality EQ plug-in with perfect analog modeling, dynamic EQ, linear phase processing, and a gorgeous interface with unrivalled ease of use."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Pro-Q 2"
        Version      = "2.00"
        Tags         = "eq equalizer filter vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-Q%202.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffproq2-manual.pdf"
        Url          = "https://www.fabfilter.com/downloads/ffproq200x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-q-4-equalizer-plug-in"
        Summary      = "A high-quality equalizer plug-in"
        Description  = "Top-quality EQ plug-in with perfect analog modeling, linear phase processing, and a gorgeous interface with unrivalled ease of use."
        Platforms    = @('x64','x86')
    },
    # @{
    #     SoftwareName = "Pro-Q"
    #     Version      = "1.00"
    #     Tags         = "eq equalizer filter vst aax audio mixing mastering recording trial"
    #     Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
    #     UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-Q.png"
    #     UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffproq-manual.pdf"
    #     Url          = "https://www.fabfilter.com/downloads/ffproq100x64.exe"
    #     UrlProduct   = "https://www.fabfilter.com/products/pro-q-4-equalizer-plug-in"
    #     Summary      = "A high-quality equalizer plug-in"
    #     Description  = "Top-quality EQ plug-in with perfect analog modeling, linear phase processing, and a gorgeous interface with unrivalled ease of use."
    #     Platforms    = @('x64','x86')
    # },
    @{
        SoftwareName = "Pro-R 2"
        Version      = "2.00"
        Tags         = "reverb vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-R%202.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffpror2-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffpror200x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-r-2-reverb-plug-in"
        Summary      = "A high-end reverb plug-in"
        Description  = "High-end reverb plug-in with both vintage and natural sound, musical controls, and innovations like the unique Decay Rate EQ to shape the reverb''s character."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Pro-R"
        Version      = "1.00"
        Tags         = "reverb vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-R.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffpror-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffpror100x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-r-2-reverb-plug-in"
        Summary      = "A high-end reverb plug-in"
        Description  = "High-end reverb plug-in with both vintage and natural sound, musical controls, and innovations like the unique Decay Rate EQ to shape the reverb''s character."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Pro-L 2"
        Version      = "2.00"
        Tags         = "limiter vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-L%202.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffprol2-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffprol200x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-l-2-limiter-plug-in"
        Summary      = "A true-peak limiter plug-in"
        Description  = "Feature-packed true peak limiter plug-in, with multiple advanced limiting algorithms and extensive level and loudness metering."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Pro-L"
        Version      = "1.00"
        Tags         = "limiter vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-L.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffprol-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffprol100x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-l-2-limiter-plug-in"
        Summary      = "A high-quality limiter plug-in"
        Description  = "Feature-packed true peak limiter plug-in, with multiple advanced limiting algorithms and extensive level and loudness metering."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Pro-C 2"
        Version      = "2.00"
        Tags         = "compressor vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-C%202.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffproc2-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffproc200x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-c-2-compressor-plug-in"
        Summary      = "A high-quality compressor plug-in"
        Description  = "Professional compressor plug-in with versatile side chain and routing options, high-quality sound and an innovative interface."
        Platforms    = @('x64','x86')
    },
    # @{
    #     SoftwareName = "Pro-C"
    #     Version      = "1.00"
    #     Tags         = "compressor vst aax audio mixing mastering recording trial"
    #     Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
    #     UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-C.png"
    #     UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffproc-manual.pdf"
    #     Url          = "https://cdn-b.fabfilter.com/downloads/ffproc100x64.exe"
    #     UrlProduct   = "https://www.fabfilter.com/products/pro-c-2-compressor-plug-in"
    #     Summary      = "A high-quality compressor plug-in"
    #     Description  = "Professional compressor plug-in with versatile side chain and routing options, high-quality sound and an innovative interface."
    #     Platforms    = @('x64','x86')
    # },
    @{
        SoftwareName = "Pro-MB"
        Version      = "1.00"
        Tags         = "multiband compressor expander dynamics vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-MB.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffpromb-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffpromb100x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-mb-multiband-compressor-plug-in"
        Summary      = "Professional multiband compressor and expander plug-in"
        Description  = "Powerful multiband compressor/expander plug-in with all the expert features you need, combining exceptional sound quality with great interface workflow."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Pro-DS"
        Version      = "1.00"
        Tags         = "de-esser vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-DS.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffprods-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffprods100x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-ds-de-esser-plug-in"
        Summary      = "Intelligent de-esser plug-in"
        Description  = "Highly intelligent and transparent de-essing plug-in, perfect for processing single vocal tracks as well as entire mixes."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Pro-G"
        Version      = "1.00"
        Tags         = "gate dynamics vst clap aax audio mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Pro-G.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffprog-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffprog100x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/pro-g-gate-expander-plug-in"
        Summary      = "Flexible gate/expander plug-in"
        Description  = "Highly flexible gate/expander plug-in with advanced side chain options and precise metering."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Saturn 2"
        Version      = "2.00"
        Tags         = "multiband distortion saturation vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Saturn%202.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffsaturn2-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffsaturn200x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/saturn-2-multiband-distortion-saturation-plug-in"
        Summary      = "Multiband distortion/saturation plug-in"
        Description  = "Multiband distortion, saturation and amp modeling plug-in, with lots of modulation options."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Saturn"
        Version      = "1.00"
        Tags         = "multiband distortion saturation vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Saturn.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffsaturn-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffsaturn100x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/saturn-2-multiband-distortion-saturation-plug-in"
        Summary      = "Multiband distortion/saturation plug-in"
        Description  = "Multiband distortion, saturation and amp modeling plug-in, with lots of modulation options."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Timeless 3"
        Version      = "3.00"
        Tags         = "delay vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Timeless%203.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/fftimeless3-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/fftimeless300x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/timeless-3-delay-plug-in"
        Summary      = "Vintage tape delay plug-in"
        Description  = "Ultra-flexible tape delay plug-in with time stretching, top quality filters and drag-and-drop modulation."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Timeless 2"
        Version      = "2.00"
        Tags         = "delay vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Timeless%202.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/fftimeless2-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/fftimeless200x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/timeless-3-delay-plug-in"
        Summary      = "Vintage tape delay plug-in"
        Description  = "Ultra-flexible tape delay plug-in with time stretching, top quality filters and drag-and-drop modulation."
        Platforms    = @('x64','x86')
    },
    # @{
    #     SoftwareName = "Timeless"
    #     Version      = "1.00"
    #     Tags         = "delay vst audio creative trial"
    #     Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
    #     UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Timeless.png"
    #     UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/fftimeless-manual.pdf"
    #     Url          = "https://cdn-b.fabfilter.com/downloads/fftimeless100x64.exe"
    #     UrlProduct   = "https://www.fabfilter.com/products/timeless-3-delay-plug-in"
    #     Summary      = "Vintage tape delay plug-in"
    #     Description  = "Ultra-flexible tape delay plug-in with time stretching, top quality filters and drag-and-drop modulation."
    #     Platforms    = @('x86')
    # },
    @{
        SoftwareName = "Volcano 3"
        Version      = "3.00"
        Tags         = "filter vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Volcano%203.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffvolcano3-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffvolcano300x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/volcano-3-filter-plug-in"
        Summary      = "Vintage filter plug-in"
        Description  = "Filter effect plug-in with smooth, vintage-sounding filters and endless modulation possibilities."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Volcano 2"
        Version      = "2.00"
        Tags         = "filter vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Volcano%202.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffvolcano2-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffvolcano200x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/volcano-3-filter-plug-in"
        Summary      = "Vintage filter plug-in"
        Description  = "Filter effect plug-in with smooth, vintage-sounding filters and endless modulation possibilities."
        Platforms    = @('x64','x86')
    },
    # @{
    #     SoftwareName = "Volcano"
    #     Version      = "1.00"
    #     Tags         = "filter vst audio creative trial"
    #     Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
    #     UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/9255925c5da6b9b8ccd09c23ceb6e2d750332dc8/Icons/FabFilter/Volcano.png"
    #     UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffvolcano-manual.pdf"
    #     Url          = "https://cdn-b.fabfilter.com/downloads/ffvolcano100x64.exe"
    #     UrlProduct   = "https://www.fabfilter.com/products/volcano-3-filter-plug-in"
    #     Summary      = "Vintage filter plug-in"
    #     Description  = "Filter effect plug-in with smooth, vintage-sounding filters and endless modulation possibilities."
    #     Platforms    = @('x86')
    # },
    @{
        SoftwareName = "Twin 3"
        Version      = "3.00"
        Tags         = "synthesizer vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Twin%203.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/fftwin3-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/fftwin300x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/twin-3-synthesizer-plug-in"
        Summary      = "Powerful synthesizer plug-in"
        Description  = "Powerful synthesizer plug-in with the best possible sound quality, a high quality effect section and an ultra-flexible modulation system."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Twin 2"
        Version      = "2.00"
        Tags         = "synthesizer vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Twin%202.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/fftwin2-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/fftwin200x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/twin-3-synthesizer-plug-in"
        Summary      = "Powerful synthesizer plug-in"
        Description  = "Powerful synthesizer plug-in with the best possible sound quality, a high quality effect section and an ultra-flexible modulation system."
        Platforms    = @('x64','x86')
    },
    # @{
    #     SoftwareName = "Twin"
    #     Version      = "1.00"
    #     Tags         = "synthesizer vst audio creative trial"
    #     Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
    #     UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/9255925c5da6b9b8ccd09c23ceb6e2d750332dc8/Icons/FabFilter/Twin.png"
    #     UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/fftwin-manual.pdf"
    #     Url          = "https://cdn-b.fabfilter.com/downloads/fftwin100x64.exe"
    #     UrlProduct   = "https://www.fabfilter.com/products/twin-3-synthesizer-plug-in"
    #     Summary      = "Powerful synthesizer plug-in"
    #     Description  = "Powerful synthesizer plug-in with the best possible sound quality, a high quality effect section and an ultra-flexible modulation system."
    #     Platforms    = @('x86')
    # },
    @{
        SoftwareName = "One"
        Version      = "1.00"
        Tags         = "synthesizer vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c2bdff4d41dcff6286653e3b7fdbb6c99374b203/Icons/FabFilter/One.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffone-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffone300x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/one-basic-synthesizer-plug-in"
        Summary      = "Basic synthesizer plug-in"
        Description  = "Basic synthesizer plug-in with just one oscillator, but with perfectly fine-tuned controls and the best possible sound and filter quality."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Simplon"
        Version      = "1.00"
        Tags         = "filter vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Simplon.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffsimplon-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffsimplon100x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/simplon-basic-filter-plug-in"
        Summary      = "Basic filter plug-in"
        Description  = "Basic and easy to use filter plug-in with two high-quality multi-mode filters and an interactive filter display."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Micro"
        Version      = "1.00"
        Tags         = "filter vst clap aax audio creative trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/575d34a8c9c15a08182c49a3b10f803c7c7809b0/Icons/FabFilter/Micro.png"
        UrlManual    = "https://www.fabfilter.com/downloads/pdf/help/ffmicro-manual.pdf"
        Url          = "https://cdn-b.fabfilter.com/downloads/ffmicro100x64.exe"
        UrlProduct   = "https://www.fabfilter.com/products/micro-mini-filter-plug-in"
        Summary      = "Mini filter plug-in"
        Description  = "Ultimate lightweight filter plug-in with a single high-quality filter including envelope follower modulation."
        Platforms    = @('x64','x86')
    },
    @{
        SoftwareName = "Total Bundle"
        Version      = "2020.01.01"
        Tags         = "filter dynamics delay synthesizer vst clap aax audio creative mixing mastering recording trial"
        Checksum     = "24228C5BF884C53C702AFBF593634CE28A4AE3E4D542138269ECCE03B48A8FCD"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c2bdff4d41dcff6286653e3b7fdbb6c99374b203/Icons/FabFilter/totalbundle.jpg"
        UrlManual    = "https://www.fabfilter.com/help"
        Url          = "https://cdn-b.fabfilter.com/downloads/fftotalbundlex64.exe"
        UrlProduct   = "https://www.fabfilter.com/products"
        Summary      = "All FabFilter plug-ins"
        Description  = "All FabFilter plug-ins in one package."
        Platforms    = @('x64','x86')
    }
)

foreach ($product in $products) {
    foreach ($platform in $product.Platforms) {
        $BaseNameWithPlatformNice = $product.SoftwareName + " (" + $platform + ")"
        $PackageId = $product.SoftwareName.Replace(" ", "-").ToLower()
        $PackageNameNoWhite = $PackageId.Replace(" ", "").Replace("-", "").ToLower()
    
        $VersionChoco = $product.Version.Insert(3, ".")
        if ($product.SoftwareName -eq "Total Bundle") {
            $VersionChoco = $product.Version
        }
    
        $SoftwareNameWithoutVersion = $product.SoftwareName -replace '\d+$', ''
        $SoftwareNameUninstall += $product.Version
        if ($platform -eq "x86") {
            $SoftwareNameUninstall += " (32bit)"
        }

        $PlatformLowerNowhite = $platform.Replace(" ", "").Replace("-", "").ToLower()

        $UrlPlatform = $product.Url
        if ($platform -eq "x86") {
            $UrlPlatform = $UrlPlatform.Replace("x64.exe", ".exe")
        }
        $InstallerPlatformSuffix = ""
        if ($platform -eq "x86") {
            $InstallerPlatformSuffix += ".exe"
        } elseif ($platform -eq "x64") {
            $InstallerPlatformSuffix += "x64.exe"
        }

        $UninstallerSuffix = $product.Version
        if ($product.SoftwareName -eq "Total Bundle") {
            $UninstallerSuffix = ""
        }
        if ($platform -eq "x86") {
            if ($UninstallerSuffix -eq '') {
                $UninstallerSuffix = "(32-bit)"
            }
            else {
                $UninstallerSuffix = $UninstallerSuffix + " (32-bit)"
            }
        }

        # Construct the choco new command as a single line string
        $command = "choco new '$($BaseNameWithPlatformNice)' -t fabfilter.template " +
        "Version='$($product.Version)' " +
        "VersionChoco='$($VersionChoco)' " +
        "SoftwareNameUninstall='$($SoftwareNameUninstall)' " +
        "SoftwareNameWithoutVersion='$($SoftwareNameWithoutVersion)' " +
        "Author='$($Author)' " +
        "AuthorLowerNowhite='$($AuthorLowerNowhite)' " +
        "MaintainerName='$($MaintainerName)' " +
        "Tags='$($product.Tags)' " +
        "Checksum='$($product.Checksum)' " +
        "UrlIcon='$($product.UrlIcon)' " +
        "UrlManual='$($product.UrlManual)' " +
        "UrlProduct='$($product.UrlProduct)' " +
        "Summary='$($product.Summary)' " +
        "Url='$($UrlPlatform)' " +
        "PackageId='$($PackageId)' " +
        "PackageNameNoWhite='$($PackageNameNoWhite)' " +
        "PlatformLowerNowhite='$($PlatformLowerNowhite)' " +
        "InstallerPlatformSuffix='$($InstallerPlatformSuffix)' " +
        "UninstallerSuffix='$($UninstallerSuffix)' " +
        "Description='$($product.Description)' " +
        "DescriptionShared='$($DescriptionShared)' " +
        "--force"
    
        Write-Debug $command
        Invoke-Expression $command
    
        $nuspecFilePath = "$PSScriptRoot\$($BaseNameWithPlatformNice)\$($BaseNameWithPlatformNice.ToLower()).nuspec"
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
        
        #choco pack $nuspecFilePath
    }
}
