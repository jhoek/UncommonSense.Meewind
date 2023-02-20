function Get-MeewindFundPrice
{
    param
    (
    )

    $DutchCulture = [CultureInfo]::GetCultureInfo('nl-NL')

    Invoke-WebRequest -Uri 'https://meewind.nl/fondsen'
    | Select-Object -ExpandProperty Links
    | Where-Object { $_.HRef }
    | Select-Object -ExpandProperty HRef
    | Where-Object { $_ -like 'https://meewind.nl/fonds/*' }
    | Select-Object -Unique
    | ForEach-Object {
        $Document = ConvertTo-HtmlDocument -Uri $_
        $Fund = $Document | Select-HtmlNode -CssSelector h2 | Get-HtmlNodeText
        $DateText = ($Document | Select-HtmlNode -CssSelector '.fund-intrinsieke-waarde' | Get-HtmlNodeText -DirectInnerTextOnly) -replace '^Intrinsieke waarde \(', '' -replace '\):$', ''
        $Date = [DateTime]::ParseExact($DateText, 'dd-MM-yyyy', $DutchCulture)
        $PriceText = ($Document | Select-HtmlNode -CssSelector '.intrinsieke-waarde-1' | Get-HtmlNodeText) -replace '^€\s*', ''

        [PSCustomObject]@{
            PSTypeName = 'UncommonSense.Meewind.FundPrice'
            Date       = $Date
            Fund       = $Fund
            Price      = [decimal]::Parse($PriceText, $DutchCulture)
        }
    }
}