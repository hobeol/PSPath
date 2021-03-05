# PSPath

PSPath module.
Working with path in powershell is not much convenient. I like Microsoft´s version of `makepath()` and `splitpath()` in C. Here you get all in one powershell class.

## Instructions

This module can be loaded as-is by using module PSPath.psd1. This is mainly intended for development purposes.

To speed up module load time and minimize the amount of files that needs to be signed, distributed and installed, this module contains a build script that will package up the module into four files:

- PSPath.psd1
- PSPath.psm1
- PSPath.format.ps1xml
- license.txt

To build the module, make sure you have the following pre-req modules:

- Pester (Required Version 4.1.1)
- InvokeBuild (Required Version 3.2.1)
- PowerShellGet (Required Version 1.6.0)
- ModuleBuilder (Required Version 1.0.0)

Start the build by running the following command from the project root:

```powershell
Invoke-Build
```

This will package all code into files located in .\bin\PSPath. That folder is now ready to be installed, copy to any path listed in you PSModulePath environment variable and you are good to go!
Example: Copy-Item .\bin\PSPath\ $PSHOME\Modules\ -Recurse # You may need admin rights!


## Why classes

Classes provides a lot of features - more than only using functions. Additional work can be done in the constuctors of the class or at the assignment of their members.

## Using the classes PSPath and PSPathEx

Because PSPath is a class module you can not use the cmdlet Import-Module. To load the module there is a new statement:

```powershell
using module PSPath
```

> (!) The using statement must be located at the very top of your script. It also must be the very first statement of your script (except of comments). This makes loading the module 'conditionally' impossible.

But there is an alternate way:

```powershell
. $([ScriptBlock]::Create("using module PSPath")) #At any line in your script
```
Let´s try it:

```powershell
# load module
using module PSPath

# a classic path name
$TestPath = "C:\Test\Folder02\File04.txt"

# forgotten to load module?
#. $([ScriptBlock]::Create("using module PSPath")) # uncomment this line

# create a new instance
$T = [PSPath]::new($TestPath)
$T
$T.Directory = "Test\Test\Text.txt"
$T
$T.Path
```

Output:

```
Path                           Drive Directory                 FileName Extension Stream IsPath
                                                                                         Valid
----                           ----- ---------                 -------- --------- ------ ------
C:\Test\Folder02\File04.txt    C:    Test\Folder02\            File04   txt              True
C:\Test\Test\Text.txt\File04.… C:    Test\Test\Text.txt        File04   txt              True
C:\Test\Test\Text.txt\File04.txt
```

---

Maintained by Holger Behmann
