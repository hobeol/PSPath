@{
    Path = "PSPath.psd1"
    OutputDirectory = "..\bin\PSPath"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    PublicFilter = 'Public\*.ps1'
    VersionedOutputDirectory = $true
}
