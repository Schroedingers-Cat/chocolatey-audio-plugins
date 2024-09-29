$products = @(
    @{
        PackageId = "Aalto"
        Version = "1.9.4"
        Author = "Madrona Labs"
        MaintainerName = "Schroedingers-Cat"
        Tags = "synthesizer vst2 plugin semi-modular eastcoast instrument audio"
        Description = "Aalto is a semi-modular software synthesizer with an innovative, patchable UI, distinctive sounds, and a charming personality."
        Url64 = "https://madronalabs.com/media/aalto/AaltoInstaller1.9.4.exe"
        Checksum64 = "4679B6EDD6F6D0F4772C53ED16E5057D9A63644F071D73B4FEF061BC083F8AC8"
        UrlIcon = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/21eb090e96f02f052c7919a8b57a618b6e62be4f/Icons/MadronaLabs/Aalto.png"
    },
    @{
        PackageId = "Aaltoverb"
        Version = "2.0.3"
        Author = "Madrona Labs"
        MaintainerName = "Schroedingers-Cat"
        Tags = "reverb vst2 plugin effect mixing audio"
        Description = "Aaltoverb is a reverberator designed with a focus on completely smooth tweakability. Any of its controls including the reverb size can be adjusted without making clicks. This feature can bring fresh sounds to a mix, and particularly shines in a live performance setup."
        Url64 = "https://madronalabs.com/media/aaltoverb/AaltoverbInstaller2.0.3.exe"
        Checksum64 = "4EA1B274A4C3039F6E3A1FBF31375BEB4FC2651F522790154963C8809C40CCEC"
        UrlIcon = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/21eb090e96f02f052c7919a8b57a618b6e62be4f/Icons/MadronaLabs/Aaltoverb.png"
    },
    @{
        PackageId = "Kaivo"
        Version = "1.9.4"
        Author = "Madrona Labs"
        MaintainerName = "Schroedingers-Cat"
        Tags = "synthesizer vst2 plugin granular physical modeling instrument audio"
        Description = "Kaivo is a semi-modular software synthesizer that combines two powerful ways of making sound: granular synthesis and physical modeling."
        Url64 = "https://madronalabs.com/media/kaivo/KaivoInstaller1.9.4.exe"
        Checksum64 = "1988445197D1C1466908F882727D87E035BD3A476889659B7E4B446BDEAC6F73"
        UrlIcon = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/21eb090e96f02f052c7919a8b57a618b6e62be4f/Icons/MadronaLabs/Kaivo.png"
    },
    @{
        PackageId = "Virta"
        Version = "1.9.3"
        Author = "Madrona Labs"
        MaintainerName = "Schroedingers-Cat"
        Tags = "synthesizer vst2 plugin vocal processor effect instrument audio"
        Description = "Virta is a patchable toolbox for turning your voice or other instrument into wild new synth sounds."
        Url64 = "https://madronalabs.com/media/virta/VirtaInstaller1.9.3.exe"
        Checksum64 = "F8466AF69525A3890C1DE6807A212C1DB54C21F317659E3C1CB217EB72D1ECDB"
        UrlIcon = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/396d8d00dc9123958caf3f5d877d36c53a29ed3d/Icons/MadronaLabs/Virta.png"
    },
    @{
        PackageId = "Sumu"
        Version = "1.0.0-beta20"
        Author = "Madrona Labs"
        MaintainerName = "Schroedingers-Cat"
        Tags = "synthesizer vst3 plugin additive resynthesis fm instrument audio"
        Description = "Sumu breaks completely new ground in software synthesis, combining additive resynthesis with FM and vector field spatialization. Its collection of ten modules, designed around a unique multi-channel patcher, offer musical possibilities not found in any other instrument."
        Url64 = "https://madronalabs-earlyaccess.s3.amazonaws.com/SumuInstaller1.0.0b20.exe"
        Checksum64 = "a4cf0388d76ebf671afed2414c3b3913c3809408eb523641b2adf40564d733d4"
        UrlIcon = "https://rawcdn.githack.com/Schroedingers-Cat/chocolatey-audio-plugins/20d9218c5916e85962c6be9c688c954a8cb28634/Icons/MadronaLabs/Sumu.png"
    }
)

foreach ($product in $products) {
    # Construct the choco new command as a single line string
    $command = "choco new $($product.PackageId) -t madronalabs.template " +
               "Version='$($product.Version)' " +
               "Author='$($product.Author)' " +
               "MaintainerName='$($product.MaintainerName)' " +
               "Tags='$($product.Tags)' " +
               "Description='$($product.Description)' " +
               "url64='$($product.Url64)' " +
               "Checksum64='$($product.Checksum64)' " +
               "UrlIcon='$($product.UrlIcon)' " +
               "--force"

    # Output the command for debugging purposes
    Write-Output $command

    # Execute the command
    Invoke-Expression $command

    choco pack "$($product.PackageId)\$($product.PackageId).nuspec"
}
