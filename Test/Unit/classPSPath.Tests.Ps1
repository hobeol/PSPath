BeforeAll {
	$ModuleName = Resolve-Path "$PSScriptRoot\..\..\Source\Classes\classPSPath.ps1"
	$scriptBody = "using module $ModuleName"
	$script = [ScriptBlock]::Create($scriptBody)
	. $script
	# Testparameter set
	$Path01 = 'C:\Test\Folder01\File01.txt'
	$Dir01 = 'Temp\Folder01\'
	$OutMsg = "Path01:`t{0}`nDir01:`t{1}" -f
		$Path01, $Dir01
	Write-Verbose $OutMsg
}

Describe '[PSPath]-[Constructors]' {
	It '[PSPath]-[Constructor] - Parameterless should Not Throw' {
		# -- Arrange
		# -- Act
		# -- Assert
		{ [PSPath]::New() } | Should -Not -Throw
	}# end of it block
	It '[PSPath]-[Constructor]([String]Path) should Not Throw' {
		# -- Arrange
		[String]$Path = ''
		# -- Act
		# -- Assert
		{ [PSPath]::New($Path) } | Should -Not -Throw
	}# end of it block
	It '[PSPath]-[Constructor]("$Path01") should Be filled' {
		# -- Arrange
		[String]$Path = $Path01
		# -- Act
		$TestPath = [PSPath]::New($Path)
		# -- Assert
		{$TestPath} | Should -Not -Throw
		$TestPath.Path | Should -Be $Path01
		$TestPath.Drive | Should -Be 'C:'
		$TestPath.Directory | Should -Be 'Test\Folder01\'
		$TestPath.FileName | Should -Be 'File01'
		$TestPath.Extension | Should -Be 'txt'
		$TestPath.Stream | Should -Be ''
	}# end of it block
	It '[PSPath]-Directory-Setter .Directory = Temp\Folder01\ should Be filled' {
		# -- Arrange
		[String]$Path = $Path01
		# -- Act
		$TestPath1 = [PSPath]::New($Path)
		$TestPath1.Directory = $Dir01
		$TestPath2 = $TestPath1
		$TestPath2.MakePath()
		# -- Assert
		{$TestPath1} | Should -Not -Throw
		{$TestPath2} | Should -Not -Throw
		$TestPath1.Path | Should -Be 'C:\Temp\Folder01\File01.txt'
		$TestPath1.Drive | Should -Be 'C:'
		$TestPath1.Directory | Should -Be $Dir01
		$TestPath1.FileName | Should -Be 'File01'
		$TestPath1.Extension | Should -Be 'txt'
		$TestPath1.Stream | Should -Be ''
		$TestPath2.Path | Should -Be 'C:\Temp\Folder01\File01.txt'
		$TestPath2.Drive | Should -Be 'C:'
		$TestPath2.Directory | Should -Be 'Temp\Folder01\'
		$TestPath2.FileName | Should -Be 'File01'
		$TestPath2.Extension | Should -Be 'txt'
		$TestPath2.Stream | Should -Be ''
	}# end of it block
	It '[PSPath]-Constructor with ' {
		# -- Arrange
		[String]$Path = "C::"
		# -- Act
		$TestPath1 = [PSPath]::New($Path)
		# -- Assert
		{$TestPath1} | Should -Not -Throw
		$TestPath1.Path | Should -Be 'C::'
		$TestPath1.Drive | Should -Be 'C::'
		$TestPath1.Directory | Should -Be ''
		$TestPath1.FileName | Should -Be ''
		$TestPath1.Extension | Should -Be ''
		$TestPath1.Stream | Should -Be ''
		$TestPath1.IsPathValid | Should -BeFalse
	}# end of it block
	It '[PSPath]-[Constructor]([String]Drive,[String]Directory,[String]FileName,[String]Extension) should Not Throw' {
		# -- Arrange
		[String]$Drive = ''
		[String]$Directory = ''
		[String]$FileName = ''
		[String]$Extension = ''
		# -- Act
		# -- Assert
		{ [PSPath]::New($Drive, $Directory, $FileName, $Extension) } | Should -Not -Throw
	}# end of it block
	It '[PSPath]-[Constructor]([String]Drive,[String]Directory,[String]FileName,[String]Extension,[String]Stream) should Not Throw' {
		# -- Arrange
		[String]$Drive = ''
		[String]$Directory = ''
		[String]$FileName = ''
		[String]$Extension = ''
		[String]$Stream = ''
		# -- Act
		# -- Assert
		{ [PSPath]::New($Drive, $Directory, $FileName, $Extension, $Stream) } | Should -Not -Throw
	}# end of it block
}# end of Describe block
Describe '[PSPathEx]-[Constructors]' {
	It '[PSPathEx]-[Constructor] - Parameterless should Not Throw' {
		# -- Arrange
		# -- Act
		# -- Assert
		{ [PSPathEx]::New() } | Should -Not -Throw
	}# end of it block
	It '[PSPathEx]-[Constructor]([String]Path) should Not Throw' {
		# -- Arrange
		[String]$Path = ''
		# -- Act
		# -- Assert
		{ [PSPathEx]::New($Path) } | Should -Not -Throw
	}# end of it block
	It '[PSPathEx]-[Constructor]([String]Drive,[String]Directory,[String]FileName,[String]Extension) should Not Throw' {
		# -- Arrange
		[String]$Drive = ''
		[String]$Directory = ''
		[String]$FileName = ''
		[String]$Extension = ''
		# -- Act
		# -- Assert
		{ [PSPathEx]::New($Drive, $Directory, $FileName, $Extension) } | Should -Not -Throw
	}# end of it block
	It '[PSPathEx]-[Constructor]([String]Drive,[String]Directory,[String]FileName,[String]Extension,[String]Stream) should Not Throw' {
		# -- Arrange
		[String]$Drive = ''
		[String]$Directory = ''
		[String]$FileName = ''
		[String]$Extension = ''
		[String]$Stream = ''
		# -- Act
		# -- Assert
		{ [PSPathEx]::New($Drive, $Directory, $FileName, $Extension, $Stream) } | Should -Not -Throw
	}# end of it block
}# end of Describe block
Describe '[PSPathEx]-[Methods]' {
	#Public Method
	It '[PSPathEx] --> TestUNCPath() : [void] - should Not Throw' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		{ $Instance.TestUNCPath() } | Should -Not -Throw
	} #End It Block
	#Public Method
	It '[PSPathEx] --> TestUNCPath() Should not return anything (voided)' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		$Instance.TestUNCPath() | should -be $null
	} #End It Block
	#Public Method
	It '[PSPathEx] --> GetDNSName() : [String] - should Not Throw' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		{ $Instance.GetDNSName() } | Should -Not -Throw
	} #End It Block
	#Public Method
	It '[PSPathEx] --> GetDNSName() : [String] - should return type [String]' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		($Instance.GetDNSName()).GetType().Name | should -be String
	} #End It Block
	#Public Method
	It '[PSPathEx] --> TestFQDNPath() : [void] - should Not Throw' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		{ $Instance.TestFQDNPath() } | Should -Not -Throw
	} #End It Block
	#Public Method
	It '[PSPathEx] --> TestFQDNPath() Should not return anything (voided)' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		$Instance.TestFQDNPath() | should -be $null
	} #End It Block
	#Public Method
	It '[PSPathEx] --> MakeFQDNPath() : [void] - should Not Throw' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		{ $Instance.MakeFQDNPath() } | Should -Not -Throw
	} #End It Block
	#Public Method
	It '[PSPathEx] --> MakeFQDNPath() Should not return anything (voided)' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		$Instance.MakeFQDNPath() | should -be $null
	} #End It Block
	#Public Method
	It '[PSPathEx] --> MakePath() : [void] - should Not Throw' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		{ $Instance.MakePath() } | Should -Not -Throw
	} #End It Block
	#Public Method
	It '[PSPathEx] --> MakePath() Should not return anything (voided)' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		$Instance.MakePath() | should -be $null
	} #End It Block
	#Public Method
	It '[PSPathEx] --> SplitPath() : [void] - should Not Throw' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		{ $Instance.SplitPath() } | Should -Not -Throw
	} #End It Block
	#Public Method
	It '[PSPathEx] --> SplitPath() Should not return anything (voided)' {
		# -- Arrange
		# -- Act
		$Instance = [PSPathEx]::New()
		# -- Assert
		$Instance.SplitPath() | should -be $null
	} #End It Block
}#EndDescribeBlock
