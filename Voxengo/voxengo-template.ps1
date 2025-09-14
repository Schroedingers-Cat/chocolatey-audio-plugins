param (
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path -Path $_ -PathType 'Container' })]
    [string]$SharedScriptsPath = "${PSScriptRoot}\..\SharedScripts"
)

$Author = "Voxengo"
$AuthorLowerNowhite = $Author.ToLower().Replace(" ", "")
$MaintainerName = "Schroedingers-Cat"
$DescriptionShared = @"
## Installer Arguments
If you want to select which formats and other components to install, use the following parameter:
``````
choco install voxengo-package -ia '/COMPONENTS=shortcuts,guides,vst2_64 /Dir=C:\Program Files\Audio\Voxengo\Package'
``````

Components:
* ``shortcuts`` - Install start menu shortcuts to the user guides
* ``guides``    - Install the user guide files
* ``vst2_32``   - Install the x86 (32 bit) VST2 version
* ``vst2_64``   - Install the x64 (64 bit) VST2 version
* ``vst3_32``   - Install the x86 (32 bit) VST3 version
* ``vst3_64``   - Install the x64 (64 bit) VST3 version
* ``aax_64``    - Install the x64 (64 bit) AAX version
* ``aax_32``    - Install the x86 (32 bit) AAX version

Others:
* ``Dir`` - Set the directory to install the guide files to

## Package Parameters

* ``/VST2x64Path:`` - Path of the x64 (64 bit) VST2 plugins
* ``/VST2x86Path:`` - Path of the x86 (32 bit) VST2 plugins
* ``/CompanyPath:`` - More comfortable way than /Dir because this one gets the package name automatically postfixed to the path so this parameter can be shared with other Voxengo packages

For example:
``````powershell
choco install voxengo-package --package-parameters ""'/VST2x64Path:C:\Program Files\Common Files\VST2 /CompanyPath:C:\Program Files\Audio\Voxengo'""
``````
"@

# Use lower versions than the current to verify updating works
$products = @(
    @{
        SoftwareName = "AnSpec"
        Version      = "1.6"
        Tags         = "analog-style spectrum analyser vst aax audio mixing mastering recording free"
        Checksum   = "67edfe9c24ca61c71fe7d62d1f19d42c8eff74299f0cdceff1898486a7e127f4"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a898fc274263076167e108119920b153ec88ae4e/Icons/Voxengo/anspec.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoAnSpec_en.pdf/getbyname/Voxengo%20AnSpec%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoAnSpec_17_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "An analog-style spectrum analyser plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "AnSpec is an analog-style one/third-octave spectrum analyzer AAX, AU and VST plugin for professional music production applications.  It was designed to be a handy visual feedback tool for those who like visual smoothness and easiness of use of analog analyzers.  AnSpec also provides peak level indication."
    },
    @{
        SoftwareName = "Beeper"
        Version      = "2.11"
        Tags         = "noise beep vst aax audio mixing mastering recording free"
        Checksum   = "2f255b2092a791e1b0daef0f64c25e95ecd8b4446a92bf2c30973a76b174c033"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/92dc875608582702dde2402e5b40a29e7a37f2c7/Icons/Voxengo/beeper.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoBeeper_en.pdf/getbyname/Voxengo%20Beeper%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoBeeper_212_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A plugin for VST2/3 and AAX compatible hosts by Voxengo to insert beeps and noise into your audio."
        Description  = "Beeper is an auxiliary audio processing AAX, AudioUnit and VST plugin which you can use to insert short beep, noise burst or silence signals to any sound material.  This plugin may help you protect your work from unauthorized use.  It is safe to apply this plugin to any mission-critical material because plugin does not perform any processing on the audio between the inserted signals.  

You may specify signal's duration, beep frequency, signal's loudness, period between signals and the amount of random variation of all parameters."
    },
    @{
        SoftwareName = "BMS"
        Version      = "2.5"
        Tags         = "bass management vst aax audio mixing mastering recording surround"
        Checksum   = "334b8f1446d74022818fcbe55b5924d06d9619d5ecc1f5d366b813275d1ed981"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/f8bb5d95b23b7acf235c79dbe249d4ed85b74923/Icons/Voxengo/bms.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoBMS_en.pdf/getbyname/Voxengo%20BMS%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoBMS_26_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A bass management plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "BMS is a bass management system AAX, AudioUnit and VST plugin for professional surround sound applications.  BMS is able to extract and manipulate low-frequency content of non-LFE channels in up to 7.1 surround configurations.
The main purpose of BMS is to simplify evaluation of low-frequency content present in non-LFE channels during mastering.  At the same time, it is possible to mix extracted low-frequency content to the LFE (Low Frequency Effects) channel.  An option to remove the extracted signal from non-LFE channels is also available.
In BMS you can specify a desired frequency of the crossover filter, and adjust its steepness."
    },
    @{
        SoftwareName = "Boogex"
        Version      = "3.6"
        Tags         = "guitar amp vst aax audio mixing mastering recording free"
        Checksum   = "fe9dda24f909a041829a1b55fae8f05a84329a31ad2eb8c1711ea18b3b4f525a"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c9bf5e6539617e9629eaf8de7f8c3831aa77e60d/Icons/Boogex.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoBoogex_en.pdf/getbyname/Voxengo%20Boogex%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoBoogex_37_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A guitar amp plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Boogex is a guitar amplifier AAX, AU, and VST plugin with a variety of sound shaping features for professional music production applications.  With Boogex it is possible to get a heavy distorted sound as well as slight jazzy saturation sound.  Boogex is also able to apply any speaker cabinet impulse response (selection of built-in impulses is available).  The processing latency is close to zero making it possible to use Boogex for real-time guitar processing.  Boogex also includes reverberation module derived from Voxengo OldSkoolVerb reverb."
    },
    @{
        SoftwareName = "Correlometer"
        Version      = "1.7"
        Tags         = "analog-style multi-band correlation meter vst aax audio mixing mastering recording free"
        Checksum   = "1ddb64bf5e14e05b08ca76ad047b29adeafa65abce75eeea060e13bc5844d363"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/021dd94d244c35fc236e296b4f84f8686310e14f/Icons/Voxengo/Correlometer.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoCorrelometer_en.pdf/getbyname/Voxengo%20Correlometer%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoCorrelometer_18_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "Correlometer is a free analog-style stereo multi-band correlation meter AudioUnit, AAX and VST plugin for professional music production applications.  It is based on correlation meter found in PHA-979 phase-alignment plugin.

Multi-band correlation meter is an advanced way to check for presence of out-of-phase elements in the mix.  Broadband correlation metering reports overall phase issues and may misrepresent problems present in select spectral bands, while multi-band correlation meter easily highlights problems present in mid to high frequencies that are not easily heard by ear, but may still reduce clarity of the mix.  Another application of multi-band correlation metering is phase- and time-aligning of channels and tracks, especially bass and bass-drum pairs, guitar mic and D.I. source pairs, two-microphone stereo recordings, etc.

Correlometer can display 4 to 64 individual spectral bands, with adjustable band quality factor that controls the degree of band's selectivity.  Averaging time of correlation estimator can be adjusted.  Correlometer supports side-chain inputs for easy correlation estimation between separate audio tracks."
    },
    @{
        SoftwareName = "CRTIV Tape Bus"
        Version      = "1.6"
        Tags         = "tape saturation vst aax audio mixing mastering recording trial"
        Checksum   = "b52ed7e0aaf0bf4abbb69163a3fc1e3b1e0e528b0244db304ab51bbee37d557e"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/34cc39f424c1c8e3f089e92b2bc546ddc90420f7/Icons/Voxengo/CRTIVTapeBus.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoCRTIVTapeBus_en.pdf/getbyname/Voxengo%20CRTIV%20Tape%20Bus%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoCRTIVTapeBus_17_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A tape saturation plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "CRTIV Tape Bus plug-in for professional music production applications recreates characteristic elements of the reel-to-reel tape sound.  This includes saturation, modulation noise and smearing effects which are known for the analog feel they bring to audio recordings.  This plug-in also applies a selected impulse response taken by us from the existing tape machines."
    },
    @{
        SoftwareName = "Crunchessor"
        Version      = "2.18"
        Tags         = "compressor vst aax audio mixing mastering recording trial"
        Checksum   = "dd540d082da875864b9f88e6bc5c6adc2f683b30a361062d9765e77a446b590a"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/f62cb1ca719acbe54b61fdd50b6f6542a68e1179/Icons/Voxengo/Crunchessor.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoCrunchessor_en.pdf/getbyname/Voxengo%20Crunchessor%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoCrunchessor_219_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A compressor plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Crunchessor is a general-purpose track compressor AU and VST plugin for professional audio production applications.  One of its main advantages is the ease of tuning, which at the same time instantly delivers an excellent sonic performance.  Another remarkable feature of Crunchessor is its valve-type processing, which is applied in parallel to compression.  This makes Crunchessor an ideal choice for musicians and producers who are fond of analog compression sound and its warmness."
    },
    @{
        SoftwareName = "CurveEQ"
        Version      = "3.13"
        Tags         = "matching eq equalizer vst aax audio mixing mastering recording trial"
        Checksum   = "8d021816e7bc0bb09453894c82c64413786d3147fcf27bc67748987c0e9404c3"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/f26b817b8769d05ab3b1574953533571380eff0c/Icons/Voxengo/CurveEQ.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoCurveEQ_en.pdf/getbyname/Voxengo%20CurveEQ%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoCurveEQ_314_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A matching eq plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Linear-phase spline equalizer AAX, AU and VST plugin. Features high-quality spectrum matching and ultra-clean sound. Ideal for mastering applications."
    },
    @{
        SoftwareName = "DeftCompressor"
        Version      = "1.12"
        Tags         = "vst aax audio mixing mastering recording trial"
        Checksum   = "7f0fa750e43ff4a1058fc7065d963b5eca526d483f4abaf11b512920f6832dca"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/7ea08b47f0dd6109648a82668434f84bc7e7c733/Icons/Voxengo/DeftCompressor.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoDeftCompressor_en.pdf/getbyname/Voxengo%20Deft%20Compressor%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoDeftCompressor_113_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A compressor plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Deft Compressor is an audio signal compressor AAX, AU and VST plugin for professional audio production applications. The characteristic feature of this compressor is its ability to produce slim and slick sounding compression, with intelligibility enhancement effect. Such result is achieved by compressor's timing function that closely resembles the S-curve (sigmoid curve) on both attack and release stages.  S-curve timing function also helps compressor to sound warm and clean at most settings."
    },
    @{
        SoftwareName = "Drumformer"
        Version      = "1.10"
        Tags         = "vst aax audio mixing mastering recording transient trial"
        Checksum   = "4e642f4a6023952e139b95f5be44e5fc9434f781c9716d10f32aa1d77c5c0ab2"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/59978c9ad18efd333ac9840f55a2c852d66d22f6/Icons/Drumformer.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoDrumformer_en.pdf/getbyname/Voxengo%20Drumformer%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoDrumformer_111_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A multiband drum and master track dynamics processing plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Drumformer is a multiband drum and master track dynamics processing AU and VST plugin for professional music and audio production applications.  Drumformer was designed to be a comprehensive solution for the broadest range of sound processing tasks, allowing you to easily implement almost any dynamics processing idea you may have."
    },
    @{
        SoftwareName = "EBusLim"
        Version      = "1.9"
        Tags         = "brickwall limiter vst aax audio mixing mastering recording trial"
        Checksum   = "dca57f794068ce92dc38d3006b10ae30823f285e8070cbbbe14c443aa30b970d"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/95b88f69b335cbcc81150c32db986cfb3924be9b/Icons/Voxengo/EBusLim.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoEBusLim_en.pdf/getbyname/Voxengo%20EBusLim%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoEBusLim_110_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A brickwall limiter plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "EBusLim is a brickwall peak limiter and loudness maximization plug-in for professional music production applications.  EBusLim implements a single EL-4-based limiter mode originally designed in Elephant mastering limiter plug-in.  This mode is suitable for bus, drum bus, master bus and track processing.  The design idea behind EBusLim is to produce an extremely easy-to-use yet effective limiter."
    },
    @{
        SoftwareName = "Elephant"
        Version      = "5.4"
        Tags         = "transparent limiter vst aax audio mixing mastering recording trial"
        Checksum   = "78ad209e9c1a0efd1cb7a4b5c677fdf93db124c22ce535cdd009aa3cb8c9b079"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c9bf5e6539617e9629eaf8de7f8c3831aa77e60d/Icons/Elephant.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoElephant_en.pdf/getbyname/Voxengo%20Elephant%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoElephant_55_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A transparent mastering limiter plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Voxengo Elephant is a mastering limiter AAX, AU and VST plugin for professional music production applications.  The most remarkable feature of this signal limiter is its sonic transparency.  Elephant brings sound limiting and loudness maximization without audible fuzz and pumping sonic artifacts."
    },
    @{
        SoftwareName = "GlissEQ"
        Version      = "3.17"
        Tags         = "matching eq equalizer vst aax audio mixing mastering recording trial"
        Checksum   = "04ffde119f5e8637fc648aad81ec4d391908750cfac504d450dfac00edbda5ba"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/4b058bfa533d8cb452734582a481ead77674625f/Icons/Voxengo/GlissEQ.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoGlissEQ_en.pdf/getbyname/Voxengo%20GlissEQ%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoGlissEQ_318_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A matching eq plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Dynamic equalizer AAX, AU and VST plugin with real-time cross-track spectrum analyzer.  Emphasizes transients boosting the life and dimension of your tracks."
    },
    @{
        SoftwareName = "HarmoniEQ"
        Version      = "2.10"
        Tags         = "harmonically-enhanced eq equalizer vst aax audio mixing mastering recording trial"
        Checksum   = "64a4ff628485aca5afb8bf8337cc6d64c35566fe2026e10c86480beca082d31d"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/34cc39f424c1c8e3f089e92b2bc546ddc90420f7/Icons/Voxengo/HarmoniEQ.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoHarmoniEQ_en.pdf/getbyname/Voxengo%20HarmoniEQ%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoHarmoniEQ_211_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A harmonically-enhanced eq plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "HarmoniEQ is a parametric, harmonically-enhanced equalizer AU and VST plugin for professional music production applications.  Harmonic enhancement HarmoniEQ applies to the sound is an inherent element of its overall sonic quality.  HarmoniEQ also features dynamic equalization modes that offer you a vast palette of sound-shaping capabilities, suitable for mastering."
    },
    @{
        SoftwareName = "Latency Delay"
        Version      = "2.9"
        Tags         = "latency delay vst aax audio mixing mastering recording free"
        Checksum   = "287ffdb03b75506ad8c8ccf3d0c3059963c0d9ac4bd4ae0e261f78d1c6ea135e"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/0916ad87f260c861ace358a1703b6f685dbce3b6/Icons/Voxengo/LatencyDelay.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoLatencyDelay_en.pdf/getbyname/Voxengo%20Latency%20Delay%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoLatencyDelay_210_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A latency delay plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Latency Delay is an auxiliary AAX, AU and VST plugin which allows you to compensate latency produced by any audio plugins, instruments and processes which produce latency but do not try to report it to the host audio application.  Latency Delay introduces 10000 samples latency itself and delays the audio signal by 10000 minus the specified amount of samples or milliseconds, thus eliminating the unreported latency.  Please note that host audio application should support the latency compensation itself for this plugin to function properly."
    },
    @{
        SoftwareName = "LF Max Punch"
        Version      = "1.14"
        Tags         = "bass booster vst aax audio mixing mastering recording trial"
        Checksum   = "2d0e9eadea7529b8477be3ca21035823cdeb3414d7c6e6f598a81af880fbd9b9"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a754fbeb7ed644820b52348da8835a0a13b4a37e/Icons/Voxengo/lfmaxpunch.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoLFMaxPunch_en.pdf/getbyname/Voxengo%20LF%20Max%20Punch%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoLFMaxPunch_115_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A bass booster plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Voxengo LF Max Punch is a professional audio effect AAX, AU and VST plugin for music and sounds where low-frequency thump and punch are most welcome, and where distortion is applied specifically to bring the bass sound to life.  LF Max Punch provides a low-frequency effect specially designed for serious contemporary music producers offering them a convenient tool for applying a smooth punch and oomph to audio tracks and sounds."
    },
    @{
        SoftwareName = "Marquis Compressor"
        Version      = "2.7"
        Tags         = "compressor vst aax audio mixing mastering recording trial"
        Checksum   = "2804819aa0050414a0858a5ae605e168e8f9b709dde4df1e68437d855d0254e5"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c9bf5e6539617e9629eaf8de7f8c3831aa77e60d/Icons/Marquis.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoMarquisCompressor_en.pdf/getbyname/Voxengo%20Marquis%20Compressor%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoMarquisCompressor_28_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A compressor plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Marquis Compressor is a universal compressor AAX, AU and VST plugin for professional music production applications.  You'll find a very smooth compression performance in this compressor, coupled with a harmonically-rich sound, both suitable for mixing and mastering.  Being universal this compressor can be used on a wide range of sound material: individual tracks, stems and mixes, producing clean or colored sound."
    },
    @{
        SoftwareName = "Marvel GEQ"
        Version      = "1.14"
        Tags         = "linear-phase eq equalizer vst aax audio mixing mastering recording free"
        Checksum   = "26161336aff18003efd0d24bb27540a38bbda30ac8c2cdf0ed01f63f52561df5"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/0916ad87f260c861ace358a1703b6f685dbce3b6/Icons/Voxengo/MarvelGeq.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoMarvelGEQ_en.pdf/getbyname/Voxengo%20Marvel%20GEQ%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoMarvelGEQ_115_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A linear-phase eq plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Marvel GEQ is a free linear-phase 16-band graphic equalizer AAX, AU and VST plugin that offers you a mastering-grade sound quality."
    },
    @{
        SoftwareName = "MSED"
        Version      = "3.10"
        Tags         = "MS decoder encoder vst aax audio mixing mastering recording free"
        Checksum   = "7a9b6e31db9062c6d3c076799559c9348d595919593b617ad39f08fa77e4f3c4"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/f2d59746af4361a9ad110430174ccc6e181efe11/Icons/Voxengo/MSED.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoMSED_en.pdf/getbyname/Voxengo%20MSED%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoMSED_311_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "An MS encoder and decoder plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "MSED is a professional audio encoder-decoder AAX, AU and VST plugin for mid-side processing which is able to encode (split) the incoming stereo signal into two components: mid-side pair, and vice versa: decode mid-side signal pair into stereo signal."
    },
    @{
        SoftwareName = "OldSkoolVerb"
        Version      = "2.12"
        Tags         = "classic reverb vst aax audio mixing mastering recording free"
        Checksum   = "54d3443fd040c1518e77fcfc41ae40936b983ffbc17b50e2c3867bfc71af7c96"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/0916ad87f260c861ace358a1703b6f685dbce3b6/Icons/Voxengo/OldSkoolVerb.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoOldSkoolVerb_en.pdf/getbyname/Voxengo%20OldSkoolVerb%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoOldSkoolVerb_213_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A classic reverb plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "OldSkoolVerb is a freeware algorithmic reverberation AU and VST plugin for professional music production applications.  This plugin implements a kind of classic stereo reverb algorithm which is technically simple yet optimal.  It also produces a very clear spatial image that blends well with the mix."
    },
    @{
        SoftwareName = "OldSkoolVerb Plus"
        Version      = "1.5"
        Tags         = "classic reverb vst aax audio mixing mastering recording trial"
        Checksum   = "db7b3168ee0f00f76b5dac6b0289531817dc8087c7c23739cb78bd1d00d3e135"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/f93ae318aaee032b8c9ac99b2117f08556fe1c8d/Icons/Voxengo/OldSkoolVerbPlus.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoOldSkoolVerbPlus_en.pdf/getbyname/Voxengo%20OldSkoolVerb%20Plus%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoOldSkoolVerbPlus_16_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A classic reverb plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "OldSkoolVerb Plus is an algorithmic reverberation plug-in for professional music production applications.  This plug-in is an extended version of freeware OldSkoolVerb plug-in.  OldSkoolVerb Plus plug-in implements a kind of classic stereo reverb algorithm which is technically simple yet optimal.  It produces a very clear spatial image that blends well with the mix."
    },
    @{
        SoftwareName = "OVC-128"
        Version      = "1.12"
        Tags         = "fft spectrum analyser vst aax audio mixing mastering recording trial"
        Checksum   = "ae5d38376605637bede6fffab0d7e905c8d02b490a32cbb7f5495b83792a7807"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/59978c9ad18efd333ac9840f55a2c852d66d22f6/Icons/OVC-128.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoOVC128_en.pdf/getbyname/Voxengo%20OVC-128%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoOVC128_113_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A massively oversampled soft/hard clipping effect plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "OVC-128 is a massively-oversampled soft/hard clipping effect AudioUnit, AAX and VST plugin for professional music production applications.  A common use for this plug-in is hard-clipping before the final peak limiter.  This is an effective approach in contemporary electronic music when loudness is boosted using a clipper plug-in while minor excessive peaks are absorbed by a final peak limiter that applies no additional gain itself."
    },
    @{
        SoftwareName = "Overtone GEQ"
        Version      = "1.16"
        Tags         = "band-harmonic eq equalizer vst aax audio mixing mastering recording free"
        Checksum   = "2df43ed20f0f2fd5bc8177be51f7c50e5d8c5b5543f7ad8ee4ba58e3de1b8739"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/943f21ad24fec96e5c6802ccedcd2805be8ed5e0/Icons/Voxengo/OvertoneGEQ.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoOvertoneGEQ_en.pdf/getbyname/Voxengo%20Overtone%20GEQ%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoOvertoneGEQ_117_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A band-harmonic eq plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Overtone GEQ is 7-band harmonic (overtone) graphic equalizer AU and VST plugin with multi-channel operation support (supporting up to 8 input/output channels, host setup-dependent).  Overtone GEQ offers extensive internal channel routing capabilities, and supports mid/side channel processing."
    },
    @{
        SoftwareName = "Peakbuster"
        Version      = "1.6"
        Tags         = "peakbuster harmonic enhancer transient booster vst aax audio mixing mastering recording trial"
        Checksum   = "8024afce186c221f8dd78052187fb286e54f10c6e182a50e80527f196318611d"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/6a3f73f0e302d26fdc96220f8961483001ab0d92/Icons/Voxengo/peakbuster.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoPeakbuster_en.pdf/getbyname/Voxengo%20Peakbuster%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoPeakbuster_17_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "An automatic spectral balancing audio plugin."
        Description  = "Peakbuster is an attack-phase boosting and harmonic enhancement AU, AAX, and VST plugin for professional music and sound production applications.  Peakbuster is a multi-band transient enhancer effect plug-in that uses an advanced automatic algorithm.  Peakbuster stands out from the competition in its ability to always sound natural, even on a full-spectrum master bus.  The strength of the effect depends on the material being processed: the algorithm masterfully analyses dynamics of the sound it processes, and applies boosting in quantities that are exactly right.  Moreover, the algorithm has a suitably fast reaction time making its adjustments sound fluid, not over the place."
    },
    @{
        SoftwareName = "PHA-979"
        Version      = "2.11"
        Tags         = "phase shift vst aax audio mixing mastering recording trial"
        Checksum   = "173b955a10e715551782a3793e48a35d748364ebf42453fb6149737678f0139e"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/84e4652ba31753ce18f5b4a9dc6032a80afe4e73/Icons/Voxengo/pha-979.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoPHA979_en.pdf/getbyname/Voxengo%20PHA-979%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoPHA979_212_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A phase shift plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "PHA-979 is a professional audio AU and VST plugin which allows you to apply an arbitrary phase shift to sound material.  What is meant by the phase shift here is simultaneous shifting of all frequencies across the active frequency range of the signal by the given value in degrees.  This is achieved by linear-phase design."
    },
    @{
        SoftwareName = "Polysquasher3"
        Version      = "3.4"
        Tags         = "compressor transparent vst aax audio mixing mastering recording trial"
        Checksum   = "23452075eb7628a8f0f47d99154cad12c07bf92e0b7a713c328ea2285bce7f7b"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/50c955ad417fd880e9446c94e7189aab6c63645e/Icons/Voxengo/polysquasher.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoPolysquasher_en.pdf/getbyname/Voxengo%20Polysquasher%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoPolysquasher_35_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A mastering compressor plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Mastering compressor AAX, AU and VST plugin with transparent, tight and punchy sound.  An ideal choice for mix compression."
    },
    @{
        SoftwareName = "Powershaper"
        Version      = "1.4"
        Tags         = "saturation distortion overdrive vst aax audio mixing recording free"
        Checksum   = "f5f3d7c0c2707924322240963b8adefd40c6600be8dc83cd632690cc12d34e6f"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/f8bb5d95b23b7acf235c79dbe249d4ed85b74923/Icons/Voxengo/powershaper.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoPowershaper_en.pdf/getbyname/Voxengo%20Powershaper%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoPowershaper_15_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A saturation, distortion and overdrive plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Powershaper is a saturation, distortion and overdrive effect plug-in for professional music production applications.  Powershaper's approach to saturation is quite unique as it works in multi-stage manner utilizing dozens of saturation stages in a specified variation.  While Powershaper was designed to apply extreme saturation, it can be also used to boost presence of audio tracks subtly.

The flexibility of this saturation plug-in is most apparent when applying saturation to the drums: it is possible to dial settings that retain or even extend the punch while applying strong pleasant coloration and presence effect.

Powershaper can be used to apply saturation with good results to various sounds: vocals, drums, bass, guitars, synths, mixes."
    },
    @{
        SoftwareName = "PrimeEQ"
        Version      = "1.7"
        Tags         = "simple eq equalizer vst aax audio mixing mastering recording trial"
        Checksum   = "c5a415cb152e3e1de620c2cd4fc9d39a85dc0f4882b0cfd0528e06503877ac53"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c9bf5e6539617e9629eaf8de7f8c3831aa77e60d/Icons/PrimeEQ.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoPrimeEQ_en.pdf/getbyname/Voxengo%20PrimeEQ%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoPrimeEQ_18_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A simple eq plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "PrimeEQ is a parametric equalizer plug-in for professional music production applications.  PrimeEQ was designed to be the first equalizer to reach for when track or mix equalization is necessary: just insert the plug-in, put and drag the control points to the desired positions."
    },
    @{
        SoftwareName = "r8brain PRO"
        Version      = "2.11"
        Tags         = "audio mixing mastering recording samplerate conversion trial"
        Checksum   = "28b5d15aaf9d46cd7bba36cbf6a26d1f7c9c3f440abcf4c45d82888c6d3b1b59"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/ec679a5234d2ba0ef5dc8846d48cd399ccef1541/Icons/r8brainPro.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/Voxengor8brainPRO_en.pdf/getbyname/Voxengo%20r8brain%20PRO%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/Voxengor8brainPRO_212_Win64_setup.exe"
        Summary      = "An audio samplerate converter by Voxengo."
        Description  = "8brain PRO is a professional sample rate converter tool software designed to deliver an unprecedented sample rate conversion (SRC) quality.  Unlike other existing SRC algorithms available on the market, r8brain PRO implements sample rate conversion processing in its full potential: interpolation and decimation steps without exploiting any kind of simplifications; the signal is resampled in a multi-step manner using a series of least common multiple sample rates which makes conversion perfect - both in signal-to-noise and timing precision aspects.  Such whole number-factored SRC can be considered a golden standard in sample rate conversion as it is not subject to jitter and timing errors."
    },
    @{
        SoftwareName = "Shinechilla"
        Version      = "1.4"
        Tags         = "exciter vst aax audio mixing mastering recording free"
        Checksum   = "affeac4a8a50ea509ac5fc222270d2a8d3cf69a78fd9f6bbad181e048b20feec"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/da1f4c300588a341c9d88aa73c6a40a57a1547c9/Icons/Voxengo/shinechilla.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoShinechilla_en.pdf/getbyname/Voxengo%20Shinechilla%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoShinechilla_15_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "An exciter plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Voxengo Shinechilla is an experimental creative sound effect AU and VST plugin for professional sound and music production applications.  Shinechilla allows you to generate and blend 2nd, 3rd and 4th harmonics with the original dry sound.  The harmonic generation process offered by Shinechilla is quite unique on the plugin market since it produces almost no intermodulation distortion."
    },
    @{
        SoftwareName = "Shumovick"
        Version      = "2.1"
        Tags         = "creative dynamic noise-floor padding vst aax audio mixing recording trial"
        Checksum   = "408a1d29a4489c2f84646b4c3f77fcb28c5f73ed988641b1ef9b6cdabeeb9e64"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/4d9d73efa8d50ce3196901e49c4ba63818551a1a/Icons/Voxengo/Shumovick.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoShumovick_en.pdf/getbyname/Voxengo%20Shumovick%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoShumovick_22_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A creative noise-floor padding effect plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "CRTIV Shumovick AU, AAX, and VST plugin for professional music production applications produces a creative dynamic noise-floor padding effect.  This effect is most effective on beats and synth sounds used in electronic music production - EDM, hip-hop, and many others.  The noise-floor effect created by this plug-in is correlated to the spectral content of the sound being processed."
    },
    @{
        SoftwareName = "Sobor"
        Version      = "3.2"
        Tags         = "reverb vst aax audio mixing mastering recording trial"
        Checksum   = "7bd5eae4b77950e335a0bdedeb8e45671327fda6e5d7cf94eabe5438fc61f1d4"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/0d3b35cee8b9ccf97f0f419045f0ea519e6ed3c0/Icons/Voxengo/sobor.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoSobor_en.pdf/getbyname/Voxengo%20Sobor%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoSobor_33_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A reverb plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Sobor is a stereo reverberation effect AU, AAX, and VST plugin for professional music production applications.  This reverb plugin provides a wide palette of reverb spaces while requiring only a minimal effort to obtain useful results.  The tails created by this reverb are very dense and produce a well-defined spatialization.  Since the reverb uses a kind of true-stereo algorithm the panned sounds receive a good stereo field placement.  We believe Sobor provides one of the lushest and widest reverb tails available on the market.

Beside producing a shining reverb sound at medium and larger space settings, Sobor is equally great-sounding at ultra-small space settings, going as far as being able to imitate guitar cabinet sound at 100% wet setting.  Sobor can even be used to re-cabinet a bass-guitar sound yielding very natural results.

The early reflections placement and reverb levels are chosen automatically based on a pre-defined model that depends on the Size and Ambience parameters.  Additionally, the user may specify the Pre-Delay and Stereo width parameters.  Sobor is technically based on Feedback Delay Networks (FDNs) with the Hadamard matrix, and uses self-modulation techniques.

Sobor is great on any sound sources: vocals, synths, drums, mixes.  This reverb is a relatively CPU-demanding effect (it takes 7.5% of a single core of i7-7700K processor, at 44100 sample rate), for comfortable use it requires a higher-end processor."
    },
    @{
        SoftwareName = "Soniformer"
        Version      = "3.14"
        Tags         = "compressor multiband vst aax audio mixing mastering recording trial"
        Checksum   = "60c447f8768178156f269bf916516a018ce80c9a2d571a6950a32af92eadf5d8"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/d060b47e68199f26bb43fd71772f57e368825e52/Icons/Voxengo/Soniformer.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoSoniformer_en.pdf/getbyname/Voxengo%20Soniformer%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoSoniformer_315_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A multiband compressor plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Soniformer is a spectral mastering dynamics processor AAX, AU and VST plugin for professional music production applications.  During its operation, Soniformer splits incoming sound signal into 32 spectral bands.  This makes Soniformer a powerful and precise tool for mastering and sound restoration purposes."
    },
    @{
        SoftwareName = "Sound Delay"
        Version      = "1.13"
        Tags         = "precise technical delay vst aax audio mixing mastering recording free"
        Checksum   = "9ef273089973bb84d1f1c80122108c64288c549a9452fce2f6d969303a60e5ed"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/d3074aa9edac2b0df996376f6cd2467985046a8a/Icons/Voxengo/sounddelay.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoSoundDelay_en.pdf/getbyname/Voxengo%20Sound%20Delay%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoSoundDelay_114_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A precise technical delay plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Sound Delay is an auxiliary multi-channel signal delaying AAX, AU and VST plugin for professional audio applications.  You may specify delay time in both milliseconds and samples, with a high level of precision.  This plugin - being technical in its purpose - provides a basic signal delaying function only, without signal feedback or modulation capabilities."
    },
    @{
        SoftwareName = "SPAN"
        Version      = "3.21"
        Tags         = "fft spectrum analyser vst aax audio mixing mastering recording free"
        Checksum   = "25e3389d5cbe95b5b43ab2bab7f350a9c2f95002ee9811c7c68c9f206a96f556"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c9bf5e6539617e9629eaf8de7f8c3831aa77e60d/Icons/SPAN.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoSPAN_en.pdf/getbyname/Voxengo%20SPAN%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoSPAN_322_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "An fft spectrum analyser plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "SPAN is a free real-time fast Fourier transform audio spectrum analyzer AU, AAX and VST plugin for professional music and audio production applications.  For the most part it was derived from Voxengo GlissEQ dynamic parametric equalizer and reproduces its spectrum analysis functionality."
    },
    @{
        SoftwareName = "SPAN Plus"
        Version      = "1.23"
        Tags         = "fft spectrum analyser vst aax audio mixing mastering recording trial"
        Checksum   = "77093b2d44c773f797df0a3bc7002cbc1bbe4d4c9e10180ea6c630304b84c7cc"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/2f060c98209291720a34f842bf275718d554f033/Icons/SPANPlus.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoSPANPlus_en.pdf/getbyname/Voxengo%20SPAN%20Plus%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoSPANPlus_124_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "An fft spectrum analyser plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "SPAN Plus is a real-time fast Fourier transform audio spectrum analyzer AAX, AU and VST plugin for professional music and audio production applications.  For the most part it was derived from Voxengo GlissEQ dynamic parametric equalizer and reproduces its spectrum analysis functionality.  SPAN Plus is an extended version of the freeware SPAN plugin: SPAN Plus provides several additional features such as PNG file export, real-time spectrum import/export and static spectrums display."
    },
    @{
        SoftwareName = "Spatifier"
        Version      = "1.9"
        Tags         = "spatial enhancer vst aax audio mixing mastering recording trial"
        Checksum   = "1861739c63239d34892fc2b91c01e7d4dacd542bf67b2081626e59e353b54b15"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/a52ca957fbf214fbcfb5fba42ffa00e2ddad941a/Icons/Voxengo/Spatifier.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoSpatifier_en.pdf/getbyname/Voxengo%20Spatifier%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoSpatifier_110_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A mono-to-stereo spatial enhancer plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Spatifier is a mono to stereo spatial enhancer AU and VST plugin for professional sound and music production applications.  This plugin can be effectively used to turn mono tracks into spatially-enhanced stereo tracks: it works great for clean and distorted guitars, synth instruments, piano, organ, back vocals and other sounds.  Beside that Spatifier can be used to densify the sound of reverb sends, and to add body to thin and flat sounds."
    },
    @{
        SoftwareName = "Stereo Touch"
        Version      = "2.17"
        Tags         = "stereo widener vst aax audio mixing mastering recording free"
        Checksum   = "9c1b9978cfcaa7bd11ade5123183975bf6bd6fb3071191fd86f55feb17874f42"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/87932071c2764b359280c68a3a72a44a302c8ede/Icons/Voxengo/StereoTouch.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoStereoTouch_en.pdf/getbyname/Voxengo%20Stereo%20Touch%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoStereoTouch_218_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A stereo widener plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "This professional audio AAX, AU and VST plugin implements a classic technique of transforming a monophonic track into spacious stereophonic track by means of mid/side coding technique."
    },
    @{
        SoftwareName = "Tempo Delay"
        Version      = "2.7"
        Tags         = "stereo delay vst aax audio mixing mastering recording free"
        Checksum   = "5e4745b66b178f04b98e9a8d1d47432b41d578adb732a7fcc592172e7e260dd0"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/9b16103a03e8afc486ad15e799c99e3fb5ebf948/Icons/Voxengo/TempoDelay.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoTempoDelay_en.pdf/getbyname/Voxengo%20Tempo%20Delay%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoTempoDelay_28_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A stereo delay plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Tempo Delay is a multi-feature stereo delay plugin for professional music production applications.  Tempo Delay is based on tempo, incorporating filter and tremolo sections with separate controls for each stereo channel.  Instead of a single delay length control this plug-in features separate delay, repetition period and delay panning controls which allow you to create an evenly sounding ping-pong stereo echoes."
    },
    @{
        SoftwareName = "TEOTE"
        Version      = "1.14"
        Tags         = "teote automatic equalizing equalizer vst aax audio mixing mastering recording trial"
        Checksum   = "d32ac61fc20bf2fe909507e4baefa734a4fd3c179c12a7542689b5bf7872398b"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/553a5bfae4d6d2048fe1c21605c06f8a7af5155f/Icons/Voxengo/teote.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoTEOTE_en.pdf/getbyname/Voxengo%20TEOTE%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoTEOTE_115_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "An automatic spectral balancing audio plugin."
        Description  = "TEOTE is an automatic spectral balancer AudioUnit, AAX, and VST plugin for professional music production applications.  It was designed to be a very useful tool for both mixing and mastering.  It automatically performs such tasks like gentle resonances taming, de-essing, tilt equalizing, usually performed during mixing and mastering.  In mixing, TEOTE sounds good on pretty much any material."
    },
    @{
        SoftwareName = "TEQ-421"
        Version      = "1.2"
        Tags         = "equalizer vst aax audio mixing mastering recording trial"
        Checksum   = "295140bff3f9653a0bce6359867ea9f24498e565a85ebce6c7e61fdfd90412f8"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/e642eb258454fcf6626e5ab3968a890bb55be81f/Icons/Voxengo/teq421.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoTEQ421_en.pdf/getbyname/Voxengo%20TEQ-421%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoTEQ421_13_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A phase shift plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "TEQ-421 is freeware equalizer plug-in for professional music production applications.  This equalizer features only three bands (Triple EQ), finely tuned to deliver good results in many cases, thus being extremely easy to use.  Beside this, the plug-in features internal non-parametric harmonic coloration modules (derived from HarmoniEQ plug-in) that produce a smooth saturation and a presence effect."
    },
    @{
        SoftwareName = "TransGainer"
        Version      = "1.13"
        Tags         = "vst aax audio mixing mastering recording transient trial"
        Checksum   = "46cbe6044c7039ed6c5d9e2db01be66239386098884bbffaac78df584fea377b"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/607350f08440984b3bd23e49f642abe62443a612/Icons/Voxengo/TransGainer.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoTransGainer_en.pdf/getbyname/Voxengo%20TransGainer%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoTransGainer_114_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A transient designer plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "TransGainer, an audio AAX, AU and VST plugin suitable for a wide range of professional music production uses, implements an audio signal envelope adjustment algorithm that reacts on transients rather than on a signal's loudness level.  This algorithm allows you to adjust volume of attack and sustain stages of any sounds you use it on.  TransGainer was designed in a way to be suitable for all possible sound sources - be it individual tracks or full mixes."
    },
    @{
        SoftwareName = "Tube Amp"
        Version      = "2.12"
        Tags         = "distortion vst aax audio mixing mastering recording free"
        Checksum   = "10c3ee971ffee884f90f3b7fdea0f42c158bfb7fcd0876408fc165024b8a25e1"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/23056ac31f41c1bb044e523bdc5e790cf80331ea/Icons/Voxengo/TubeAmp.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoTubeAmp_en.pdf/getbyname/Voxengo%20Tube%20Amp%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoTubeAmp_213_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A distortion plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Tube Amp is an audio effect AU and VST plugin that applies asymmetric tube triode overdrive usually found in single-tube microphone pre-amp boxes.  The sound this plugin produces varies from a mild warm overdrive to a fuzzy distortion."
    },
    @{
        SoftwareName = "VariSaturator"
        Version      = "2.5"
        Tags         = "saturation vst aax audio mixing mastering recording trial"
        Checksum   = "7848416ea3b44d3ae8bcc028efa5e4d298e62993c16c9b049145fb0a2813a6c3"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/8b02f79d377052e5a981d3acf1a57e5eabc17362/Icons/Voxengo/varisaturator.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoVariSaturator_en.pdf/getbyname/Voxengo%20VariSaturator%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoVariSaturator_26_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A saturation plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "VariSaturator is an audio effect AU and VST plugin designed to apply saturation effects to audio material.  VariSaturator can be used both to boost the loudness of the audio tracks without increasing their peak levels proportionally, and to apply subtle harmonic coloration that makes tracks sound more pronounced and polished."
    },
    @{
        SoftwareName = "Voxformer"
        Version      = "2.21"
        Tags         = "vst aax audio mixing vocal channel strip recording trial"
        Checksum   = "3834abbe2f989e8d61c165b1b305e1b9dfd20deba79c96465a38961f44deba79"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/c9bf5e6539617e9629eaf8de7f8c3831aa77e60d/Icons/Voxformer.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoVoxformer_en.pdf/getbyname/Voxengo%20Voxformer%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoVoxformer_222_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A vocal channel strip plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Voxformer is a multi-functional vocal channel strip AAX, AU and VST plugin for professional audio applications.  Combining several professional quality processing modules, Voxformer was designed to be a comprehensive solution for all your vocal processing needs - be it spoken or sung vocals."
    },
    @{
        SoftwareName = "Warmifier"
        Version      = "2.7"
        Tags         = "tube valve coloration vst aax audio mixing mastering recording trial"
        Checksum   = "6e757a466c121bff555070059ac5fa542b8bfdf950af1de089e8a770fa0b8998"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/4973da60f7d3317d209850ab80ad1179c3879b38/Icons/Voxengo/warmifier.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoWarmifier_en.pdf/getbyname/Voxengo%20Warmifier%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoWarmifier_28_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A tube valve coloration plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Warmifier is a special audio effect AAX, AudioUnit and VST plugin for professional sound and music production applications which processes audio signal in a way similar to analog tube/valve equipment.  By using Warmifier you can achieve valve warming and console coloration effects.

Warmifier is applicable both to the complete mixes and to the individual instrument tracks.  You have several parameters at your disposal that allow you to control the strength and the color of the effect.  Also, you have several tube/valve types to choose from.  Each valve type offers a different overall coloration.

While the effect of this plugin is definitely subtle, the difference it makes is similar to the difference in sound between various analog mixing consoles.  In most cases it boils down to adding a subtle sparkle, presence, warming or solidifying effect to a sound track it was applied to."
    },
    @{
        SoftwareName = "Water Chorus"
        Version      = "1.0"
        Tags         = "chorus vst aax audio mixing mastering recording trial"
        Checksum   = "ed045726f1464f7eb9d6805f0bbb14a2451330f001395372ef952713f308d3f4"
        UrlIcon      = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/21a10bdd53239fc30b4d2a8e5b46db3eaedce609/Icons/Voxengo/WaterChorus.png"
        UrlManual    = "https://www.voxengo.com/files/userguides/VoxengoWaterChorus_en.pdf/getbyname/Voxengo%20Water%20Chorus%20User%20Guide%20en.pdf"
        Url        = "https://www.voxengo.com/files/VoxengoWaterChorus_11_Win32_64_VST_VST3_AAX_setup.exe"
        Summary      = "A chorus plugin for VST2/3 and AAX compatible hosts by Voxengo."
        Description  = "Water Chorus is a stereo chorus effect AAX, AudioUnit, and VST plugin for professional sound and music production applications.  Water Chorus is able to produce stereo-widening and weird watery modulation effects, possibly with a flanger vibe. Water Chorus plugin uses 4 operators for each channel thus creating a quite dense stereo chorus sound, which is also very smooth."
    }
)

foreach ($product in $products) {
    $PackageId = $product.SoftwareName.Replace(" ", "-").ToLower()
    $PackageNameNoWhite = $product.SoftwareName.Replace(" ", "").ToLower()
    # Construct the choco new command using splatting to avoid parsing issues
    $chocoArgs = @(
        'new'
        $product.SoftwareName
        '-t'
        'voxengo.template'
        "Version=$($product.Version)"
        "Author=$($Author)"
        "AuthorLowerNowhite=$($AuthorLowerNowhite)"
        "MaintainerName=$($MaintainerName)"
        "Tags=$($product.Tags)"
        "Checksum=$($product.Checksum)"
        "UrlIcon=$($product.UrlIcon)"
        "UrlManual=$($product.UrlManual)"
        "Summary=$($product.Summary)"
        "Url=$($product.Url)"
        "PackageId=$($PackageId)"
        "PackageNameNoWhite=$($PackageNameNoWhite)"
        "Description=$($product.Description)"
        "DescriptionShared=$DescriptionShared"
        '--force'
    )

    Write-Debug "choco $($chocoArgs -join ' ')"
    & choco @chocoArgs

    $nuspecFilePath = "$PSScriptRoot\$($product.SoftwareName)\$($product.SoftwareName.ToLower()).nuspec"
    $nuspecDir = [System.IO.Path]::GetDirectoryName((Resolve-Path -Path $nuspecFilePath).Path)

    # Set the current location to the directory of the .nuspec file temporarily
    Push-Location -Path $nuspecDir

    # Get the relative path from the .nuspec directory to the shared scripts path
    $relativePath = Resolve-Path -Path $SharedScriptsPath -Relative

    # Replace remaining variables in .nuspec file and create package
#    (Get-Content -Path $nuspecFilePath -Raw) `
#        -replace '\$sharedscripts\$', $relativePath `
#        -replace '\\+', '\' | Set-Content -Path $nuspecFilePath

    # Return to the previous location
    Pop-Location
    
    choco pack $nuspecFilePath
}
