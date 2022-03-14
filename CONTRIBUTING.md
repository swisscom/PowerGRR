# Contributing to PowerGRR

Great, you decided to contribute! That's awesome!

Please file an [issue](https://github.com/swisscom/PowerGRR/issues) if you
need a new feature or found an inconvenient "situation" (bug) or get the code
form Github, make a new branch, extend the functionality as its needed and
make a [pull request](https://github.com/swisscom/PowerGRR/pulls). See section
[What is PowerGRR?](README.md#what-is-powergrr) for an overview about repo
structure.

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
1. Add new markdown help file to the overview in /docs/PowerGRR.md.
1. Update the external help file. See [BUILD](BUILD.md) for
   information about generating the help file. 
1. Update README if needed (e.g. available flows).
1. Update tag file if needed. See [BUILD](BUILD.md) for
   information about generating the tag file.

## Making a new Release

1. Update markdown help and external help file.
1. Run the Pester tests. See [BUILD](BUILD.md). All tests must pass.
1. Update CHANGELOG 
    * Update information according to the current release.
    * Add new **Unreleased** section and update the link for comparison.
    * Add the new version number in the old unreleased section.
    * Add the version comparison link to the current release changelog section.
    * Add the current date at the end of the new header row
1. Update **ModuleVersion** in the module description file (.psd1).
1. Commit the changes
1. Set a tag for the new version (e.g. "vx.x.x").
1. Push the tag and the code changes to the repo.
1. Add a new Github release and add release notes

## PowerGRR Internals

All PowerGRR rely on one or both supporting functions for the request
handling. The first one is `Invoke-GRRRequest` used for all API calls and the
second one is `Get-GRRSession` to establish a session to the GRR server.

**Tip:** Both functions are exported by the module and can be used in the
shell. If PowerGRR doesn't support a function, use these supporting function
directly to make any API call.

When implementing the API calls one must check whether it is a GET or a
POST/PATCH call. The second one relies on an established connection for the
request (cookie, CSRF token).

Some requirements for the implementation:
* Each function must take a _$Credential_ parameter for the GRR login
* Each function must support a _$ShowJSON_ parameter which returns plain JSON
    instead of converted PowerShell objects
* Each function which make changes must support the _WhatIf_ parameter and
    must check that parameter with `if ($pscmdlet.ShouldProcess($Target,
    "$WhatsIfMessage"))` before the critical code.
* Each function which should provide pipeline support must implement a _Begin_,
    _Process_ and _End_ block.

In the following both request types are described each with an example. Only
relevant code for the current purpose is used.

### API Requests using GET

``` powershell
Function Get-GRRHuntResult()
{
    ...
    #
    # Define the parameters using parameter splatting instead
    # of using long lines. The Url contains the API endpoint WITHOUT
    # the "/api".
    #
    $params = @{
        'Url' "/hunts/$HuntId/results";
        'Credential' = $Credential;
        'ShowJSON' = $PSBoundParameters.containskey('ShowJSON');
    }

    #
    # The only thing which then needed for the API call 
    # is the following line which returns either the converted 
    # JSON object or the plain JSON
    #
    Invoke-GRRRequest @params
    ...
}
```

### API Requests using POST or PATCH

``` powershell
Function Set-GRRLabel()
{
    #
    # Functions which make changes must support the WhatsIf parameter. For That
    # purpose the "SupportsShouldProcess" must be set to true before the 
    # parameter definition.
    #
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        ...
    )

    #
    # To establish a session and get back the cookie and the headers (CSRF
    # token) the function Get-GRRSession makes that easy. The function returns a
    # tuple for both needed values.
    #
    $Headers,$Websession = Get-GRRSession -Credential $Credential

    #
    # Build the API call JSON body for the request.
    #
    $Body = 'JSON BODY FOR THE API CALL'

    #
    # Besides setting "SupportsShouldProcess" to true above the parameters,
    # the method ShouldProcess() should be checked before the critical code.
    #
    if ($pscmdlet.ShouldProcess($Target, $WhatsIfMessage)
    {
        if ($Headers -and $Websession)
        {
            #
            # Define the parameters for the call and now use the headers and
            # the websession in addition to the standard parameters (see GET
            # example above)
            #
            $params =  @{
                'Url' = "/clients/labels/add";
                'Credential' = $Credential;
                'ShowJSON' = $PSBoundParameters.containskey('ShowJSON')
                'Body' = $Body;
                'Headers' = $Headers;
                'Websession' = $Websession
            }

            #
            # As with the GET request, the only thing which is now needed for
            # the API call is the GRR request which returns either the 
            # converted PowerShell object or the plain JSON. For a PATCH
            # request add the parameter 'Method' with the value "PATCH" to the
            # parameters above.
            #
            Invoke-GRRRequest @params
        }
    }
}
```
