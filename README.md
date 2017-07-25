![alt text](media/powergrr.png "PowerGRR Logo")

# PowerGRR - PowerShell Module for GRR API

Please see [Command Documentation](docs/PowerGRR.md) and
[CHANGELOG](CHANGELOG.md).

***

## What is PowerGRR?

PowerGRR is a PowerShell module for working with the GRR API. It allows
working with flows, hunts, labels and the GRR search feature. Furthermore, it
allows working with the computer names instead of the GRR internal client id.
This makes handling and working with other tools more easy because often
you just have the computer names. PowerGRR also enables you to easily
document your work in text form which is then directly reusable by others.

PowerGRR creates a comfortable, cli-based workflow for incident response.
PowerShell is installed on every Windows workstation and working directly with
PowerShell objects enables you to sift quickly through flow and hunt data.
This object-oriented approach gives you a fast way to analyze output
within PowerShell, e.g. get all unique registry paths from a hunt or show a
list of unique clients where a file was found.

Some of the use cases where PowerGRR could speed up the work:
* Start a flow on one or multiple clients and get flow results as PowerShell
    object for easier filtering.
* Create and start a new hunt and get the hunt info or results as PowerShell
    objects
* Add or remove a label on one or multiple clients based on a list of computer
    names.
* List hunts, labels or clients and filter them in different ways.
* Build IR scripts for common forensic workflows and start multiple hunts or
    flows in one shot using multiple cmdlets inside a PowerShell script.

The following plugins are available for hunts and flows and the target group
is chosen based on labels or the OS.
* "Netstat","ListProcesses","FileFinder","RegistryFinder","ExecutePythonHack"

### Repo Structure

| Name              | Description                                                        |
| ----------------  | ------------------------------------------------------------------ |
| docs\             | Markdown documentation                                             |
| en-us\            | With playPS created PowerShell helpfile (use `help <command>`)   |
| test\             | Pester tests (for using with Invoke-Pester)                        |
| BUILD.md          | Build instructions for ctags, playPS and Pester                    |
| CHANGELOG.md      | Changelog of the project                                           |
| PowerGRR.psd1     | PowerGRR module description                                        |
| PowerGRR.psm1     | PowerGRR module file                                               |
| tags              | ctags file for PowerGRR                                            |

## Installation

### Download
Clone the repo into your module path folder, usually
"~\Documents\WindowsPowerShell\modules" (see $env:PSModulePath) or clone
the files to any other folder (could be a share or the local disk). The
location changes how the module is imported.

### Configuration

Create a Configuration.ps1 file in the root folder of the project. Set the
following variables as needed:

``` PowerShell
# Ignore certificates - if set to $true certificate errors are ignored
$GRRIgnoreCertificateErrors = $false

# Client certificate issuer - if not set no client certificates are used.
# Otherwise the client certificate from the given issuer is used.
$GRRClientCertIssuer = "issuer of the certificate"

# GRR Url
$GRRUrl = "https://grrserver.tld"
```

You can also define the variables in the shell before importing the module
without having the file Configuration.ps1.

## Usage

### Importing the module

If PowerGRR was saved inside the module path run the following command:
```
Import-Module PowerGRR -force
```

If PowerGRR was saved outside the module path run the command:

```
Import-Module <path to module>\PowerGRR.psd1 -force
```

### Authentication

Store your GRR credentials for any subsequent PowerGRR command or otherwise
you will be prompted when running the commands.

```powershell
$creds = Microsoft.PowerShell.Security\get-credential
```

### Cmdlets

Please see [docs](docs/PowerGRR.md) for further information and the list of
all available commands.

Use the common parameters like -WhatIf or -Verbose for troubleshooting and to
see what the commands would do. WhatIf is only used for "destructive" cmdlets.

List available PowerGRR commands.

```powershell
get-command -Module PowerGRR
```

List all PowerGRR commands for flows.

```powershell
get-command -Module PowerGRR | sls flow
```

### Help

Use `help <command>` to get the help for a command.

```powershell
PS> help Get-GRRHuntInfo
...
SYNTAX
    Get-GRRHuntInfo [[-HuntId] <string>] [-Credential] <pscredential> [[-cert] <string>] [-WhatIf] ...
...
```

Use `help <command> -Examples` to get examples for a command.

```powershell
PS> help Get-GRRHuntInfo -Examples

NAME
    Get-GRRHuntInfo

OVERVIEW
    Get hunt info for a specific hunt.

    Example 1

    PS C:\> Get-GRRHuntInfo "H:AAAAAAAA" -Credential $cred
...
```

### Example

The following examples shows how you could combine the different PowerGRR functions
to quickly label some clients, start a flow against them (yes, you could also
build a hunt based on a label) and read the results.

```powershell
# Read the client information to check LastSeenAt and the OSVersion
Get-GRRClientIdFromComputerName -ComputerName WIN-DESKTOP01,MBP-LAPTOP02,WIN-DESKTOP03,WIN-DESKTOP04 `
                                -Credential $creds
 
ComputerName    ClientId           LastSeenAt          OSVersion
------------    --------           ----------          ---------
WIN-DESKTOP01   C.aaaaaaaaaaaaaaaa 18.05.2017 15:48:17 10.0.10586
WIN-DESKTOP01   C.xxxxxxxxxxxxxxxx 03.04.2017 14:55:37 6.1.7601
MBP-LAPTOP02    C.bbbbbbbbbbbbbbbb 18.05.2017 15:49:12 16.6.0
WIN-DESKTOP03   C.dddddddddddddddd 11.03.2017 10:23:51 10.0.10586
WIN-DESKTOP04   C.eeeeeeeeeeeeeeee 11.03.2017 10:23:51 10.0.10586

# Set a label for multiple hosts during incident response with the parameter
# __ComputerName__
Set-GRRLabel -ComputerName WIN-DESKTOP01, WIN-DESKTOP03, WIN-DESKTOP04 -Label INC02_Windows -Credential $creds
# or through the pipeline
"MBP-LAPTOP02" | Set-GRRLabel -Label INC02_macOS -Credential $creds

# Now you can work with that label within GRR UI or in the shell. Use
# -OnlyComputerName to only display the hostname instead of the full GRR client
# object
$clients = Find-GRRClientByLabel -SearchString INC01 -Credential $creds -OnlyComputerName

# Start a flow on the affected clients
$clients | Invoke-GRRFlow -flow RegistryFinder `
                          -key "HKEY_USERS/%%users.sid%%/Software/Microsoft/Windows/CurrentVersion/Run/*" `
                          -Credential $cred

# Get flow results - see output of specific flow ids. Using
# -OnlyPayload navigates directly to the payload section of the results
# within the returned GRR object
$res = Get-GRRFlowResult -Credential $cred -ComputerName WIN-DESKTOP01 -FlowId "F:11111111" -OnlyPayload

# Show only the registry paths from the returned GRR object. Sometimes the
# output is base64 encoded. Get-GRRFlowResult decodes the string if
# possible. 
$ret.stat_entry.registry_data

# Alternative you can start a hunt against that label. The EmailAddress
# parameter is optional and notifies you about the first hit. The OnlyUrl
# parameter shows only the URL to the hunt.
New-GRRHunt -HuntDescription "Search for notepad.exe" `
            -Flow FileFinder `
            -path "c:\notepad.exe" `
            -MatchMode MATCH_ALL `
            -actiontype hash `
            -RuleType label `
            -Label INC01 `
            -EmailAddress your@email.tld `
            -Credential $creds `
            -OnlyUrl `
            -Verbose

Start-GRRHunt -Credential $creds -HuntId H:AAAAAAAA

# Read hunt restuls
Get-GRRHuntResult -Credential $cred -HuntId "H:AAAAAAAA"

# Remove the label if you don't use it anymore
$clients | Remove-GRRLabel -SearchString INC01 -$Credential $creds
```

## Limitations

Currently, only pre-defined flows are available. See [command
help](https://github.com/swisscom/PowerGRR/blob/master/docs/Invoke-GRRFlow.md#-flow)
for the available flow types. 

## Contribution

Please use the guidelines as references when implementing new functions.

* [PowerShell scripting best practices](https://blogs.technet.microsoft.com/pstips/2014/06/17/powershell-scripting-best-practices/)
* [Building-PowerShell-Functions-Best-Practices](http://ramblingcookiemonster.github.io/Building-PowerShell-Functions-Best-Practices/)
* [Strongly Encouraged Development Guidelines](https://msdn.microsoft.com/en-us/library/dd878270(v=vs.85).aspx)
* [Approved Verbs for Windows PowerShell Commands](https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx)
* [How to Write a PowerShell Module Manifest](https://msdn.microsoft.com/en-us/library/dd878337(v=vs.85).aspx)
* [Windows PowerShell: Writing Cmdlets in Script](https://technet.microsoft.com/en-us/library/ff677563.aspx)
