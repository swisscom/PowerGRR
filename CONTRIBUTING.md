# Contributing to PowerGRR

Great, you decided to contribute! That's awesome!

Please file an [issue](https://github.com/swisscom/PowerGRR/issues) if you
need a new feature or found an inconvenient "situation" (bug) or get the code
form Github, make a new branch, extend the functionality as its needed and
make a [pull request](https://github.com/swisscom/PowerGRR/pulls). See
section [repo structure](https://github.com/swisscom/PowerGRR#repo-structure)
for an overview about the main files.

Please use the guidelines as references when implementing new functions and
check current cmdlets how to use supporting functions.

* [PowerShell scripting best practices](https://blogs.technet.microsoft.com/pstips/2014/06/17/powershell-scripting-best-practices/)
* [Building-PowerShell-Functions-Best-Practices](http://ramblingcookiemonster.github.io/Building-PowerShell-Functions-Best-Practices/)
* [Strongly Encouraged Development Guidelines](https://msdn.microsoft.com/en-us/library/dd878270(v=vs.85).aspx)
* [Approved Verbs for Windows PowerShell Commands](https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx)
* [How to Write a PowerShell Module Manifest](https://msdn.microsoft.com/en-us/library/dd878337(v=vs.85).aspx)
* [Windows PowerShell: Writing Cmdlets in Script](https://technet.microsoft.com/en-us/library/ff677563.aspx)

## Adding a new feature

1. Implement feature in respect to the guidelines mentioned above.
1. Add corresponding Pester tests in /test/Pester.
1. Add the name of a new cmdlet which is used by the users to the
   **Export-ModuleMember** list at the end of the module file (.psm1).
1. Add the name of a new cmdlet to the **FunctionsToExport** list in the module
   description file (.psd1).
1. Add relevant notes to the [CHANGELOG](CHANGELOG.md).
1. Add a new markdown help file in /docs with examples. See [BUILD](BUILD.md)
   for information about generating the help file. 
1. Update the external help file. See [BUILD](BUILD.md) for
   information about generating the help file. 
1. Update README if needed (e.g. available flows).
1. Update tag file if needed. See [BUILD](BUILD.md) for
   information about generating the tag file.

## Making a new Release

1. Run the Pester tests. See [BUILD](BUILD.md). All should pass.
1. Update CHANGELOG 
    * Update information according to the current release.
    * Add new **Unreleased** section and update the link for comparison.
    * Add the new version number in the old unreleased section.
    * Add the version comparison link to the current release changelog section.
    * Add the current date at the end of the new header row
1. Update **ModuleVersion** in the module description file (.psd1).
1. Set a tag for the new version (e.g. "vx.x.x").
1. Push the tag and the changes to the repo.
1. Publish the new module version to PowerShell gallery
    * Make a clean folder for PowerGRR in the module path.
    * Add the psm1, psd1 and the external help (en-us) to that PowerGRR module
        folder.
    * Run the following command to publish the module to the PowerShell gallery.

``` powershell
Publish-Module -Name PowerGRR -NuGetApiKey <apiKey> 
```

The module is currently located at https://www.powershellgallery.com/packages/PowerGRR.
