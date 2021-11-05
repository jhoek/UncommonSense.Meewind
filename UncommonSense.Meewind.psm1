function Get-MeewindFundPrice
{
    param
    (
    )

    $DutchCulture = [CultureInfo]::GetCultureInfo('nl-NL')

    $Content = Invoke-WebRequest -Uri 'https://meewind.nl/fondsen' | Select-Object -ExpandProperty Content

    $FundNames = $Content | pup '.fundblock .h4 text{}'
    $FundPrices = $Content | pup '.fundblock .col-xs-6 .semibold:nth-child(2) text{}'

    0..($FundNames.Count - 1) | ForEach-Object {
        [PSCustomObject]@{
            PSTypeName = 'UncommonSense.Meewind.FundPrice'
            Date       = Get-Date
            Fund       = $FundNames[$_]
            Price      = [decimal]::Parse(($FundPrices[$_] -replace '^€\s*', ''), $DutchCulture)
        }
    }
}