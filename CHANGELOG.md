# CHANGELOG
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased](https://github.com/swisscom/powergrr/compare/v0.2.1...master)
### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

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
