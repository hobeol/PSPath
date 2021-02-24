#Requires -Modules @{ModuleName='InvokeBuild';ModuleVersion='3.2.1'}
#Requires -Modules @{ModuleName='PowerShellGet';ModuleVersion='1.6.0'}
#Requires -Modules @{ModuleName='Pester';ModuleVersion='4.1.1'}
#Requires -Modules @{ModuleName='ModuleBuilder';ModuleVersion='1.0.0'}

$Script:IsAppveyor = $null -ne $env:APPVEYOR
$Script:ModuleName = Get-Item -Path $BuildRoot | Select-Object -ExpandProperty Name
Get-Module -Name $ModuleName | Remove-Module -Force

task Clean {
    Remove-Item -Path ".\Bin" -Recurse -Force -ErrorAction SilentlyContinue
}

task TestCode {
    Write-Build Yellow "Testing dev code before build"
    #$TestResult = Invoke-Pester -Script "$PSScriptRoot\Test\Unit" -Tag Unit -Show 'Header','Summary' -PassThru
    $Config = [PesterConfiguration]::Default
    $Config.Run.PassThru = $true
    $Config.Run.Path = "$PSScriptRoot\Test\Unit"
    $Config.Output.Verbosity = 'Detailed'
    $Config.Filter.Tag = 'Unit'
    $TestResult = Invoke-Pester -Configuration $Config
    if($TestResult.FailedCount -gt 0) {throw 'Tests failed'}
}

task CompilePSM {
    Write-Build Yellow "Compiling all code into single psm1"
    try {
        $BuildParams = @{}
        if((Get-Command -ErrorAction stop -Name gitversion)) {
            $GitVersion = gitversion | ConvertFrom-Json | Select-Object -Expand FullSemVer
            $GitVersion = gitversion | ConvertFrom-Json | Select-Object -Expand InformationalVersion
            $BuildParams['SemVer'] = $GitVersion
        }
    }
    catch{
        Write-Warning -Message 'gitversion not found, keeping current version'
    }
    Push-Location -Path "$BuildRoot\Source" -StackName 'InvokeBuildTask'
    $Script:CompileResult = Build-Module @BuildParams -Passthru
    Get-ChildItem -Path "$BuildRoot\license*" | Copy-Item -Destination $Script:CompileResult.ModuleBase
    Pop-Location -StackName 'InvokeBuildTask'
}

task MakeHelp -if (Test-Path -Path "$PSScriptRoot\Docs") {

}

task TestBuild {
    Write-Build Yellow "Testing compiled module"
    #$Script =  @{Path="$PSScriptRoot\test\Unit"; Parameters=@{ModulePath=$Script:CompileResult.ModuleBase}}
    #$CodeCoverage = (Get-ChildItem -Path $Script:CompileResult.ModuleBase -Filter *.psm1).FullName
    #$TestResult = Invoke-Pester -Script $Script -CodeCoverage $CodeCoverage -Show None -PassThru
    $Config = [PesterConfiguration]::Default
    $Config.Run.PassThru = $true
    $Config.Run.Exit = $true
    $Config.CodeCoverage.Path = (Get-ChildItem -Path $Script:CompileResult.ModuleBase -Filter *.psm1).FullName
    $Config.CodeCoverage.Enabled = $true
    $Config.Output.Verbosity = 'Detailed' #'None'
    $Config.Filter.ExcludeTag = 'Unit'
    $Config.TestResult.Enabled = $true
    $TestResult = Invoke-Pester -Configuration $Config

    if($TestResult.FailedCount -gt 0) {
        Write-Warning -Message "Failing Tests:"
        $TestResult.TestResult.Where{$_.Result -eq 'Failed'} | ForEach-Object -Process {
            Write-Warning -Message $_.Name
            Write-Verbose -Message $_.FailureMessage -Verbose
        }
        throw 'Tests failed'
    }

    #Write-Host ("PSScriptRoot:`t{0}`nCompileResult.ModuleBase`t{1}" -f
    #    $PSScriptRoot,$Script:CompileResult.ModuleBase)
    #Get-Member $TestResult
    #$CodeCoverageResult = $TestResult | Convert-CodeCoverage -SourceRoot ".\Source" #-Relative
    #$CodeCoverageResult = $TestResult | Convert-CodeCoverage -SourceRoot $Script:CompileResult.ModuleBase #-Relative
    #Write-Host ("TestResult.CodeCoverage.NumberOfCommandsExecuted:`t{0}`nTestResult.CodeCoverage.NumberOfCommandsAnalyzed:`t{1}" -f
    #    $TestResult.CodeCoverage.NumberOfCommandsExecuted,$TestResult.CodeCoverage.NumberOfCommandsAnalyzed)
    #$CodeCoveragePercent = $TestResult.CodeCoverage.NumberOfCommandsExecuted/$TestResult.CodeCoverage.NumberOfCommandsAnalyzed*100 -as [int]
    #Write-Verbose -Message "CodeCoverage is $CodeCoveragePercent%" -Verbose
    #$CodeCoverageResult | Group-Object -Property SourceFile | Sort-Object -Property Count | Select-Object -Property Count, Name -Last 10
}

task . Clean, TestCode, Build

task Build CompilePSM, MakeHelp, TestBuild

