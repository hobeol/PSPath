Enum PathEnum {
	Path = 0
	Drive = 1
	Directory = 2
	FileName = 3
	Extension = 4
	Stream = 5
}

class PSPath {
	hidden [String[]]$arPSPath = [String[]]::new(6)
	[Bool] $IsPathValid

	hidden [void]AddVariable() {
		$this | Add-Member -Name "Path" -MemberType ScriptProperty -Value {
			return $this.arPSPath[[PathEnum]::Path]
		} -SecondValue {
			param($Value)
			$this.arPSPath[[PathEnum]::Path] = $Value
			$this.SplitPath()
		}
		$this | Add-Member -Name "Drive" -MemberType ScriptProperty -Value {
			return $this.arPSPath[[PathEnum]::Drive]
		} -SecondValue {
			param($Value)
			$this.arPSPath[[PathEnum]::Drive] = $Value
			$this.MakePath()
		}
		$this | Add-Member -Name "Directory" -MemberType ScriptProperty -Value {
			return $this.arPSPath[[PathEnum]::Directory]
		} -SecondValue {
			param($Value)
			$this.arPSPath[[PathEnum]::Directory] = $Value
			$this.MakePath()
		}
		$this | Add-Member -Name "FileName" -MemberType ScriptProperty -Value {
			return $this.arPSPath[[PathEnum]::FileName]
		} -SecondValue {
			param($Value)
			$this.arPSPath[[PathEnum]::FileName] = $Value
			$this.MakePath()
		}
		$this | Add-Member -Name "Extension" -MemberType ScriptProperty -Value {
			return $this.arPSPath[[PathEnum]::Extension]
		} -SecondValue {
			param($Value)
			$this.arPSPath[[PathEnum]::Extension] = $Value
			$this.MakePath()
		}
		$this | Add-Member -Name "Stream" -MemberType ScriptProperty -Value {
			return $this.arPSPath[[PathEnum]::Stream]
		} -SecondValue {
			param($Value)
			$this.arPSPath[[PathEnum]::Stream] = $Value
			$this.MakePath()
		}
	}
	hidden [void]TestPathIsValid() {
		$this.IsPathValid = $True
		$InvChar = [char]0..31 + [char[]]'"<>|+?'
		$carPath = $this.arPSPath[[PathEnum]::Path]
		if ([String]::IsNullOrEmpty($carPath)) {
			$this.IsPathValid = $False
		}
		if ($carPath.IndexOfAny($InvChar) -ge 0) {
			$this.IsPathValid = $False
		}
		if ($carPath.IndexOf([system.io.path]::VolumeSeparatorChar) -eq 0) {
			$this.IsPathValid = $False
		}
		if ($carPath -match [system.io.path]::VolumeSeparatorChar + [system.io.path]::VolumeSeparatorChar) {
			$this.IsPathValid = $False
		}
	}
	hidden [void]MakePath() {
		$this.arPSPath[[PathEnum]::Path] = $null
		for ($i = 1; $i -le 3; $i++) {
			if (![string]::IsNullOrEmpty($this.arPSPath[$i])) {
				if ([string]::IsNullOrEmpty($this.arPSPath[[PathEnum]::Path])) {
					$this.arPSPath[[PathEnum]::Path] = $this.arPSPath[$i]
				} else {
					$this.arPSPath[[PathEnum]::Path] = Join-Path $this.arPSPath[[PathEnum]::Path] $this.arPSPath[$i]
				}
			}
		}
		if (![string]::IsNullOrEmpty($this.arPSPath[[PathEnum]::Extension])) {
			if (![string]::IsNullOrEmpty($this.arPSPath[[PathEnum]::Path])) {
				$this.arPSPath[[PathEnum]::Path] += "." + $this.arPSPath[[PathEnum]::Extension]
			} else {
				$this.arPSPath[[PathEnum]::Path] = "." + $this.arPSPath[[PathEnum]::Extension]
			}
		}
		if (![string]::IsNullOrEmpty($this.arPSPath[[PathEnum]::Stream])) {
			if (![string]::IsNullOrEmpty($this.arPSPath[[PathEnum]::Path])) {
				$this.arPSPath[[PathEnum]::Path] += ":" + $this.arPSPath[[PathEnum]::Stream]
			} else {
				$this.arPSPath[[PathEnum]::Path] = ":" + $this.arPSPath[[PathEnum]::Stream]
			}
		}
		$this.TestPathIsValid()
	}
	hidden [void]SplitPath() {
		$DirSep = [system.io.path]::DirectorySeparatorChar
		$ShareSep = [system.io.path]::DirectorySeparatorChar + [system.io.path]::DirectorySeparatorChar
		$VSep = [system.io.path]::VolumeSeparatorChar + [system.io.path]::DirectorySeparatorChar
		$FirstPathPos = 0
		for ($i = 1; $i -le 5; $i++) {
			$this.arPSPath[$i] = $null
		}
		if (-not [String]::IsNullOrEmpty($this.arPSPath[[PathEnum]::Path])) {
			# Section: Drive
			# Shares
			if ($this.arPSPath[[PathEnum]::Path].IndexOf($ShareSep) -eq 0) {
				$arPath = $this.arPSPath[[PathEnum]::Path].SubString(2).Split($DirSep)
				$this.arPSPath[[PathEnum]::Drive] = $ShareSep + $arPath[0] + $DirSep + $arPath[1]
				$FirstPathPos += 2
			} # Drives
			else {
				$DrivePos = $this.arPSPath[[PathEnum]::Path].IndexOf($VSep)
				if ($DrivePos -gt 0) {
					$arPath = $this.arPSPath[[PathEnum]::Path].SubString($DrivePos).Split($DirSep)
					$this.arPSPath[[PathEnum]::Drive] = $this.arPSPath[[PathEnum]::Path].SubString(0, $DrivePos + 1)
					$FirstPathPos++
				} else {
					$arPath = $this.arPSPath[[PathEnum]::Path].Split($DirSep)
				}
			}
			# Section: Directory
			if ($arPath.Length -gt 1) {
				if ($FirstPathPos -le $arPath.Length - 2) {
					$this.arPSPath[[PathEnum]::Directory] = ($arPath[$FirstPathPos..($arPath.Length - 2)] -join $DirSep).TrimStart($DirSep)
				}
				if ($this.arPSPath[[PathEnum]::Directory].IndexOf([system.io.path]::VolumeSeparatorChar) -ge 0) {
					$arDir = $this.arPSPath[[PathEnum]::Directory].Split([system.io.path]::VolumeSeparatorChar)
					$this.arPSPath[[PathEnum]::Directory] = $arDir[0]
					$this.arPSPath[[PathEnum]::Stream] = $arDir[1]
				}
				$this.arPSPath[[PathEnum]::Directory] += $DirSep
			}
			# Section: FileName, Extension
			if ($arPath.Length -gt 0) {
				if ($arPath[-1].IndexOf([system.io.path]::VolumeSeparatorChar) -ge 0) {
					$arFile = $arPath[-1].Split([system.io.path]::VolumeSeparatorChar)
					$this.arPSPath[[PathEnum]::Stream] = $arFile[1]
					$arPath[-1] = $arFile[0]
				}
				$arFile = $arPath[-1].Split(".")

				if ($arFile.Length -gt 0) {
					$this.arPSPath[[PathEnum]::FileName] = $arPath[-1]
				}
				if ($arFile.Length -gt 1) {
					$this.arPSPath[[PathEnum]::FileName] = $arFile[0..($arFile.Length - 2)] -join "."
					$this.arPSPath[[PathEnum]::Extension] = $arFile[-1]
				}
			}
			$this.TestPathIsValid()
		}
	}
	PSPath() {
		$this.AddVariable()
	}
	PSPath([String]$Path) {
		$this.AddVariable()
		$this.arPSPath[[PathEnum]::Path] = $Path
		$this.SplitPath()
	}

	PSPath([String]$Drive, [String]$Directory, [String]$FileName, [String]$Extension) {
		$this.AddVariable()
		$this.arPSPath[[PathEnum]::Drive] = $Drive
		$this.arPSPath[[PathEnum]::Directory] = $Directory
		$this.arPSPath[[PathEnum]::FileName] = $FileName
		$this.arPSPath[[PathEnum]::Extension] = $Extension
		$this.arPSPath[[PathEnum]::Stream] = $Null
		$this.MakePath()
	}
	PSPath([String]$Drive, [String]$Directory, [String]$FileName, [String]$Extension, [String]$Stream) {
		$this.AddVariable()
		$this.arPSPath[[PathEnum]::Drive] = $Drive
		$this.arPSPath[[PathEnum]::Directory] = $Directory
		$this.arPSPath[[PathEnum]::FileName] = $FileName
		$this.arPSPath[[PathEnum]::Extension] = $Extension
		$this.arPSPath[[PathEnum]::Stream] = $Stream
		$this.MakePath()
	}
}

class PSPathEx : PSPath {
	[Bool] $IsUNCPath
	[Bool] $IsFQDNPath
	hidden [void]TestUNCPath() {
		$this.IsUNCPath = $false
		if (([PSPath]$this).IsPathValid) {
			if (([PSPath]$this).arPSPath[[PathEnum]::Path].IndexOf(([system.io.path]::DirectorySeparatorChar + [system.io.path]::DirectorySeparatorChar)) -eq 0) {
				$this.IsUNCPath = $true
			}
		}
	}
	hidden [String]GetDNSName() {
		try {
			$HostName = ([PSPath]$this).arPSPath[[PathEnum]::Drive].Trim([system.io.path]::DirectorySeparatorChar).Split([system.io.path]::DirectorySeparatorChar)[0]
			$FQDNName = ((Resolve-DNSName ((Resolve-DNSName $HostName | Where-Object { $_.Section -match 'Answer' }).IPAddress)) | Where-Object { $_.Section -match 'Answer' } | ForEach-Object { $_.NameHost })
			if ([String]::IsNullOrEmpty($FQDNName)) {
				return $null
			}
			return $FQDNName
		} catch {
			return $null
		}
	}
	hidden [void]TestFQDNPath() {
		$this.IsFQDNPath = $false
		if ($this.IsUNCPath) {
			#$FQDNName = $this.GetDNSName()
			$HostName = ([PSPath]$this).arPSPath[[PathEnum]::Drive].Trim([system.io.path]::DirectorySeparatorChar).Split([system.io.path]::DirectorySeparatorChar)[0]
			#if(([PSPath]$this).arPSPath[[PathEnum]::Drive] -match $FQDNName){
			#	$this.IsFQDNPath = $true
			#}
			if ($HostName -match '(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)') {
				$this.IsFQDNPath = $true
			}
		}
	}
	[void]MakeFQDNPath() {
		if (!$this.IsFQDNPath) {
			$Drive = ([PSPath]$this).arPSPath[[PathEnum]::Drive]
			if (-not [String]::IsNullOrEmpty($Drive)) {
				$HostName = $Drive.Trim([system.io.path]::DirectorySeparatorChar).Split([system.io.path]::DirectorySeparatorChar)[0]
				$FQDNName = $this.GetDNSName()
				if (-not [String]::IsNullOrEmpty($FQDNName)) {
					([PSPath]$this).arPSPath[[PathEnum]::Drive] = $Drive.replace($HostName, $FQDNName)
					([PSPath]$this).MakePath()
					$this.IsFQDNPath = $true
				}
			} else {
				$this.IsFQDNPath = $false
			}
		}
	}
	hidden [void]MakePath() {
		([PSPath]$this).MakePath()
		$this.TestUNCPath()
		$this.TestFQDNPath()
	}
	hidden [void]SplitPath() {
		([PSPath]$this).SplitPath()
		$this.TestUNCPath()
		$this.TestFQDNPath()
	}
	PSPathEx() : base() {
	}
	PSPathEx([String]$Path) : base($Path) {
	}
	PSPathEx([String]$Drive, [String]$Directory, [String]$FileName, [String]$Extension) : base($Drive, $Directory, $FileName, $Extension) {
	}
	PSPathEx([String]$Drive, [String]$Directory, [String]$FileName, [String]$Extension, [String]$Stream) : base($Drive, $Directory, $FileName, $Extension, $Stream) {
	}
}
