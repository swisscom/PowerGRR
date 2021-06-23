# CHANGELOG
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased](https://github.com/swisscom/powergrr/compare/v0.11.0...master)

### Added

* Add pathtype parameter to FileFinder flow which allows using TSK (deprecated) 
  or NTFS to access locked files, used for e.g. registry files or $MFT on Windows.

### Changed
* Update CHANGELOG, docs and external help file

<!--
### Fixed
### Security
### Deprecated
### Removed
-->

## [v0.11.0](https://github.com/swisscom/powergrr/compare/v0.10.0..v0.11.0) - 2021-06-02

Add new command for getting all the flows and improve Yara rule handling.

### Added
* Add `Get-GRRFlow` for listing all flows of a specific client.

### Changed
* Update external help file.

### Fixed
* Fix hunt id return value format in `Get-GRRHunt`.
* Fix backslash escaping in Yara rule handling

## [v0.10.0](https://github.com/swisscom/powergrr/compare/v0.9.1..v0.10.0) - 2021-03-22

Add further flow and hunt handling commands and fix an API issue in Invoke-GRRFlow.

### Added
* Add `Get-GRRFlowInfo` for reading flow state and general flow information.
   This is the counterpart for `Get-GRRHuntInfo` which already exists.
* Add pipeline support and allow using multiple hunt ids when calling
   `Get-GRRHuntInfo`.
### Changed
* Update markdown and PowerShell help
* Improve time handling in `ConvertFrom-EpocTime`
* Improve string handling in `ConvertTo-Base64`
### Fixed
* Fix flow ID return value in `Invoke-GRRFlow`

## [v0.9.1](https://github.com/swisscom/powergrr/compare/v0.9.0...v0.9.1) - 2019-04-04

Fix API field name for computer name from "node" to "fqdn" which was changed in
newer GRR versions. Furthermore, fix issue when usernames are missing in client
info (`Get-GRRClientInfo`).

## [v0.9.0](https://github.com/swisscom/powergrr/compare/v0.8.0...v0.9.0) - 2018-05-19

**Improve password handling** by allowing to **set the `$GRRCredential` variable
with the credential in the console** which is then used by all subsequent command
calls. The use of `-Credential` is therefore not needed anymore. For **better
converting the unix timestamp**, the function `ConvertFrom-EpocTime` was
added. Additionally, **improve PowerShell help**.

### Added
* Add functionality to read credentials from
    environment (`$GRRCredential`) if available instead of prompting the user
    when `-Credential` isn't supplied
    ([#22](https://github.com/swisscom/PowerGRR/issues/22)). Use the new
    function `Get-GRRCredential` as default value for that purpose.
* Add parameter `-UseTsk` to ArtifactCollectorFlow to allow collecting special
  files like registry files.
### Changed
* Update PowerShell help file with further examples.
* Rename `Get-EpocTimeFromUtc` to `ConvertFrom-EpocTime`, add pipeline support
    and export the function. Use `ConvertFrom-EpocTime` to convert unix
    timestamps to UTC, e.g. in a registry flow, convert the st_mtime value
    within PowerShell.

## [v0.8.0](https://github.com/swisscom/powergrr/compare/v0.7.0...v0.8.0) - 2018-02-21

Add the **functionality for using a condition in RegistryFinder flow** and **add the
Yara process memory scan flow**. Extend and improve getting and displaying
client information. Fix some issues within RegistryFinder flow, hunt
definition and formatting in `Invoke-GRRFlow`.

### Added
* Add condition functionality to RegistryFinder flow
* Add YaraProcessScan flow
* Add `Get-GRRClientInfo` to display various information about a
  specific client based on the hostname

### Changed
* Improve output in `Get-GRRComputerNameFromClientId`

### Fixed
* Fix uninitialized variables in `Get-GRRSession` and `Invoke-GRRRequest`
    (Thanks to @Se1ecto)
* Fix issue with registry path definition in RegistryFinder flow
* Fix bug when client limit not getting set correctly 
* Fix output formatting issue when using the pipeline in `Invoke-GRRFlow`

## [v0.7.0](https://github.com/swisscom/powergrr/compare/v0.6.0...v0.7.0) - 2018-01-19

Improve payload conversions, add file content conditions for file finder and
update result count functionality for hunt info according to added fields in
overview. Extend existing approval state commands with new wait functions.

### Added
* Add **support for converting an input string into a hex string**
    (`ConvertTo-Hex`). This is useful e.g. for hash_entry payloads where the
    hashes must be converted first to base64 and then to hex.
* Add **support for file content conditions in FileFinder flow**. Add new dynamic
    parameters for ConditionType, Mode and SearchString and allow the use of
    regex or literal content searches.
* Add support for UTF8 and Unicode encoding in `ConvertFrom-Base64`.
* Display hostnames which were not found in GRR in
   `Get-GRRClientIdFromComputerName`
* Add new parameter `ShowResultCount` in `Get-GRRHuntInfo` to also query hunt
    results and its property  "total_count" and add that value to the hunt
    infos. See section removed below for further information.
* Add new wait commands (`Wait-GRRClientApproval` and `Wait-GRRHuntApproval`)
    extending the existing approval commands introduced in version 0.6.0. Now
    it's not needed anymore to use a custom while loop for waiting for the
    approvals. Specify the timeout in minutes as needed.
* Add _-Wait_ switch to `Start-GRRHunt` for waiting for the specified approval
    before starting the hunt.
* Add `Get-FlowArgs` for building flow arguments and `Get-DynamicFlowParam`
  for generating the dynamic flow parameters and use these functions for
  shared code in `Invoke-GRRFlow` and `New-GRRHunt`.

### Removed
* Removed second GRR API call in `Get-GRRHuntInfo` for result
   count by default because in newer versions (3.2.x.x) of the GRR server the result
   count is shown in the hunt overview with the added properties
   `clients_with_results_count` and `results_count` (see
   issue [#516](https://github.com/google/grr/issues/516) or corresponding
   [commit](https://github.com/google/grr/commit/35797795b9088e3378c91c82a109651d8b8edb6e)).
   The new count field only works for new hunt results. Old hunt results are not
   covered with the new fields - use the added parameter `ShowResultCount` in
   `Get-GRRHuntInfo` for these hunts.

## [v0.6.0](https://github.com/swisscom/powergrr/compare/v0.5.0...v0.6.0) - 2017-09-14

Add support for **reading client or hunt approvals and their state**. This
allows using a loop until an approval gets valid and starting the
desired actions directly without the need for checking the state and
starting the next command manually. What was the
[Splunk tag line](https://www.splunk.com/blog/2010/04/23/splunk-tag-lines.html)
again..."PowerGRR, because Ninjas are too busy".

### Added
* **Add functions `Get-GRRClientApproval` and `Get-GRRHuntApproval` for getting
  requested client or hunt approvals**. Filter them in different ways with the
  given parameters or get a list of all approvals and use PowerShell for
  filtering. **Tip:** Use the switch _-OnlyState_ to only show the state of the
  given approvals. See example in the help for the available filter parameters
  and the wiki for some use cases.
* Add parameter _-OnlyId_ in `New-GRRHunt` for returning only the hunt id.

## [v0.5.0](https://github.com/swisscom/powergrr/compare/v0.4.2...v0.5.0) - 2017-08-16

Add support for certificate authentication based on certificate files. This
allows using certificate authentication with PowerShell Core and especially on
non-Windows platforms. Use the new config option to set the certificate file path.
Furthermore, commands for uploading artifacts to GRR and removing them from
GRR were added.

### Added

* **Add support for certificate authentication when using PowerShell Core**.
  Certificate authentication was broken due to the (not surprisingly)
  missing cert store and the missing special "Cert:" PSDrive on *nix OSes.
  Besides using the Windows cert store it's now possible to use certificate
  files for the authentication. See section
  [certificate authentication](README.md#certificate-authentication) and
  [configuration](README.md#configuration) in the readme.
* Add **config option for the client certificate path** to handle
  certificate authentication based on files (_GRRClientCertFilePath_).
* Add `Add-GRRArtifact` for **uploading new artifacts to GRR**. Tested with
  Windows PowerShell v5 and PowerShell Core 6.0.0-beta.5 on Windows and PowerShell
  Core 6.0.0-beta.5 on macOS.
* Add `Remove-GRRArtifact` for **removing one or multiple artifacts from GRR**.
* Add base64 encoding function (`ConvertTo-Base64`) which is used for
  manual basic authentication to mitigate missing basic authentication in
  PowerShell Core cmdlets, see section fixed below.
* Add supporting function `Get-ValidatedGRRArtifact` and use the function
  inside of `Invoke-GRRRequest` and `Remove-GRRArtifact` to verify given
  artifacts against the artifact repository in GRR.

### Fixed
* **Fix an issue in the basic authentication when using PowerShell Core** ([#11](https://github.com/swisscom/PowerGRR/issues/11)).
  The credential parameter for the WebCmdlets (`Invoke-RestMethod` and
  `Invoke-WebRequest`) in PowerShell Core does not support basic
  authentication. See PowerShell Core issue
  [#4274](https://github.com/PowerShell/PowerShell/issues/4274). The credential
  handling was changed to explicitly use basic authentication headers in web
  requests instead of using the _-Credential_ parameter. The change allows
  using the same authentication code on Windows and on non-Windows platforms.
  The authentication was tested on Windows with PowerShell v5, Windows with
  PowerShell Core and Ubuntu with PowerShell Core.

## [v0.4.2](https://github.com/swisscom/powergrr/compare/v0.4.1...v0.4.2) - 2017-08-08

Fix bug in `Get-ClientCertificate` when using `Get-Variable`. Make the
certificate authentication working again.

## [v0.4.1](https://github.com/swisscom/powergrr/compare/v0.4.0...v0.4.1) - 2017-08-08

Fix typo in variable name in `Invoke-GRRFlow` for flow type _FileFinder_.

## [v0.4.0](https://github.com/swisscom/powergrr/compare/v0.3.0...v0.4.0) - 2017-08-07

:tada: **Add support for macOS and Linux** :tada:

In general, the open source implementation of PowerShell for non-Windows platforms
is mostly working in the exact same way as on Windows. However, some minor
issues have been fixed in order to support :apple: and :penguin: - a slightly
different certificate error handling was implemented and the user profile
environment variable changed...easy, isn't it?

### Added
* Add support for macOS and Linux. Some OS checks were added 
    and a slightly different certificate error handling was implemented.
* Add correct userprofile config location for macOS and Linux.
* Add new parameters _ClientRate_ and _ClientLimit_ to `New-GRRHunt`. By
  default client rate is set to 20 and client limit is set to 100.

### Changed
* Set parameters _HuntDescription_ and _RuleType_ to mandatory in `New-GRRHunt`.

### Fixed
* Improve error handling when the server returns no items in
  `New-GRRClientApproval` and when no labels were found in `New-GRRHunt` when
  using RuleType _Label_.
* Fix error handling in `Get-GRRSession` when web request fails.

## [v0.3.0](https://github.com/swisscom/powergrr/compare/v0.2.1...v0.3.0) - 2017-07-31

This version changed the config file handling. PowerGRR **supports now
the user profile or the module root as locations for the config file**. This
is useful when updating PowerGRR through with `Update-Module` because each
version is stored in an own folder. Using the profile folder for the config
prevents from constantly moving your config file. Beside the file name change
different improvements were made in regards to config checks.

The dynamic parameters which are used in `Invoke-GRRFlow` and `New-GRRHunt`
are now autocompleted correctly. The change in the parameter handling
mitigates a PowerShell bug, see details below.

The dynamic parameters in `New-GRRHunt` were improved. The 'OS' and the
'Label' parameter are now defined as dynamic parameters and are only shown
based on the corresponding rule type. Furthermore, the label handling was
improved to only run a hunt if at least one label was valid (that means found
in GRR).

### Added
* Add and improve Pester tests in `Invoke-GRRFlow` and `Get-GRRArtifact`
    * Add tests for _ArtifactCollectorFlow_ and _ExecutePythonHack_ flow
    * Improve tests when no response was returned from `Invoke-GRRRequest`
* Add function and corresponding help file for reading the current loaded
  config (`Get-GRRConfig`).

### Changed
* Change the name of the configuration file from
   'Configuration.ps1' to 'powergrr-config.ps1'. PowerGRR supports now having
   the config file also in the profile folder (`$env:userprofile`) and not only
   within the root of the module
   ([#7](https://github.com/swisscom/PowerGRR/issues/7)). This allows the use
   of  PowerShellGallery's _update-module_ function more easily because each
   version is saved in a dedicated folder.
* Improve dynamic parameter handling in `New-GRRHunt`. Add 'OS' and 'Label' as
    dynamic parameters.
* Make the parameter _FileNameRegex_ as optional and use '.' as default value
  in New-GRRHunt and in corresponding section in Invoke-GRRFlow.

### Deprecated
* The configuration file name 'Configuration.ps1' was deprecated. The new name
    is 'powergrr-config.ps1'. This change was introduced to make things ready
    for storing the config file within the user profile.

### Fixed
* Fix issue with dynamic parameter autocompletion in `Invoke-GRRFlow` and
  `New-GRRHunt` ([#6](https://github.com/swisscom/PowerGRR/issues/6)). After
  using a parameter of type `PSCredential` within a PowerShell command, the
  dynamic parameters were not autocompleted anymore. The
  [issue](https://github.com/PowerShell/PowerShell/issues/3984) is known and
  was already reported the PowerShell team. PowerGRR doesn't use the
  _PSCredential_ parameter anymore for the mentioned functions but checks the
  credentials in the code.
* Improve error handling in `Invoke-GRRFlow` and `Get-GRRArtifact`
    * when no artifacts were found
    * when no available artifact matched with the given one in the parameters
* Fix bug in `Get-GRRArtifact` when no items were returned
  by `Invoke-GRRRequest`

## [v0.2.1](https://github.com/swisscom/powergrr/compare/v0.2.0...v0.2.1) - 2017-07-28

Fix bug in ExecutePythonHack flow and make that great feature working
again in PowerGRR.

## [v0.2.0](https://github.com/swisscom/powergrr/compare/v0.1.0...v0.2.0) - 2017-07-27

This version introduces the **ArtifactCollectorFlow** and the handling of GRR
artifacts and the possibiliy to use the **OS rule type** within flows and hunts.
It's now possible with `Get-GRRArtifact` to **filter and search for specific
artifacts**. The return object is a custom PowerShell objects with the most
important fields.

### Added
* Add examples to the markdown help files and PowerShell help. Use `help
    <command> -Examples` to show the example from the help.
* Add rule type 'OS' to `New-GRRHunt`. Use os_windows, os_linux or os_darwin
    as filter ([#3](https://github.com/swisscom/PowerGRR/issues/3)).
* Add cmdlet for getting a list of all available flows
    (`Get-GRRFlowDescriptor`) and add corresponding Pester tests ([#4](https://github.com/swisscom/PowerGRR/issues/4)).
* Add flow type **ArtifactCollectorFlow** in `Invoke-GRRFlow` and 
  `New-GRRHunt` ([#2](https://github.com/swisscom/PowerGRR/issues/2)). The
  artifacts are checked against the available artifacts within GRR. If not
  defined, the artifact is skipped.
* Add cmdlet `Get-GRRArtifact` for getting a list of all available artifacts 
  ([#5](https://github.com/swisscom/PowerGRR/issues/5)). Internally, this
  function is used within `Invoke-GRRFlow` and `New-GRRHunt` to check if the
  given artifacts for ArtifactCollectorFlow are defined within GRR.

### Fixed
* Fix bug when GRRIgnoreCertificateErrors is not set in the config file ([#1](https://github.com/swisscom/PowerGRR/issues/1)).
* Fix bug with uninitialized variable when using WhatIf in `Invoke-GRRFlow`

## [v0.1.0](https://github.com/swisscom/powergrr/tree/v0.1.0) - 2017-07-21

Initial public release.

This initial version includes functions for hunts, flows, client
handling, search functionality and label handling. All function takes the
computer name as input which is then converted to the needed client id
internally. If multiple client id's are available for one client then the
functions use just the latest seen client (__LastSeenOn__ property). 

Most functions allow returning plain JSON instead of the converted GRR object.
Various functions has pipeline support. See help
and the markdown documentation. The configuration allows using certificate
authentication.

### Added
* Add basic project structure for Pester tests and markdown documentation
  with platyPS. Add initial external documentation for PowerShell.
* Add Pester tests for different functions (heavily work in progress).
* Add functions for hunt handling
    * `Get-GRRHunt`: Display all hunts using a custom output PowerShell objects,
			allowing filtering for dates, creators etc. Use filers like count,
            created by, description, ...
	* `Get-GRRHuntInfo`: Get new hunt info in form of a PowerShell object.
	* `Get-GRRHuntResult`: Get hunt results in form of a PowerShell object.
    * `New-GRRHunt`: Create a new hunt. Return only GRR URL to hunt.
    * `Start-GRRHunt`: Start hunt. If approval system is in use, you have to
        request that before.
    * `Stop-GRRHunt`: Stop a hunt based on the hunt id.
* Add functions for flow handling
	* `Invoke-GRRFlow`: Start a GRR flow which is supported by PowerGRR
        (ListProcesses, FileFinder, RegistryFinder, ExecutePythonHack).
        Dynamic parameters are used for the plugin specific parameters. A
        dedicated PowerShell object with computername, clientid and flow
        id is returned for better post-processing.
    * `Get-GRRFlowResult`: Get flow results. Use the parameter
        __OnlyPayload__ to only show the result without the full return object.
* Add functions for client handling
	* `Get-GRRComputerNameFromClientId`: Get the computername based on the client id.
        You can just show the latest seen computername if multiple GRR client
        ids are available for one computer
	* `Get-GRRClientIdFromComputerName`
* Add functions for search and client handling
	* `Find-GRRClient`
	* `Find-GRRClientByLabel`
* Add functions for label
    * `Get-GRRLabel`
	* `Set-GRRLabel`
	* `Remove-GRRLabel`
* Add function for requesting approvals
    * `New-GRRClientApproval`
    * `New-GRRHuntApproval`
* Add new wrapper functions for handling GRR API requests: `Invoke-GRRRequest`
    and `Get-GRRSession`. You can use `Invoke-GRRRequest` also directly from
    the shell if some API calls are not supported by default with PowerGRR.
* Add support for common PowerShell parameters (e.g. whatif) for functions
  with actions (add or remove label, start a flow, ...)
* Add some supporting functions, e.g. `ConvertFrom-Base64` which is used 
    for result data or a function for the time conversion for showing the unix
    timestamps in human readable form or `New-DynamicParam` for easier usage
    of the dynamic parameters.
