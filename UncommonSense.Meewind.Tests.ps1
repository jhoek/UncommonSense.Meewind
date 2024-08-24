Describe UncommonSense.Meewind {
    BeforeAll {
        Import-Module "$PSScriptRoot/UncommonSense.Meewind.psd1" -Force
    }

    It 'Returns at least four funds, with recent prices' {
        $Result = Get-MeewindFundPrice

        $Result.Length | Should -BeGreaterOrEqual 4
        $Result.Date | Should -BeGreaterThan (Get-Date).AddMonths(-1)
        $Result.Fund | Should -Not -BeNullOrEmpty
        $Result.Price | Should -BeGreaterThan 0
    }
}