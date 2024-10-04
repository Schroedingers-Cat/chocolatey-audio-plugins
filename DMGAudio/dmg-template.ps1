param (
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path -Path $_ -PathType 'Container' })]
    [string]$SharedScriptsPath = "${PSScriptRoot}\..\SharedScripts"
)

$Author = "DMGAudio"
$AuthorLowerNowhite = $Author.ToLower().Replace(" ", "")
$MaintainerName = "Schroedingers-Cat"

$products = @(
    @{
        PackageId  = "Compassion"
        Version    = "1.30"
        Tags       = "vst aax audio mixing dynamics compression admin trial"
        Checksum32 = "6641c5d6a7c437dcda912eee688cf5e2ccd8a73068b07884a9d8bd48c69c6d20"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/compassion.png"
        Summary    = "A compressor plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "Dualism"
        Version    = "1.19"
        Tags       = "vst aax audio mixing analyzer admin trial"
        Checksum32 = "2584b6b089ad4bb06f806215b8bc98506e6a2b6362997e44db43b0dabb7c1092"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/dualism.png"
        Summary    = "A stereo visualization plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "EQuality"
        Version    = "1.43"
        Tags       = "vst aax equalizer audio mixing admin trial"
        Checksum32 = "9e864bb5d77faba168a393fb73a7c6190187fcf8de0f601aae9c5d75f2daeca2"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/equality.png"
        Summary    = "An equalizer plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "EQuick"
        Version    = "1.26"
        Tags       = "vst aax equalizer  audio mixing admin trial"
        Checksum32 = "2d0891b1ca2379b3784d80a49058e1979ad7f6eb033982502cdc4b9895acb055"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/equick.png"
        Summary    = "A simple and fast equalizer plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "EQuilibrium"
        Version    = "1.68"
        Tags       = "vst aax equalizer audio mixing admin trial"
        Checksum32 = "ccbe74597446c59a5b6c421401042b0e847d77038b820705bdc266ffc8eca547"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/equilibrium.png"
        Summary    = "A flexible and customizable equalizer plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "Essence"
        Version    = "1.17"
        Tags       = "vst aax de-esser audio mixing admin trial"
        Checksum32 = "bbbce40a60c6b55d5a320c007fa31be58c3242b4e9553c00deeed9b6bfe61f4d"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/essence.png"
        Summary    = "A de-esser plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "Expurgate"
        Version    = "1.15"
        Tags       = "vst aax gate expander audio mixing admin trial"
        Checksum32 = "519e4a88922d55069ce992eed55a7fc20092c5e7264fcdd4056bc13cb086d139"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/expurgate.png"
        Summary    = "A gate/expander plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "Limitless"
        Version    = "1.19"
        Tags       = "vst aax multiband limiter audio mixing admin trial"
        Checksum32 = "939de7040e6d7b04816e43d6c8a1e12304c21f5c11547b0cd76a87a78467510e"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/limitless.png"
        Summary    = "A limiter plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "Multiplicity"
        Version    = "1.13"
        Tags       = "vst aax multiband mastering compression audio mixing admin trial"
        Checksum32 = "e98bb65eeec4edc7b81383e61be9ed789a2a2886fa0b7e33db8c8f07b935f4af"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/multiplicity.png"
        Summary    = "A multiband compressor plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "PitchFunk"
        Version    = "1.24"
        Tags       = "vst aax multi-effects audio mixing admin trial"
        Checksum32 = "8bdde5c52b33e7274f4972c30cfa8ddcc2461762dcaac63705fb02f9b2121147"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/b8d3132e04017c26ba9d108c81a1b90a725743c1/Icons/DMGAudio/pitchfunk.png"
        Summary    = "An multi-effects plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "TrackComp"
        Version    = "2.09"
        Tags       = "vst aax dynamics compression audio mixing admin trial"
        Checksum32 = "3e1fbf5f1536ffe99b520fa5e58c8ea1382fc65c6e3fc250fda55bce85a1708b"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/77265b607c7ae20e4f199be94862ad54a2c8da41/DMGAudio/trackcomp.png"
        Summary    = "A compressor plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "TrackControl"
        Version    = "1.13"
        Tags       = "vst aax audio mixing admin trial"
        Checksum32 = "bca1e1c610185a8b5167c685c20a7891d6b91cb6edbbd26839a81023106b701c"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/04cf8dd8839151d38029bdb2f98d71f57d23f248/Icons/DMGAudio/trackcontrol.png"
        Summary    = "A simple track plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "TrackDS"
        Version    = "1.13"
        Tags       = "vst aax de-esser audio mixing admin trial"
        Checksum32 = "07057431cd4f22cfbcfd1406439e1057817d53e37d6f3b8ab99a57fa8277f972"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/04cf8dd8839151d38029bdb2f98d71f57d23f248/Icons/DMGAudio/trackds.png"
        Summary    = "A simple de-esser plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "TrackGate"
        Version    = "1.13"
        Tags       = "vst aax gate audio mixing admin trial"
        Checksum32 = "1ef26896e9a206991736420236d0eedb416027863535ac4790cff9f0f932c6f7"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/04cf8dd8839151d38029bdb2f98d71f57d23f248/Icons/DMGAudio/trackgate.png"
        Summary    = "A simple gate plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "TrackLimit"
        Version    = "1.13"
        Tags       = "vst aax limiter audio mixing admin trial"
        Checksum32 = "8e5276f5dd411a6aaac3a82864dafd200d4b75a4c142ec98d875e34bf4ddb8f8"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/04cf8dd8839151d38029bdb2f98d71f57d23f248/Icons/DMGAudio/tracklimit.png"
        Summary    = "A simple limiter plugin for VST2/3 and AAX hosts by DMGAudio."
    },
    @{
        PackageId  = "TrackMeter"
        Version    = "1.13"
        Tags       = "vst aax metering audio mixing admin trial"
        Checksum32 = "8e29d0963d3dc3fd164fd831192c1405ecc35758969cca7a69f83e17b6b89414"
        UrlIcon    = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/04cf8dd8839151d38029bdb2f98d71f57d23f248/Icons/DMGAudio/trackmeter.png"
        Summary    = "A simple meter plugin for VST2/3 and AAX hosts by DMGAudio."
    }
)

foreach ($product in $products) {
    # Construct the choco new command as a single line string
    $command = "choco new $($product.PackageId) -t dmgaudio.template " +
    "Version='$($product.Version)' " +
    "Author='$($Author)' " +
    "AuthorLowerNowhite='$($AuthorLowerNowhite)' " +
    "MaintainerName='$($MaintainerName)' " +
    "Tags='$($product.Tags)' " +
    "Checksum32='$($product.Checksum32)' " +
    "UrlIcon='$($product.UrlIcon)' " +
    "Summary='$($product.Summary)' " +
    "--force"

    Write-Debug $command
    Invoke-Expression $command

    $nuspecFilePath = "$PSScriptRoot\$($product.PackageId)\$($product.PackageId.ToLower()).nuspec"
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
