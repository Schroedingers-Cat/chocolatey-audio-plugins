# Links the templates to %chocolateyinstall%\templates

$templatesDir = Join-Path $env:chocolateyinstall 'templates'

if (-not (Test-Path $templatesDir)) {
    New-Item -ItemType Directory -Path $templatesDir | Out-Null
}

Get-ChildItem -Directory -Filter '*.template' | ForEach-Object {
    $templateName = $_.Name
    $targetLink = Join-Path $templatesDir $templateName

    if (Test-Path $targetLink) {
        Remove-Item $targetLink -Force
    }

    New-Item -ItemType SymbolicLink -Path $targetLink -Target $_.FullName
}
