function Get-MeewindFundPrice
{
    param
    (
    )

    $DutchCulture = [CultureInfo]::GetCultureInfo('nl-NL')

    $Document = ConvertTo-HtmlDocument -Uri 'https://meewind.nl/fondsen'

    $FundNames = ($Document | Select-HtmlNode -CssSelector '.fundblock .h4' -All).InnerText
    $FundPrices = ($Document | Select-HtmlNode -CssSelector '.fundblock .col-xs-6 .semibold:nth-child(2)' -All).InnerText

    0..($FundNames.Count - 1) | ForEach-Object {
        [PSCustomObject]@{
            PSTypeName = 'UncommonSense.Meewind.FundPrice'
            Date       = Get-Date
            Fund       = $FundNames[$_]
            Price      = [decimal]::Parse(($FundPrices[$_] -replace '^\&euro\;\s*', ''), $DutchCulture)
        }
    }
}