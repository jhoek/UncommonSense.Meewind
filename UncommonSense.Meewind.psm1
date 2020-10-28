function Get-MeewindFundPrice
{
    param
    (
    )

    $DutchCulture = [CultureInfo]::GetCultureInfo('nl-NL')

    Invoke-WebRequest -Uri 'https://meewind.nl/fondsen'
    | Select-Object -ExpandProperty Content
    | pup '.fundblock:nth-of-type(1) json{}'
    | jq '[.[] | { fund : .children[1].text, price : .children[2].children[2].children[1].children[1].text }]'
    | ConvertFrom-Json
    | ForEach-Object {
        [PSCustomObject]@{
            PSTypeName = 'UncommonSense.Meewind.FundPrice'
            Date       = Get-Date
            Fund       = $_.fund
            Price      = [decimal]::Parse(($_.price -replace '^€\s*', ''), $DutchCulture)
        }
    }
}