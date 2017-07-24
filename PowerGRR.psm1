<#
MIT License

Copyright (c) 2017 Swisscom (Schweiz) AG

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>

#region PowerGRR

Set-StrictMode -version latest

#region CONSTANTS

$ErrorMessageMissingConfiguration = "Please set the variable `$GRRUrl before you" +
" use the commands or see Configuration.ps1. If needed set `$GRRClientCertIssuer."

#endregion

#region FUNCTIONS
Function Get-GRRHuntInfo()
{
    param(
        [string]
        $HuntId = $(throw "Provide a hunt id with -HuntId"),

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [string]
        $cert,

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand
    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    $Info = Invoke-GRRRequest -Url "/hunts/$HuntId" -Credential $Credential -ShowJSON:$PSBoundParameters.containskey('ShowJSON')

    if ($Info)
    {
        $Results =  Get-GRRHuntResult $HuntId -Credential $Credential

        if ($PSBoundParameters.containskey('ShowJSON'))
        {
            $Info = $Info.substring(5) | ConvertFrom-Json
        }

        if ($Results -and $Results.PSobject.Properties.name -match "total_count")
        {
            add-member -InputObject $Info -MemberType NoteProperty -Name "total_results" -value $Results.total_count
        }

        if ($PSBoundParameters.containskey('ShowJSON'))
        {
            $Info = $Info | ConvertTo-Json
        }

        $Info
    }

    Write-Verbose "$Function Leaving $Function"
} # Get-GRRHuntInfo


Function Get-GRRHuntResult()
{
    param(
        [string]
        $HuntId = $(throw "Provide a hunt id with -HuntId"),

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    Invoke-GRRRequest -Url "/hunts/$HuntId/results" -Credential $Credential -ShowJSON:$PSBoundParameters.containskey('ShowJSON')

    Write-Verbose "$Function Leaving $Function"
} # Get-GRRHuntResult


Function Get-GRRComputerNameFromClientId()
{
    param(
        [parameter(ValueFromPipeline=$True)]
        [string[]]
        $ClientId,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
        $ret = ""
    }

    Process {
        Write-Progress -Activity "Running $Function"
        foreach ($client in $ClientId)
        {
            if ($client -match "^aff4.*")
            {
                $client = $client.Substring(6)
            }

            $params = @{
                'Url' = "/clients?query=$client";
                'Credential' = $Credential
            }

            $ret = Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
            if ($ret -and !$PSBoundParameters.containskey('ShowJSON') -and $ret.items)
            {
                $ret.items.os_info.node
            }
            else
            {
                $ret
            }
        }
    }

    End {
        Write-Verbose "$Function Leaving $Function"
    }
} # Get-GRRComputerNameFromClientId


Function Get-GRRClientIdFromComputerName()
{
    param(
        [parameter(ValueFromPipeline=$True)]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $OnlyLastSeen = $false,

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand

        Write-Verbose "$Function Entering $Function"

        $ret = @()
    }

    Process {
        Write-Progress -Activity "Running $Function"

        foreach ($client in $ComputerName)
        {
            $res = Invoke-GRRRequest -Url "/clients?query=$client" -Credential $Credential -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
            if ($res -and !$PSBoundParameters.containskey('ShowJSON') -and ($res.PSobject.Properties.name -match "items"))
            {
                foreach ($item in $res.items)
                {
                    $info=[ordered]@{
                        ComputerName=$item.os_info.node
                        ClientId=$item.urn.substring(6)
                        LastSeenAt=$(Get-EpocTimeFromUtc ($item.last_seen_at).toString().Insert(10,"."))
                        OSVersion=$item.os_info.kernel
                    }

                    $ret += New-Object PSObject -Property $info
                }
            }
            elseif ($res)
            {
                $info=[ordered]@{
                    ComputerName=$client
                    JSON=$res
                }

                $ret += New-Object PSObject -Property $info
            }
        }
    }

    End {
        if ($OnlyLastSeen -and !$PSBoundParameters.containskey('ShowJSON'))
        {
            $RetReduced = @()

            foreach ($r in $ret)
            {
                $RetReduced +=  ($ret | Where-Object {$_.computername -eq $r.computername} | sort-object lastseenat -descending | select-object -first 1)
            }

            $RetReduced | sort-object computername -unique
        }
        else
        {
            $ret
        }

        Write-Verbose "$Function Leaving $Function"
    }
} # Get-GRRClientIdFromComputerName


Function Find-GRRClient()
{
    param(
        [string]
        $SearchString = $(throw "Provide a search string with -SearchString"),

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $OnlyComputerName = $false,

        [switch]
        $ShowJSON
    )

    process {
        $Function = $MyInvocation.MyCommand

        Write-Verbose "$Function Entering $Function"

        Write-Progress -Activity "Running $Function"

        $ret = Invoke-GRRRequest -Url "/clients?query=$($SearchString)" -Credential $Credential -ShowJSON:$PSBoundParameters.containskey('ShowJSON')

        if ($OnlyComputerName -and !$PSBoundParameters.containskey('ShowJSON'))
        {
            if ($ret -and $ret.items)
            {
                $ret.items.os_info.node
            }
        }
        else
        {
            $ret
        }
    }

    end {
        Write-Verbose "$Function Leaving $Function"
    }

} # Find-GRRClient


Function Find-GRRClientByLabel()
{
    param(
        [string]
        $SearchString = $(throw "Provide a search string with -SearchString"),

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $OnlyComputerName = $false,

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    $ret = Invoke-GRRRequest -Url "/clients?query=label:$SearchString" -Credential $Credential -ShowJSON:$PSBoundParameters.containskey('ShowJSON')

    if ($OnlyComputerName -and !$PSBoundParameters.containskey('ShowJSON'))
    {
        if ($ret -and $ret.items)
        {
            $ret.items.os_info.node
        }
    }
    else
    {
        $ret
    }

    Write-Verbose "$Function Leaving $Function"
} # Find-GRRClientByLabel


Function Set-GRRLabel()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [parameter(ValueFromPipeline=$True)]
        [string[]]
        $ComputerName,

        [string[]]
        $Label = $(throw "Provide labels with -Label"),

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
    }

    Process {
        Write-Progress -Activity "Running $Function"

        if (!$ComputerName)
        {
            throw "Provide hostnames with -ComputerName"
        }
        else
        {
            $Headers,$Websession = Get-GRRSession -Credential $Credential

            $paramsComputerName = @{
                'ComputerName' = $ComputerName;
                'Credential' = $Credential;
                'OnlyLastSeen' = $true
            }

            $ClientId = Get-GRRClientIdFromComputerName @paramsComputerName

            if ($ClientId)
            {
                $Body = '{"client_ids":["'+$(($ClientId.ClientId)-join'","')+'"],"labels":["'+$($Label-join'","')+'"]}'

                Write-Verbose "Body: $Body"

                if ($pscmdlet.ShouldProcess( $( (Get-GRRComputerNameFromClientId -clientid $ClientId.ClientId -Credential $Credential)-join"," ), "Set label $Label"))
                {
                    if ($Headers -and $Websession)
                    {
                        $params =  @{
                            'Url' = "/clients/labels/add";
                            'Credential' = $Credential;
                            'Body' = $Body;
                            'Headers' = $Headers;
                            'Websession' = $Websession
                            'ShowJSON' = $PSBoundParameters.containskey('ShowJSON')
                        }

                        Invoke-GRRRequest @params
                    }
                } #whatif
            }
        }
    }

    End {
        Write-Verbose "$Function Leaving $Function"
    }
} # Set-GRRLabel


function Remove-GRRLabel()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [parameter(ValueFromPipeline=$True)]
        [string[]]
        $ComputerName,

        [string[]]
        $Label = $(throw "Provide labels with -Label"),

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
    }

    Process {
        Write-Progress -Activity "Running $Function"

        if (!$ComputerName)
        {
            throw "Provide hostnames with -ComputerName"
        }
        else
        {
            $Headers,$Websession = Get-GRRSession -Credential $Credential

            $paramsComputerName = @{
                'ComputerName' = $ComputerName;
                'Credential' = $Credential;
                'OnlyLastSeen' = $true
            }

            $ClientId = Get-GRRClientIdFromComputerName @paramsComputerName

            if ($ClientId)
            {
                $Body = '{"client_ids":["'+$(($ClientId.ClientId)-join'","')+'"],"labels":["'+$($Label-join'","')+'"]}'

                if ($pscmdlet.ShouldProcess( $( (Get-GRRComputerNameFromClientId -clientid $ClientId.ClientId -Credential $Credential)-join"," ), "Remove label $Label"))
                {
                    if ($Headers -and $Websession)
                    {
                        $params = @{
                               'Url' = "/clients/labels/remove";
                               'Credential' = $Credential;
                               'Body' = $Body;
                               'Headers' = $Headers;
                               'websession' = $Websession
                        }

                        Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
                    }
                } # whatif
            }
        }
    }

    End {
        Write-Verbose "$Function Leaving $Function"
    }

} # Remove-GRRLabel


function Invoke-GRRHunt()
{
    #todo Use New-GRRHunt and then Start-GRRHunt
}

function New-GRRHuntApproval()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $HuntId,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(Mandatory=$true)]
        [string[]]
        $NotifiedUsers,

        [Parameter(Mandatory=$true)]
        [string]
        $Reason,

        [switch]
        $OnlyId,

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
        $ret = ""
    }

    Process {
        Write-Progress -Activity "Running $Function"

        $Headers,$Websession = Get-GRRSession -Credential $Credential

        $Body = '{"approval":{"notified_users":["'+$($NotifiedUsers -join "`",")+'"],"reason":"'+$Reason+'"}}'
        Write-Verbose "Body: $Body"

        $params =  @{
            'Url' = "/users/me/approvals/hunt/$HuntId";
            'Body' = $Body;
            'Headers' = $Headers;
            'Websession' = $Websession;
            'Credential' = $Credential
        }

        if ($pscmdlet.ShouldProcess($HuntId, "Requesting a new hunt approval"))
        {
            $ret = Invoke-GRRRequest @params
        }

        if ($ret -and $OnlyId)
        {
            $ret.id
        }
        else
        {
            $ret
        }
    } # process

    End {
        Write-Verbose "$Function Leaving $Function"
    }
}


function New-GRRClientApproval()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(Mandatory=$true)]
        [string[]]
        $NotifiedUsers,

        [Parameter(Mandatory=$true)]
        [string]
        $Reason,

        [switch]
        $OnlyId,

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
    }

    Process {
        Write-Progress -Activity "Running $Function"

        $Headers,$Websession = Get-GRRSession -Credential $Credential

        $Body = '{"approval":{"notified_users":["'+$($NotifiedUsers -join "`",")+'"],"reason":"'+$Reason+'"}}'
        Write-Verbose "Body: $Body"

        $paramsComputerName = @{
            'ComputerName' = $ComputerName;
            'Credential' = $Credential;
            'OnlyLastSeen' = $true
        }
        $ClientId = Get-GRRClientIdFromComputerName @paramsComputerName

        $params =  @{
            'Url' = "/users/me/approvals/client/$($ClientId.ClientId)";
            'Body' = $Body;
            'Headers' = $Headers;
            'Websession' = $Websession;
            'Credential' = $Credential
        }

        if ($pscmdlet.ShouldProcess($ComputerName, "Requesting a new client approval"))
        {
            $ret = Invoke-GRRRequest @params
        }

        if ($ret -and $OnlyId)
        {
            $ret.id
        }
        else
        {
            $ret
        }
    } # process

    End {
        Write-Verbose "$Function Leaving $Function"
    }
}


function Start-GRRHunt()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [string]
        $HuntId,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
        $ret = ""
    }

    Process {
        Write-Progress -Activity "Running $Function"

        $Headers,$Websession = Get-GRRSession -Credential $Credential

        $params =  @{
            'Url' = "/hunts/$HuntId";
            'Body' = '{"state":"STARTED"}';
            'Headers' = $Headers;
            'Websession' = $Websession;
            'Method' = "PATCH";
            'Credential' = $Credential
        }

        # If 403 - it could be due to the missing approval
        if ($pscmdlet.ShouldProcess($HuntId, "Starting hunt"))
        {
            $ret = Invoke-GRRRequest @params
        }

        if ($ret)
        {
            $ret
        }
    } # process

    End {
        Write-Verbose "$Function Leaving $Function"
    }

} #Start-GRRHunt


function Stop-GRRHunt()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [string]
        $HuntId,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
        $ret = ""
    }

    Process {
        Write-Progress -Activity "Running $Function"

        $Headers,$Websession = Get-GRRSession -Credential $Credential

        $params =  @{
            'Url' = "/hunts/$HuntId";
            'Body' = '{"state":"STOPPED"}';
            'Headers' = $Headers;
            'Websession' = $Websession;
            'Method' = "PATCH";
            'Credential' = $Credential
        }

        # If 403 - it could be due to the missing approval
        if ($pscmdlet.ShouldProcess($HuntId, "Stopping hunt"))
        {
            $ret = Invoke-GRRRequest @params
        }

        if ($ret)
        {
            $ret
        }
    } # process

    End {
        Write-Verbose "$Function Leaving $Function"
    }

} #Stop-GRRHunt


# todo remove duplicate flow code (see Invoke-GRRFlow)

function New-GRRHunt()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [string]
        $HuntDescription,

        [Parameter(Mandatory=$true)]
        [ValidateSet("Netstat","ListProcesses","FileFinder","RegistryFinder","ExecutePythonHack")]
        [string]
        $Flow,

        [ValidateSet("MATCH_ALL","MATCH_ANY")]
        [string]
        $MatchMode,

        [string]
        [ValidateSet("Label","OS")]
        $RuleType,

        [string]
        $Label,

        [string]
        $EmailAddress,

        [switch]
        $OnlyUrl,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $ShowJSON
    )

    DynamicParam
    {
        $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        if ($PSBoundParameters.containskey('flow') -and $PSBoundParameters.Flow -eq "FileFinder")
        {
            New-DynamicParam -Name Path -mandatory -DPDictionary $Dictionary -Type String[]
            New-DynamicParam -Name ActionType -mandatory -ValidateSet Hash,Download -DPDictionary $Dictionary

        }
        elseif ($PSBoundParameters.containskey('flow') -and $PSBoundParameters.Flow -eq "RegistryFinder")
        {
            New-DynamicParam -Name Key -mandatory -DPDictionary $Dictionary -Type String[]
        }
        elseif ($PSBoundParameters.containskey('flow') -and $PSBoundParameters.Flow -eq "ListProcesses")
        {
            New-DynamicParam -Name FileNameRegex -mandatory -DPDictionary $Dictionary
        }
        elseif ($PSBoundParameters.containskey('flow') -and $PSBoundParameters.Flow -eq "ExecutePythonHack")
        {
            New-DynamicParam -Name HackName -mandatory -DPDictionary $Dictionary
            New-DynamicParam -Name PyArgsName -mandatory -DPDictionary $Dictionary
            New-DynamicParam -Name PyArgsValue -mandatory -DPDictionary $Dictionary
        }

        $Dictionary
    }

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"

        Set-NewVariable -Parameters $PSBoundParameters
    }

    Process {
        Write-Progress -Activity "Running $Function"

        $Headers,$Websession = Get-GRRSession -Credential $Credential

        $OutputPlugin = ""
        if ($EmailAddress)
        {
            $OutputPlugin = '{"plugin_name":"EmailOutputPlugin","plugin_args":{"email_address":"'+$EmailAddress+'","emails_limit":1}}'
        }

        $FlowArgs = "{}"

        if ($Flow -eq "FileFinder")
        {
            $FlowArgs = '{"paths":["'+$($PSBoundParameters['Path']-join'","')+'"],"action":{"action_type":"'+($($PSBoundParameters['ActionType'])).toUpper()+'"}}'
            $FlowArgs = $FlowArgs -replace "\\", "\\"
        }
        elseif ($Flow -eq "RegistryFinder")
        {
            $FlowArgs = '{"keys_paths":["'+$($PSBoundParameters['Key']-join'","')+'"]}'
        }
        elseif ($Flow -eq "ListProcesses")
        {
            $FlowArgs = '{"filename_regex":"'+$PSBoundParameters['FileNameRegex']+'"}'
        }
        elseif ($Flow -eq "ExecutePythonHack")
        {
            $HackArguments = $($PSBoundParameters['PyArgs'])
            $HackArguments = $HackArguments -replace "\\", "\\"
            $HackArguments = $HackArguments -replace '"', '\"'

            $FlowArgs = '{"hack_name":"'+$($PSBoundParameters['HackName'])+'","py_args":{"cmd":"'+$HackArguments+'"}}'
        }

        # todo rules with dedicated variable to allow other rule types (hostnames, OS, ...)
        # this allow affects checks below (if label exists etc)
        # [{"os": {"os_windows": true}}]

        $Body = '{"flow_name":"'+$Flow+'","hunt_runner_args":{"output_plugins":['+$OutputPlugin+'],"client_rule_set":{"rules":[{"rule_type":"'+$RuleType.toUpper()+'","'+$RuleType.toLower()+'":{"match_mode":"'+$MatchMode+'","label_names":["'+$($PSBoundParameters['Label']-join'","')+'"]}}]},"description":"'+$HuntDescription+'"},"flow_args":'+$FlowArgs+'}'

        $Labels = Get-GRRLabel -Credential $Credential

        if ($Labels -and $Labels.contains($Label))
        {
            if ($pscmdlet.ShouldProcess("$Label", "Create new hunt with following arguments: $Body"))
            {
                $params = @{
                    'Url' = "/hunts";
                    'Credential' = $Credential;
                    'Body' = $Body;
                    'Headers' = $Headers;
                    'Websession' = $Websession
                }

                $HuntReturnValue = Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
                if ($HuntReturnValue -and $OnlyUrl -and !$PSBoundParameters.containskey('ShowJSON'))
                {
                    "$GRRUrl/#/hunts/$(($HuntReturnValue.urn).substring(12))"
                }
                else
                {
                    $HuntReturnValue
                }
            } # whatif
        } # Label found
        else
        {
            Write-Error "Label `"$Label`" does not exist. Set the label with Set-GRRLabel first."
        }
    } # process

    End {
        Write-Verbose "$Function Leaving $Function"
    }

} # New-GRRHunt

function Invoke-GRRFlow()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [parameter(ValueFromPipeline=$True, Mandatory=$true)]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(Mandatory=$true)]
        [ValidateSet("Netstat","ListProcesses","FileFinder","RegistryFinder","ExecutePythonHack")]
        [string]
        $Flow,

        [string]
        $EmailAddress,

        [switch]
        $ShowJSON
    )

    DynamicParam
    {
        $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        if ($PSBoundParameters.containskey('flow') -and $PSBoundParameters.Flow -eq "FileFinder")
        {
            New-DynamicParam -Name Path -mandatory -DPDictionary $Dictionary -Type String[]
            New-DynamicParam -Name ActionType -mandatory -ValidateSet Hash,Download -DPDictionary $Dictionary

        }
        elseif ($PSBoundParameters.containskey('flow') -and $PSBoundParameters.Flow -eq "RegistryFinder")
        {
            New-DynamicParam -Name Key -mandatory -DPDictionary $Dictionary -Type String[]
        }
        elseif ($PSBoundParameters.containskey('flow') -and $PSBoundParameters.Flow -eq "ListProcesses")
        {
            New-DynamicParam -Name FileNameRegex -mandatory -DPDictionary $Dictionary
        }
        elseif ($PSBoundParameters.containskey('flow') -and $PSBoundParameters.Flow -eq "ExecutePythonHack")
        {
            New-DynamicParam -Name HackName -mandatory -DPDictionary $Dictionary
            New-DynamicParam -Name PyArgsName -mandatory -DPDictionary $Dictionary
            New-DynamicParam -Name PyArgsValue -mandatory -DPDictionary $Dictionary
        }

        $Dictionary
    }

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"

        Set-NewVariable -Parameters $PSBoundParameters
    }

    Process {
        Write-Progress -Activity "Running $Function"

        $Headers,$Websession = Get-GRRSession -Credential $Credential

        $OutputPlugin = ""
        if ($EmailAddress)
        {
            $OutputPlugin = '{"plugin_name":"EmailOutputPlugin","plugin_args":{"email_address":"'+$EmailAddress+'","emails_limit":1}}'
        }

        $PluginArguments = "{}"

        if ($Flow -eq "FileFinder")
        {
            $PluginArguments = '{"paths":["'+$($PSBoundParameters['Path']-join'","')+'"],"action":{"action_type":"'+$($PSBoundParameters['ActionType'])+'"}}'
            $PluginArguments = $PluginArguments -replace "\\", "\\"
        }
        elseif ($Flow -eq "RegistryFinder")
        {
            $PluginArguments = '{"keys_paths":["'+$($PSBoundParameters['Key']-join'","')+'"]}'
        }
        elseif ($Flow -eq "ListProcesses")
        {
            $PluginArguments = '{"filename_regex":"'+$PSBoundParameters['FileNameRegex']+'"}'
        }
        elseif ($Flow -eq "ExecutePythonHack")
        {
            $HackArguments = $($PSBoundParameters['PyArgs'])
            $HackArguments = $HackArguments -replace "\\", "\\"
            $HackArguments = $HackArguments -replace '"', '\"'

            $PluginArguments = '{"hack_name":"'+$($PSBoundParameters['HackName'])+'","py_args":{"cmd":"'+$HackArguments+'"}}'
        }

        $Body = '{"flow":{"runner_args":{"flow_name":"'+$Flow+'","output_plugins":['+$OutputPlugin+']},"args":'+$PluginArguments+'}}'

        $ret = @()

        foreach ($client in $ComputerName)
        {
            $params = @{
                'ComputerName' = $client;
                'Credential' = $Credential
                'OnlyLastSeen' = $true
            }

            $ClientId = Get-GRRClientIdFromComputerName @params
            if ($ClientId)
            {
                $ClientId = $ClientId.ClientId
            }

            if (!$ClientId)
            {
                Write-Verbose "No GRR client id found for $client"
            }
            else
            {
                if ($pscmdlet.ShouldProcess($client, "Invoking $Flow with following arguments: $Body"))
                {
                    $params = @{
                        'Url' = "/clients/$ClientId/flows";
                        'Credential' = $Credential;
                        'Body' = $Body;
                        'Headers' = $Headers;
                        'Websession' = $Websession
                    }

                    $temp = Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
                    if ($temp -and !$PSBoundParameters.containskey('ShowJSON'))
                    {
                        $info=[ordered]@{
                            ComputerName=$client
                            ClientId=$ClientId
                            FlowId=($temp.urn).Substring(31)
                        }

                        $ret += New-Object PSObject -Property $info
                    }
                    elseif ($PSBoundParameters.containskey('ShowJSON'))
                    {
                        $info=[ordered]@{
                            ComputerName=$client
                            JSON=$temp
                        }

                        $ret += New-Object PSObject -Property $info
                    }
                } # whatif
            } # client id is available
        } # foreach computername
    } # process

    End {
        $ret
        Write-Verbose "$Function Leaving $Function"
    }

} # Invoke-GRRFlow


function Get-GRRFlowResult()
{
    param(
        [parameter(ValueFromPipeline=$True, Mandatory=$true)]
        [string]
        $ComputerName,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [string]
        [Parameter(Mandatory=$true)]
        $FlowId,

        [switch]
        $OnlyPayload,

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
        $ret = ""
    }

    Process {
        Write-Progress -Activity "Running $Function"

        $params = @{
            'ComputerName' = $ComputerName;
            'Credential' = $Credential
            'OnlyLastSeen' = $true
        }

        $ClientId = Get-GRRClientIdFromComputerName @params
        if ($ClientId)
        {
            $ClientId = $ClientId.ClientId

            $params =  @{
                'Url' = "/clients/$ClientId/flows/$FlowId/results";
                'Credential' = $Credential
            }

            $ret = Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
        }
        else
        {
            Write-Verbose "No ClientId found for $ComputerName"
        }
    } # process

    End {
        if ($ret)
        {
            if (!$PSBoundParameters.containskey('ShowJSON') -and $OnlyPayload -and $ret.items)
            {
                try {
                    $ret.items.payload | ConvertFrom-Base64
                }
                catch {
                    $ret.items.payload
                }
            }
            else
            {

                $ret
            }
        }

        Write-Verbose "$Function Leaving $Function"
    }

} # Get-GRRFlowResult


Function Get-GRRLabel()
{
    param(
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    $ret = ""

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    $ret = Invoke-GRRRequest -Url "/clients/labels" -Credential $Credential -ShowJSON:$PSBoundParameters.containskey('ShowJSON')

    if ($PSBoundParameters.containskey('ShowJSON'))
    {
        $ret
    }
    elseif ($ret -and ($ret.PSobject.Properties.name -match "items"))
    {
        try { $ret.items.name } catch {}
    }

    Write-Verbose "$Function Leaving $Function"
} # Get-GRRLabel


Function Get-GRRHunt()
{
    [CmdletBinding(DefaultParameterSetName="count")]
    param(
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(ParameterSetName="Count",Mandatory=$false)]
        [int]
        $Count,

        [Parameter(ParameterSetName="Count",Mandatory=$false)]
        [int]
        $Offset,

        [Parameter(ParameterSetName="CreatedBy",Mandatory=$false)]
        [string]
        $CreatedBy,

        [Parameter(ParameterSetName="DescriptionContains",Mandatory=$false)]
        [string]
        $DescriptionContains,

        [Parameter(ParameterSetName="CreatedBy",Mandatory=$true)]
        [Parameter(ParameterSetName="DescriptionContains",Mandatory=$true)]
        [string]
        $ActiveWithin,

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    $hunts = @()

    $params = @{
        'Credential' = $Credential;
    }

    $Url = "/hunts"
    if ($PSBoundParameters.containskey('Count'))
    {
        if ($Url -match "\?") { $Url += "&" }
        else { $Url += "?" }
        $Url += "count=$Count"
    }
    if ($PSBoundParameters.containskey('Offset'))
    {
        if ($Url -match "\?") { $Url += "&" }
        else { $Url += "?" }
        $Url += "offset=$Offset"
    }
    if ($PSBoundParameters.containskey('CreatedBy'))
    {
        if ($Url -match "\?") { $Url += "&" }
        else { $Url += "?" }
        $Url += "created_by=$CreatedBy"
    }
    if ($PSBoundParameters.containskey('ActiveWithin'))
    {
        if ($Url -match "\?") { $Url += "&" }
        else { $Url += "?" }
        $Url += "active_within=$ActiveWithin"
    }
    if ($PSBoundParameters.containskey('DescriptionContains'))
    {
        if ($Url -match "\?") { $Url += "&" }
        else { $Url += "?" }
        $Url += "description_contains=$DescriptionContains"
    }
    $params += @{
        'Url' = $Url;
    }

    Write-Verbose "URL: $Url"

    $ret = Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')

    if ($ret -and !$PSBoundParameters.containskey('ShowJSON'))
    {
        foreach ($r in $ret.items)
        {
            $info=[ordered]@{
                Created=$(Get-EpocTimeFromUtc ($r.created).toString().Insert(10,"."))
                HuntId=$r.urn
                Description=$r.description
                Creator=$r.Creator
                State=$r.state
                ClientLimit=$r.client_limit
                ClientRate=$r.client_rate
            }

            $hunts += New-Object PSObject -Property $info
        }
    }
    else
    {
        $ret
    }

    $hunts

    Write-Verbose "$Function Leaving $Function"
} # Get-GRRHunt


Function Get-ClientCertificate()
{
    if (Get-Variable -Name GRRClientCertIssuer -ErrorAction SilentlyContinue)
    {
        $Cert = Get-ChildItem Cert:\CurrentUser\My | Where-Object {$_.Issuer -match $GRRClientCertIssuer }

        if ($Cert)
        {
            $Cert.Thumbprint
        }
    }
} # Get-ClientCertificate


function Get-EpocTimeFromUtc ([long]$UnixTime)
{
    $epoch = New-Object System.DateTime (1970, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc);
    $epoch.AddSeconds($UnixTime)
} # FromUtcEpocTime


function Get-GRRSession ()
{
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        [Parameter(Mandatory=$true)]
        $Credential
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    if (Get-Variable -Name GRRUrl -ErrorAction SilentlyContinue)
    {
        $GRRUrl = $GRRUrl.trim('/')

        $params =  @{
            'Uri' = $GRRUrl;
            'Credential' = $Credential;
            'Method' = "get";
            'SessionVariable' = "Websession";
            'ContentType' = "application/x-www-form-urlencoded"
        }

        $ClientCertificate = Get-ClientCertificate
        if ($ClientCertificate)
        {
            $params +=  @{
                'CertificateThumbprint' = $ClientCertificate;
            }
        }

        $Web = Invoke-WebRequest @params

        $csrftoken = (($web.Headers.'Set-Cookie') -split ";" -split "=")[1]
        $Headers = @{"x-csrftoken" = $($csrftoken)}

        return $Headers,$Websession
    } # Variable $GRRUrl set
    else
    {
        Write-Error $ErrorMessageMissingConfiguration
    }

    Write-Verbose "$Function Leaving $Function"
} # Get-GRRSession


function Invoke-GRRRequest ()
{
    param(
        [Parameter(ParameterSetName="GET", Mandatory=$true)]
        [Parameter(ParameterSetName="POST", Mandatory=$true)]
        [string]
        $Url,

        [Parameter(ParameterSetName="POST", Mandatory=$true)]
        [string]
        $Body,

        [Parameter(ParameterSetName="POST", Mandatory=$true)]
        [System.Collections.Hashtable]
        $Headers,

        [Parameter(ParameterSetName="POST", Mandatory=$true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $Websession,

        [string]
        [ValidateSet("POST","GET", "PATCH")]
        $Method,

        [Parameter(ParameterSetName="GET", Mandatory=$true)]
        [Parameter(ParameterSetName="POST", Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(ParameterSetName="GET", Mandatory=$false)]
        [Parameter(ParameterSetName="POST", Mandatory=$false)]
        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand
    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function" -Status "Running API call from $(((Get-PSCallStack)[1]).Command)"

    $ret = ""

    if ($Url[0] -eq "/")
    {
        $Url = $Url.Substring(1)
    }

    if ($Url -match "\?") { $Url += "&" }
    else { $Url += "?" }
    $Url += "strip_type_info=1"

    if (Get-Variable -Name GRRUrl -ErrorAction SilentlyContinue)
    {
        $GRRUrl = $GRRUrl.trim('/')

        $params = @{
            'Uri' = "$($GRRUrl)/api/$Url";
            'Credential' = $Credential;
            'TimeoutSec' = 600
        }

        $ClientCertificate = Get-ClientCertificate
        if ($ClientCertificate)
        {
            $params +=  @{
                'CertificateThumbprint' = $ClientCertificate;
            }
        }

        if ($Body)
        {
            #POST request
            if ($Method -match "PATCH")
            {
                $params += @{
                    'Method' = "PATCH"
                    'ContentType' = "application/json"
                }
            }
            else
            {
                $params += @{
                    'Method' = "post"
                    'ContentType' = "application/x-www-form-urlencoded";
                }
            }

            $params += @{
                'Body' = $Body;
                'Websession' = $Websession;
                'Headers' = $Headers;
            }
        }

        try
        {
            $ret = Invoke-RestMethod @params
        }
        catch
        {
            # todo display error message
            $ErrorMessage = $_.Exception.Message
            Write-Error $ErrorMessage
        }

        if ($ret)
        {
            if ($ShowJSON)
            {
                $ret
            }
            else
            {
                $ret.Substring(5) | ConvertFrom-Json
            }
        }
    } # Variable $GRRUrl set
    else
    {
        Write-Error $ErrorMessageMissingConfiguration
    }

    Write-Verbose "$Function Leaving $Function"
} # Invoke-GRRRequest


function ConvertFrom-Base64 ()
{
    param(
        [Parameter(ValueFromPipeline=$True, Mandatory=$true)]
        [string]
        $String
    )

    Process {
        [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($String))
    }
} # ConvertFrom-Base64


function Set-NewVariable()
{
    param
    (
        $Parameters
    )
    #This standard block of code loops through bound parameters...
    #If no corresponding variable exists, one is created
    #Get common parameters, pick out bound parameters not in that set
    Function _temp { [cmdletbinding()] param() }
    $BoundKeys = $Parameters.keys | Where-Object { (get-command _temp | select-object -ExpandProperty parameters).Keys -notcontains $_}
    foreach($param in $BoundKeys)
    {
        if (-not ( Get-Variable -name $param -scope 1 -ErrorAction SilentlyContinue ) )
        {
            New-Variable -Name $Param -Value $Parameters.$param
            Write-Verbose "Adding variable for dynamic parameter '$param' with value '$($Parameters.$param)'"
        }
    }
}


# Source: https://github.com/RamblingCookieMonster/PowerShell/blob/master/New-DynamicParam.ps1
Function New-DynamicParam ()
{
    param(
        [string]
        $Name,

        [System.Type]
        $Type = [string],

        [string[]]
        $Alias = @(),

        [string[]]
        $ValidateSet,

        [switch]
        $Mandatory,

        [string]
        $ParameterSetName="__AllParameterSets",

        [int]
        $Position,

        [switch]
        $ValueFromPipelineByPropertyName,

        [string]
        $HelpMessage,

        [validatescript({
            if(-not ( $_ -is [System.Management.Automation.RuntimeDefinedParameterDictionary] -or -not $_) )
            {
                Throw "DPDictionary must be a System.Management.Automation.RuntimeDefinedParameterDictionary object, or not exist"
            }
            $True
        })]
        $DPDictionary = $false

    )
    #Create attribute object, add attributes, add to collection   
    $ParamAttr = New-Object System.Management.Automation.ParameterAttribute
    $ParamAttr.ParameterSetName = $ParameterSetName
    if($mandatory)
    {
        $ParamAttr.Mandatory = $True
    }
    if($Position -ne $null)
    {
        $ParamAttr.Position=$Position
    }
    if($ValueFromPipelineByPropertyName)
    {
        $ParamAttr.ValueFromPipelineByPropertyName = $True
    }
    if($HelpMessage)
    {
        $ParamAttr.HelpMessage = $HelpMessage
    }

    $AttributeCollection = New-Object -type System.Collections.ObjectModel.Collection[System.Attribute]
    $AttributeCollection.Add($ParamAttr)

    #param validation set if specified
    if($ValidateSet)
    {
        $ParamOptions = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList $ValidateSet
        $AttributeCollection.Add($ParamOptions)
    }

    #Aliases if specified
    if($Alias.count -gt 0) {
        $ParamAlias = New-Object System.Management.Automation.AliasAttribute -ArgumentList $Alias
        $AttributeCollection.Add($ParamAlias)
    }


    #Create the dynamic parameter
    $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList @($Name, $Type, $AttributeCollection)

    #Add the dynamic parameter to an existing dynamic parameter dictionary, or create the dictionary and add it
    if($DPDictionary)
    {
        $DPDictionary.Add($Name, $Parameter)
    }
    else
    {
        $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $Dictionary.Add($Name, $Parameter)
        $Dictionary
    }
}

#endregion

#region INITIALIZATION

# Module path for all functions
$ModuleRoot = $PSScriptRoot

# Load configuration file (URLs, ...)
if (Test-Path "$ModuleRoot\Configuration.ps1")
{
    Remove-Variable GRRClientCertIssuer -ErrorAction SilentlyContinue
    Remove-Variable GRRIgnoreCertificateErrors -ErrorAction SilentlyContinue
    Remove-Variable GRRUrl -ErrorAction SilentlyContinue

    . "$ModuleRoot\Configuration.ps1"
}
else
{
    Write-Error $ErrorMessageMissingConfiguration
}

# Ignore certificate warnings
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@

if (Get-Variable -Name GRRIgnoreCertificateErrors -ErrorAction SilentlyContinue)
{
	[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}

# Adjust the protocols, otherwise the API will reject connections
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

#endregion

Export-ModuleMember @(
    'Get-GRRHuntResult',
    'Get-GRRHuntInfo',
    'Find-GRRClient',
    'Find-GRRClientByLabel',
    'Get-GRRComputerNameFromClientId',
    'Get-GRRClientIdFromComputerName',
    'Set-GRRLabel',
    'Remove-GRRLabel',
    'Invoke-GRRFlow',
    'Get-GRRLabel',
    'Get-GRRHunt',
    'Get-GRRFlowResult',
    'ConvertFrom-Base64',
    'Invoke-GRRRequest',
    'Get-GRRSession',
    'New-GRRHunt',
    'Start-GRRHunt',
    'Stop-GRRHunt',
    'New-GRRHuntApproval',
    'New-GRRClientApproval'
)

#endregion
