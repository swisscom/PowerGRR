# BUILD

## Testing

Run all the tests:

`Invoke-Pester .\test\ `

To use the code coverage assessment use `-CodeCoverage`:

`$res = Invoke-Pester .\test\ -CodeCoverage ..\PowerGRR.psm1 -PassThru`

The result can be read in the following manner:

``` powershell
PS> $res.TotalCount
11
PS> $res.FailedCount
0
PS> $res.PassedCount
11
```

## Source Code Analyzer

`Invoke-ScriptAnalyzer -Path .\PowerGRR\ `

## Module Manifest
Create new module manifest

``` powershell
New-ModuleManifest -Path .\PowerGRR.psd1 -RootModule PowerGRR.psm1 -Author "Swisscom (Schweiz) AG" -CompanyName 'Swisscom (Schweiz) AG' -ModuleVersion '0.1.0'
```

## Generating Help

### New Markdown Help

Build the markdown help with the following commands for a new documentation or
for a new cmdlet in later stages.

1. Import module
``` powershell
Import-Module .\PowerGRR.psd1 -Force
```

2. Create new markdown help for module...
``` powershell
New-MarkdownHelp -Module PowerGRR -OutputFolder .\docs\ -WithModulePage -Force -HelpVersion "1.0.0.0"
```

3. or create a markdown file for a specific cmdlet
``` powershell
New-MarkdownHelp -Command Get-GRRLabel -OutputFolder .\docs\ -OnlineVersionUrl "https://github.com/swisscom/powergrr/docs/Get-GRRLabel.md" 
```

For updating the markdown help use instead the following commands

### Update Markdown Help

To update the markdown use the following commands.

``` powershell
Import-Module .\PowerGRR.psd1 -Force
Update-MarkdownHelp .\docs\
```

### PowerShell External Help

Use the following command to create the PowerShell external help file (use `-force` to
update an existing external help file).

``` powershell
New-ExternalHelp -Path .\docs\ -OutputPath en-us\ -Force
```

## Tags file for PowerShell

### PowerShell
Use the following [ctags](http://ctags.sourceforge.net/ctags.html) configuration for PowerShell.
Run the command within the PowerGRR root directory.

ctags.cnf (variables disabled through the regex)

```
--langdef=powershell
--langmap=powershell:.psm1.ps1
--regex-powershell=/function\s+(script:)?([a-zA-Z\-]+)/\2/m, method/i
--exclude=test
```

Use the folloging ctags command to generate the PowerShell tags.


```
ctags -R --languages=powershell
```

### Pester

Use the following [ctags](http://ctags.sourceforge.net/ctags.html) configuration for Pester. Run
the command within the Pester test directory.

```
ctags -R --langdef=pester --langmap=pester:.ps1 --regex-pester="/describe\s+'(.*)'/\1/m, method/i"
```

## References
* [Pester](https://github.com/pester/Pester)
* [platyPS](https://github.com/PowerShell/platyPS)
* [New-ModuleManifest](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/new-modulemanifest)
* [Update-ModuleManifest](https://msdn.microsoft.com/powershell/reference/5.1/PowerShellGet/Update-ModuleManifest)
