# Chocolatey Templates

Templates for various chocolatey packages. To use, link the template directories into your chocolatey template directory by running `link-to-templates.ps1`.

## Shared Scripts
Some templates use scripts shared across multiple packages. This is achieved by a special $sharedscripts$ template variable that needs to be replaced after instantiating the template. An example of this is in the script `DMGAudio\dmg-template.ps1`.
