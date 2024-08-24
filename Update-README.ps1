Import-Module (Join-Path -Path $PSScriptRoot -ChildPath UncommonSense.Meewind.psd1) -Force

Get-Command -Module UncommonSense.Meewind |
    Convert-HelpToMarkDown `
        -Title 'UncommonSense.Meewind' `
        -Description 'PowerShell module for Meewind investments funds' |
    Out-File -FilePath (Join-Path -Path $PSScriptRoot -ChildPath README.md) -Encoding utf8