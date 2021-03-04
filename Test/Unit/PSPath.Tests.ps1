Describe 'Core Module Tests' -Tags 'CoreModule', 'Unit' {
    BeforeAll {
        $ModulePath = Resolve-Path "$PSScriptRoot\..\.."
        $ModuleSourcePath = Resolve-Path "$ModulePath\Source"
        $ModuleName = (Get-Item $ModulePath).Name
        $ModuleManifestName = 'PSPath.psd1'
        $ModuleManifestPath = Resolve-Path(Join-Path -Path $ModuleSourcePath -ChildPath $ModuleManifestName)
        Write-Host ("Module:`n`tPath:`t{0}`n`tSourcePath:`t{1}`n`tName:`t{2}`n`tManifestName:`t{3}`n`tManifestPath:`t{4}" -f
            $ModulePath,$ModuleSourcePath,$ModuleName,$ModuleManifestName,$ModuleManifestPath)
    }

    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should -Be $true
    }

    It 'Loads from module path without errors' {
        {Import-Module "$ModuleSourcePath\$ModuleName.psd1" -ErrorAction Stop} | Should -Not -Throw
    }

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }

}
