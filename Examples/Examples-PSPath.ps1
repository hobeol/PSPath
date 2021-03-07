$TestPath = "C:\Test\Folder02\File04.txt"
$TestPath
#using module PSPath - late setup
. $([ScriptBlock]::Create("using module PSPath"))

$T = [PSPath]::new($TestPath)
$T
$T.Directory = "Test\Test\Text.txt"
# show $T as table (default)
$T
# show $T as list
$T | Format-List
# create a new empty element
$S = [PSPath]::new()
# show $S
$S
# assign path
$S.Path = "\\localhost\C$\PSPathTest\"
# show $S - Now the member "drive" contains the server/share part of an UNC path
$S | Format-List
# create new folder if path syntax is valid and folder doesn't exists
if($S.IsPathValid -and -not (Test-Path $S.Path)){New-Item $S.Path -ItemType Directory}
# list folder/directory
Get-ChildItem $S.Path
# create a new folder
$S.Directory += "Folder01\"
if($S.IsPathValid -and -not (Test-Path $S.Path)){New-Item $S.Path -ItemType Directory} # same as above
# create a file
$S.FileName += "File01.txt"
if($S.IsPathValid -and -not (Test-Path $S.Path)){New-Item $S.Path}
$S | Format-List
# if you wonder $S.FileName contais an extension you easily can correct it
$S.Path = $S.Path
$S | Format-List
# let's add an alternate data stream
$S.Stream = "teststream"
"This is the content of an ADS." >> $S.Path
Get-Content $S.Path
$S
# do some thing "illegal"
$T = [PSPath]::new("C::")
$T
$T = [PSPath]::new("C::","PSPath::Test","Fi<le>01","t|t")
$T
$T = [PSPath]::new("C:","PSPath::Test","Fi<le>01","t|t")
$T
$T = [PSPath]::new("C:","PSPathTest","Fi<le>01","t|t")
$T
$T = [PSPath]::new("C:","PSPathTest","File01","t|t")
$T
$T = [PSPath]::new("C:","PSPathTest","File01","txt")
$T
$T = [PSPath]::new("C:","PSPathTest","File01","txt","str::eam")
$T
