<#
MIT License

Copyright (c) 2017-2021 Swisscom (Schweiz) AG

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

$ConfigFileName = "powergrr-config.ps1"

$ErrorMessageMissingConfiguration = "No configuration file was found. Create a '$ConfigFileName' ('Configuration.ps1' is deprecated) within the profile folder ($(if($env:USERPROFILE){$env:USERPROFILE}else{$env:HOME})) or in the root of the module ($PSScriptRoot). At least set the variable `$GRRUrl to your GRR server's URL. See README on Github for more information."

#endregion

#region FUNCTIONS
Function Get-GRRHuntInfo()
{
    param(
        [parameter(ValueFromPipeline=$True)]
        [string[]]
        $HuntId,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand

        Write-Verbose "$Function Entering $Function"
        Write-Progress -Activity "Running $Function"

        $output = @()
    }

    Process {
        foreach ($Hunt in $HuntId)
        {
            Write-Progress -Activity "Running $Function for hunt $Hunt"
            Write-Verbose "Processing $Hunt"

            $params = @{
                'Url' = "/hunts/$Hunt";
                'Credential' = $Credential
            }

            $output += Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
        }
    }

    End {
        $output
        Write-Verbose "$Function Leaving $Function"
    }
} # Get-GRRHuntInfo

Function Get-GRRHuntExport()
{
    param(
        [parameter(ValueFromPipeline=$True)]
        [string]
        $HuntId,

        [string]
        $FilePath,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential)
    )

    Begin {
        $Function = $MyInvocation.MyCommand

        Write-Verbose "$Function Entering $Function"
        Write-Progress -Activity "Running $Function"

        $output = @()
    }

    Process {
        foreach ($Hunt in $HuntId)
        {
            Write-Progress -Activity "Running $Function for hunt $Hunt"
            Write-Verbose "Processing $Hunt"

            $params = @{
                'Url' = "/hunts/$Hunt/results/files-archive?archive_format=ZIP";
                'Credential' = $Credential;
                'FilePath' = $FilePath;
            }

            $output += Invoke-GRRRequest @params
        }
    }

    End {
        $output
        Write-Verbose "$Function Leaving $Function"
    }
} # Get-GRRHuntExport

Function Get-GRRHuntResult()
{
    param(
        [string]
        $HuntId = $(throw "Provide a hunt id with -HuntId"),

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
        $ret = ""
        $output = @()
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
            if ($ret -and !$PSBoundParameters.containskey('ShowJSON') -and ($ret.PSobject.Properties.name -match "items"))
            {
                if ($ret.items -and $ret.items -ne "")
                {
                    $item = $ret.items

                    $info=[ordered]@{
                        ComputerName=$item.os_info.fqdn
                        ClientId=$item.urn.substring(6)
                        LastSeenAt=$(ConvertFrom-EpocTime ($item.last_seen_at).toString().Insert(10,"."))
                        OSVersion=$item.os_info.kernel
                    }

                    $output += New-Object PSObject -Property $info
                }
                else
                {
                    write-warning "ClientId $ClientId not found in GRR."
                }
            }
            else
            {
                if ($ret -and ($ret.substring(5) | ConvertFrom-Json).items)
                {
                    $info=[ordered]@{
                        ComputerName=$client
                        JSON=$ret
                    }

                    $output += New-Object PSObject -Property $info
                }
                else
                {
                    write-warning "ClientId $ClientId not found in GRR."
                }
            }
        }
    }

    End {
        $output | sort-object ComputerName -unique
        Write-Verbose "$Function Leaving $Function"
    }
} # Get-GRRComputerNameFromClientId

function Get-GRRCredential()
{
    if(get-variable -name GRRCredential -scope global -ErrorAction SilentlyContinue -valueonly)
    {
        $Credential = get-variable -name GRRCredential -scope global -ErrorAction SilentlyContinue -valueonly
    }
    else
    {
        try{
            $Credential = Microsoft.PowerShell.Security\get-credential
        }
        catch {
            throw "Please specify either -Credential param or set the variable `$GRRCredential before running the command."
        }
    }
    # Return GRR credentials
    $Credential
}

function Get-GRRClientInfo()
{
    param(
        [parameter(ValueFromPipeline=$True)]
        [string[]]
        $ComputerName,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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
                if ($res.items)
                {
                    foreach ($item in $res.items)
                    {
                        $info=[ordered]@{
                            ComputerName=$( if($item.os_info) { $item.os_info.fqdn } )
                            ClientId=$item.urn.substring(6)
                            InstallationDate=$(ConvertFrom-EpocTime ($item.os_info.install_date).toString().Insert(10,"."))
                            LastSeenAt=$(ConvertFrom-EpocTime ($item.last_seen_at).toString().Insert(10,"."))
                            OSVersion=$( if($item.os_info) { $item.os_info.kernel } )
                            GRRClientVersion=$item.agent_info.client_version
                            UserNames=$( if($item -and ($item.PSobject.Properties.name -match "users")) { $item.users.username } )
                            Labels=$( if($item.labels) { $item.labels.name } )
                        }

                        $ret += New-Object PSObject -Property $info
                    }
                }
                else
                {
                    write-warning "ComputerName $client not found in GRR."
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

}


Function Get-GRRClientIdFromComputerName()
{
    param(
        [parameter(ValueFromPipeline=$True)]
        [string[]]
        $ComputerName,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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
                if ($res.items)
                {
                    foreach ($item in $res.items)
                    {
                        $info=[ordered]@{
                            ComputerName=$item.os_info.fqdn
                            ClientId=$item.urn.substring(6)
                            LastSeenAt=$(ConvertFrom-EpocTime ($item.last_seen_at).toString().Insert(10,"."))
                            OSVersion=$item.os_info.kernel
                        }

                        $ret += New-Object PSObject -Property $info
                    }
                }
                else
                {
                    write-warning "ComputerName $client not found in GRR."
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

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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
            if ($ret -and ($ret.PSobject.Properties.name -match "items") -and $ret.items)
            {
                $ret.items.os_info.fqdn
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

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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
            $ret.items.os_info.fqdn
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

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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

                if ($pscmdlet.ShouldProcess( $( (Get-GRRComputerNameFromClientId -clientid $ClientId.ClientId -Credential $Credential).ComputerName -join"," ), "Set label $Label"))
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

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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

                if ($pscmdlet.ShouldProcess( $( (Get-GRRComputerNameFromClientId -clientid $ClientId.ClientId -Credential $Credential).ComputerName -join"," ), "Remove label $Label"))
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


function Get-GRRHuntApproval()
{
    [CmdletBinding(DefaultParameterSetName="ByUser")]
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [Parameter(ParameterSetName="ByApproval",Mandatory=$true)]
        [string]
        $HuntId,

        [Parameter(ParameterSetName="ByApproval",Mandatory=$true)]
        [string]
        $ApprovalId,

        [Parameter(ParameterSetName="ByApproval",Mandatory=$false)]
        [switch]
        $OnlyState,

        [Parameter(ParameterSetName="ByUser",Mandatory=$false)]
        [int]
        $Offset,

        [Parameter(ParameterSetName="ByUser",Mandatory=$false)]
        [int]
        $Count,

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    $params = @{
        'Credential' = $Credential;
        'ShowJSON' = $PSBoundParameters.containskey('ShowJSON');
    }

    if (!$HuntId -and !$ApprovalId)
    {
        $Url = "/users/me/approvals/hunt"

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
    }
    else
    {
        $Url = "/users/$($Credential.UserName)/approvals/hunt/$HuntId/$ApprovalId"
    }

    Write-Verbose "URL: $Url"

    $params += @{
        'Url' = $Url;
    }

    $ret = Invoke-GRRRequest @params

    if ($ret -and !$PSBoundParameters.containskey('ShowJSON'))
    {
        if ($OnlyState)
        {
            if ($ret.PSobject.Properties.name -match "is_valid")
            {
                $ret.is_valid
            }
            else
            {
                $ret
            }
        }
        else
        {
            if ($ret.PSobject.Properties.name -match "items")
            {
                $ret.items
            }
            else
            {
                $ret
            }
        }
    }
    else
    {
        $ret
    }

    Write-Verbose "$Function Leaving $Function"
}


function Get-GRRClientApproval()
{
    [CmdletBinding(DefaultParameterSetName="ByUser")]
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [Parameter(ParameterSetName="ByApproval",Mandatory=$true)]
        [Parameter(ParameterSetName="ByUser",Mandatory=$false)]
        [string]
        $ComputerName,

        [Parameter(ParameterSetName="ByApproval",Mandatory=$true)]
        [string]
        $ApprovalId,

        [Parameter(ParameterSetName="ByApproval",Mandatory=$false)]
        [switch]
        $OnlyState,

        [Parameter(ParameterSetName="ByUser",Mandatory=$false)]
        [int]
        $Offset,

        [Parameter(ParameterSetName="ByUser",Mandatory=$false)]
        [int]
        $Count,

        [Parameter(ParameterSetName="ByUser",Mandatory=$false)]
        [ValidateSet("ANY","VALID", "INVALID")]
        [string]
        $State,

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    $params = @{
        'Credential' = $Credential;
        'ShowJSON' = $PSBoundParameters.containskey('ShowJSON');
    }

    if (!$ApprovalId)
    {
        $Url = "/users/me/approvals/client"

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
        if ($PSBoundParameters.containskey('ComputerName'))
        {
            if ($Url -match "\?") { $Url += "&" }
            else { $Url += "?" }
            $ClientId = Get-GRRClientIdFromComputerName -Credential $Credential -ComputerName $ComputerName -OnlyLastSeen
            if ($ClientId)
            {
                $Url += "client_id=$($ClientId.ClientId)"
            }
            else
            {
                write-warning "Skipping filter '$ComputerName' because no client id found in GRR."
            }
        }
        if ($PSBoundParameters.containskey('State'))
        {
            if ($Url -match "\?") { $Url += "&" }
            else { $Url += "?" }
            $Url += "state=$State"
        }
    }
    else
    {
        $ClientId = Get-GRRClientIdFromComputerName -Credential $Credential -ComputerName $ComputerName -OnlyLastSeen
        if ($ClientId)
        {
            $Url = "/users/$($Credential.UserName)/approvals/client/$($ClientId.ClientId)/$ApprovalId"
        }
        else
        {
            throw "No client id found matching filter '$ComputerName'."
        }
    }

    Write-Verbose "URL: $Url"

    $params += @{
        'Url' = $Url;
    }

    $ret = Invoke-GRRRequest @params

    if ($ret -and !$PSBoundParameters.containskey('ShowJSON'))
    {
        if ($OnlyState)
        {
            if ($ret.PSobject.Properties.name -match "is_valid")
            {
                $ret.is_valid
            }
            else
            {
                $ret
            }
        }
        else
        {
            if ($ret.PSobject.Properties.name -match "items")
            {
                $ret.items
            }
            else
            {
                $ret
            }
        }
    }
    else
    {
        $ret
    }

    Write-Verbose "$Function Leaving $Function"
}


function Wait-GRRHuntApproval()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [Parameter(Mandatory=$true)]
        [string]
        $HuntId,

        [Parameter(Mandatory=$true)]
        [string]
        $ApprovalId,

        [int]
        $TimeoutInMinutes = 15,

        [int]
        $Interval = 30,

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand
    Write-Verbose "$Function Entering $Function"

    $TimeoutReached = $false
    $Timeout = $TimeoutInMinutes * 60
    $Count = 0

    while (!(Get-GRRHuntApproval -Credential $Credential -HuntId $HuntId -ApprovalId $ApprovalId -OnlyState))
    {
        if ($Timeout -le $Count)
        {
            Write-Verbose "Timeout reached - break and stop execution."
            $TimeoutReached = $true
            Break
        }
        else
        {
            Write-Verbose "Waiting for $Interval seconds..."
            $Count += $Interval
            Sleep $Interval
        }
    }

    if ($TimeoutReached)
    {
        $false
    }
    else
    {
        $true
    }

    Write-Verbose "$Function Leaving $Function"
}


function Wait-GRRClientApproval()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [Parameter(Mandatory=$true)]
        [string]
        $ApprovalId,

        [int]
        $TimeoutInMinutes = 15,

        [int]
        $Interval = 30,

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand
    Write-Verbose "$Function Entering $Function"

    $TimeoutReached = $false
    $Timeout = $TimeoutInMinutes * 60
    $Interval = 30
    $Count = 0

    while (!(Get-GRRClientApproval -Credential $Credential -ComputerName $ComputerName -ApprovalId $ApprovalId -OnlyState))
    {
        if ($Timeout -le $Count)
        {
            Write-Verbose "Timeout reached - break and stop execution."
            $TimeoutReached = $true
            Break
        }
        else
        {
            Write-Verbose "Waiting for $Interval seconds..."
            $Count += $Interval
            Sleep $Interval
        }
    }

    if ($TimeoutReached)
    {
        $false
    }
    else
    {
        $true
    }

    Write-Verbose "$Function Leaving $Function"
}


function New-GRRHuntApproval()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $HuntId,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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

        if ($ClientId -and ($ClientId.PSobject.Properties.name -match "ClientId"))
        {
            $ClientId = $ClientId.ClientId

            $params =  @{
                'Url' = "/users/me/approvals/client/$ClientId";
                'Body' = $Body;
                'Headers' = $Headers;
                'Websession' = $Websession;
                'Credential' = $Credential
            }

            $ret = ""

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
        }
        else
        {
           write-warning "No GRR client id found for $ComputerName"
        }
    } # process

    End {
        Write-Verbose "$Function Leaving $Function"
    }
}


function Get-FlowArgs()
{
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [Parameter(Mandatory=$true)]
        [string]
        $Flow,

        [Parameter(Mandatory=$true)]
        [System.Collections.ICollection]
        $Parameters
    )

    $PluginArguments = "{}"

    if ($Flow -eq "FileFinder")
    {
        $PluginArguments = '{"paths":["'+$($Parameters['Path']-join'","')+'"]'

        if ($($Parameters['Pathtype']))
        {
            $Pathtype = $( $Parameters['Pathtype'])
            $PluginArguments += ',"pathtype":"'+$($Parameters['Pathtype'])+'"'
        }

        if ($($Parameters['Mode']))
        {
            $RegexMode = $( $Parameters['Mode'])
        }
        else
        {
            $RegexMode = "All_HITS"
        }

        if ($Parameters['ConditionType'] -match "regex")
        {
            if (!$Parameters['SearchString'])
            {
                throw "Please provide a regex search string with -SearchString."
            }
            $PluginArguments += ',"conditions":[{"condition_type":"CONTENTS_REGEX_MATCH",'
            $PluginArguments += '"contents_regex_match":{"regex":"'+$($Parameters['SearchString'])+'","mode":"'+$RegexMode+'"}}]}'
        }
        elseif ($Parameters['ConditionType'] -match "literal")
        {
            if (!$Parameters['SearchString'])
            {
                throw "Please provide a literal search string with -SearchString."
            }
            $PluginArguments += ',"conditions":[{"condition_type":"CONTENTS_LITERAL_MATCH",'
            $PluginArguments += '"contents_literal_match":{"literal":"'+$( $Parameters['SearchString'] | ConvertTo-Base64 )+'"}}]}'
        }
        else
        {
            $PluginArguments += ',"action":{"action_type":"'+$($Parameters['ActionType'])+'"}'
            $PluginArguments += '}'
        }

        $PluginArguments = $PluginArguments -replace "\\", "\\"
    }
    elseif ($Flow -eq "RegistryFinder")
    {
        $PluginArguments = '{"keys_paths":["'+$($Parameters['Key']-join'","')+'"]'

        if ($($Parameters['Mode']))
        {
            $RegexMode = $( $Parameters['Mode'])
        }
        else
        {
            $RegexMode = "All_HITS"
        }

        if ($Parameters['ConditionType'] -match "regex")
        {
            if (!$Parameters['ConditionString'])
            {
                throw "Please provide a regex condition string with -ConditionString."
            }
            $PluginArguments += ',"conditions":[{"condition_type":"VALUE_REGEX_MATCH",'
            $PluginArguments += '"value_regex_match":{"regex":"'+$($Parameters['ConditionString'])+'","mode":"'+$RegexMode+'"}}]}'
        }
        elseif ($Parameters['ConditionType'] -match "literal")
        {
            if (!$Parameters['ConditionString'])
            {
                throw "Please provide a literal search string with -ConditionString."
            }
            $PluginArguments += ',"conditions":[{"condition_type":"VALUE_LITERAL_MATCH",'
            $PluginArguments += '"value_literal_match":{"literal":"'+$( $Parameters['ConditionString'] | ConvertTo-Base64 )+'"}}]}'
        }
        else
        {
            $PluginArguments += '}'
        }

        $PluginArguments = $PluginArguments -replace "\\", "\\"
    }
    elseif ($Flow -eq "ListProcesses")
    {
        if ($Parameters['FileNameRegex'])
        {
            $PluginArguments = '{"filename_regex":"'+$Parameters['FileNameRegex']+'"}'
        }
        else
        {
            $PluginArguments = '{"filename_regex":"."}'
        }
    }
    elseif ($Flow -eq "ExecutePythonHack")
    {
        $HackArguments = $($Parameters['PyArgsValue'])
        $HackArguments = $HackArguments -replace "\\", "\\"
        $HackArguments = $HackArguments -replace '"', '\"'

        $PluginArguments = '{"hack_name":"'+$($Parameters['HackName'])+'","py_args":{"'+$($Parameters['PyArgsName'])+'":"'+$HackArguments+'"}}'
    }
    elseif ($Flow -eq "ArtifactCollectorFlow")
    {
        $ValidatedArtifacts = Get-ValidatedGRRArtifact -Credential $Credential -Artifacts $Parameters['ArtifactList']

        if ($ValidatedArtifacts)
        {
            $PluginArguments = '{'
            if ($Parameters['UseTsk'])
            {
                $PluginArguments += '"use_tsk":true,'
            }
            $PluginArguments += '"artifact_list":["'+ $($ValidatedArtifacts -join "`",`"") + '"]}'
            Write-Verbose "PluginArguments for ArtifactCollectorFlow: $PluginArguments"
        }
        else
        {
            Throw "No artifacts found in GRR which match the given artifacts."
        }
    }
    elseif ($Flow -eq "YaraProcessScan")
    {
        # Read signature file and escape quotes
        $FilePath = $Parameters['YaraSignatureFile']
        if (!(Test-Path $FilePath))
        {
            Throw "Yara file not found: $FilePath"
        }

        $YaraSignature = Get-content $FilePath
        $YaraSignature = $YaraSignature -replace "`\\", "\\"
        $YaraSignature = $YaraSignature -replace "`"", "\`""
        $PluginArguments = '{"yara_signature":"'+$YaraSignature+'"}'
    }

    $PluginArguments
}


function Get-DynamicFlowParam()
{
    param(
        [Parameter(Mandatory=$true)]
        [System.Collections.ICollection]
        $Params
    )

    $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

    if ($Params.containskey('flow') -and $Params.Flow -eq "FileFinder")
    {
        New-DynamicParam -Name Path -mandatory -DPDictionary $Dictionary -Type String[]
        New-DynamicParam -Name Pathtype -ValidateSet "OS(default)",TSK,NTFS,REGISTRY -DPDictionary $Dictionary
        New-DynamicParam -Name ActionType -mandatory -ValidateSet STAT,Hash,Download -DPDictionary $Dictionary
        New-DynamicParam -Name ConditionType -ValidateSet Regex,Literal -DPDictionary $Dictionary
        New-DynamicParam -Name Mode -ValidateSet ALL_HITS,FIRST_HIT -DPDictionary $Dictionary
        New-DynamicParam -Name SearchString -DPDictionary $Dictionary
    }
    elseif ($Params.containskey('flow') -and $Params.Flow -eq "RegistryFinder")
    {
        New-DynamicParam -Name Key -mandatory -DPDictionary $Dictionary -Type String[]
        New-DynamicParam -Name ConditionType -ValidateSet Regex,Literal -DPDictionary $Dictionary
        New-DynamicParam -Name Mode -ValidateSet ALL_HITS,FIRST_HIT -DPDictionary $Dictionary
        New-DynamicParam -Name ConditionString -DPDictionary $Dictionary
    }
    elseif ($Params.containskey('flow') -and $Params.Flow -eq "ListProcesses")
    {
        New-DynamicParam -Name FileNameRegex -DPDictionary $Dictionary
    }
    elseif ($Params.containskey('flow') -and $Params.Flow -eq "ExecutePythonHack")
    {
        New-DynamicParam -Name HackName -mandatory -DPDictionary $Dictionary
        New-DynamicParam -Name PyArgsName -mandatory -DPDictionary $Dictionary
        New-DynamicParam -Name PyArgsValue -mandatory -DPDictionary $Dictionary
    }
    elseif ($Params.containskey('flow') -and $Params.Flow -eq "ArtifactCollectorFlow")
    {
        New-DynamicParam -Name ArtifactList -mandatory -DPDictionary $Dictionary -Type string[]
        New-DynamicParam -Name UseTsk -DPDictionary $Dictionary -Type switch
    }
    elseif ($Params.containskey('flow') -and $Params.Flow -eq "YaraProcessScan")
    {
        New-DynamicParam -Name YaraSignatureFile -mandatory -DPDictionary $Dictionary
    }

    $Dictionary
}


function Start-GRRHunt()
{
    [CmdletBinding(DefaultParameterSetName="Default", SupportsShouldProcess=$True)]
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [string]
        $HuntId,

        [Parameter(ParameterSetName="WaitForApproval",Mandatory=$true)]
        [switch]
        $Wait,

        [Parameter(ParameterSetName="WaitForApproval",Mandatory=$true)]
        [string]
        $ApprovalId,

        [Parameter(ParameterSetName="WaitForApproval",Mandatory=$false)]
        [int]
        $TimeoutInMinutes = 15,

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

        if (!$Wait -or ($Wait -and (Wait-GRRHuntApproval -Credential $Credential -HuntId $HuntId -ApprovalId $ApprovalId -TimeoutInMinutes $TimeoutInMinutes)))
        {
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

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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
        [Parameter(Mandatory=$true)]
        [string]
        $HuntDescription,

        [Parameter(Mandatory=$true)]
        [ValidateSet("Netstat","ListProcesses","FileFinder","RegistryFinder","ExecutePythonHack","ArtifactCollectorFlow","YaraProcessScan")]
        [string]
        $Flow,

        #[ValidateSet("MATCH_ALL","MATCH_ANY")]
        #[string]
        #$MatchMode,

        [Parameter(Mandatory=$true)]
        [string]
        [ValidateSet("Label","OS")]
        $RuleType,

        [int]
        $ClientRate,

        [int]
        $ClientLimit,

        [string]
        $EmailAddress,

        [switch]
        $OnlyId,

        [switch]
        $OnlyUrl,

        # Fix for dynamic parameter autocompletion issue: https://github.com/PowerShell/PowerShell/issues/3984
        #[Parameter(Mandatory=$true)]
        #[System.Management.Automation.PSCredential]
        #[System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [switch]
        $ShowJSON
    )

    DynamicParam
    {
        $Dictionary = Get-DynamicFlowParam -Params $PSBoundParameters

        if ($PSBoundParameters.containskey('RuleType') -and $PSBoundParameters.RuleType -eq "OS")
        {
            New-DynamicParam -Name OS -mandatory -DPDictionary $Dictionary -Type string -ValidateSet @("os_windows","os_darwin","os_linux")
        }
        elseif ($PSBoundParameters.containskey('RuleType') -and $PSBoundParameters.RuleType -eq "Label")
        {
            New-DynamicParam -Name "Label" -mandatory -DPDictionary $Dictionary -Type string[]
        }

        $Dictionary
    }

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"

        Set-NewVariable -Parameters $PSBoundParameters

        # Fix for dynamic parameter autocompletion issue: https://github.com/PowerShell/PowerShell/issues/3984
        #if (!$Credential -or ($Credential.GetType()).name -ne "PSCredential")
        #{
        #    Write-Debug "Credentials not supplied or of wrong type."
        #    try
        #    {
        #        $Credential = Microsoft.PowerShell.Security\get-credential
        #    }
        #    catch
        #    {
        #        throw "Use the parameter '-Credential' and 'Microsoft.PowerShell.Security\get-credential' to supply your credentials."
        #        break
        #    }
        #}
    }

    Process {
        Write-Progress -Activity "Running $Function"

        $Headers,$Websession = Get-GRRSession -Credential $Credential

        $OutputPlugin = ""
        if ($EmailAddress)
        {
            $OutputPlugin = '{"plugin_name":"EmailOutputPlugin","plugin_args":{"email_address":"'
            $OutputPlugin += $EmailAddress+'","emails_limit":1}}'
        }

        $FlowArgs = Get-FlowArgs -Credential $Credential -Flow $Flow -Parameters $PSBoundParameters

        if ($RuleType -eq "Label")
        {
            $AllLabels = Get-GRRLabel -Credential $Credential
            $Labels = $PSBoundParameters['Label']
            $ValidatedLabels = @()

            if(!$AllLabels)
            {
                Throw "No labels found."
            }

            foreach ($Label in $Labels)
            {
                if ($AllLabels.contains($Label))
                {
                    $ValidatedLabels += $Label
                }
                else
                {
                    write-warning "Skipping label `"$Label`" because it does not exist. Set the label with Set-GRRLabel first."
                }
            }
            if($ValidatedLabels)
            {
                $ValidatedLabels = $ValidatedLabels | Get-Unique
            }
            else
            {
                Throw "No valid labels found."
            }

            $Rule = '"client_rule_set":{"rules":['
            $Rule += '{"rule_type":"'+$RuleType.toUpper()+'",'
            $Rule += '"'+$RuleType.toLower()+'":{"match_mode":"'+"MATCH_ANY"+'",'
            $Rule += '"label_names":["'+$($ValidatedLabels-join'","')+'"]}}]}'
        }
        elseif ($RuleType -eq "OS")
        {
            # "client_rule_set":{"rules":[{"os":{"os_darwin":true}}]}
            $Rule = '"client_rule_set":{"rules":[{"os":{"'+$($PSBoundParameters['OS'])+'":true}}]}'
        }

        if(!$ClientLimit -and $ClientLimit -ne 0)
        {
            $ClientLimit = 100
        }

        if(!$ClientRate)
        {
            $ClientRate = 20
        }

        $Body = '{"flow_name":"'+$Flow+'","hunt_runner_args":{"output_plugins":['+$OutputPlugin+'],'
        $Body += $Rule+',"description":"'+$HuntDescription+'","client_limit":'+$ClientLimit+',"client_rate":'+$ClientRate+'},"flow_args":'+$FlowArgs+'}'

        Write-Verbose "Create hunt with the following arguments: $Body"

        if ($pscmdlet.ShouldProcess("$RuleType", "Create new hunt with following arguments: $Body"))
        {
            $params = @{
                'Url' = "/hunts";
                'Credential' = $Credential;
                'Body' = $Body;
                'Headers' = $Headers;
                'Websession' = $Websession
            }

            $HuntReturnValue = Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
            if ($HuntReturnValue -and $OnlyId -and !$PSBoundParameters.containskey('ShowJSON'))
            {
                $(($HuntReturnValue.urn).substring(12))
            }
            elseif ($HuntReturnValue -and $OnlyUrl -and !$PSBoundParameters.containskey('ShowJSON'))
            {
                "$GRRUrl/#/hunts/$(($HuntReturnValue.urn).substring(12))"
            }
            else
            {
                $HuntReturnValue
            }
        } # whatif
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

        # Fix for dynamic parameter autocompletion issue: https://github.com/PowerShell/PowerShell/issues/3984
        #[Parameter(Mandatory=$true)]
        #[System.Management.Automation.PSCredential]
        #[System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [Parameter(Mandatory=$true)]
        [ValidateSet("Netstat","ListProcesses","FileFinder","RegistryFinder","ExecutePythonHack","ArtifactCollectorFlow","YaraProcessScan")]
        [string]
        $Flow,

        [string]
        $EmailAddress,

        [switch]
        $ShowJSON
    )

    DynamicParam
    {
        Get-DynamicFlowParam -Params $PSBoundParameters
    }

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Progress -Activity "Running $Function"
        Write-Verbose "$Function Entering $Function"

        Set-NewVariable -Parameters $PSBoundParameters

        $Headers,$Websession = Get-GRRSession -Credential $Credential

        $ret = @()

        # Fix for dynamic parameter autocompletion issue: https://github.com/PowerShell/PowerShell/issues/3984
        #if (!$Credential -or ($Credential.GetType()).name -ne "PSCredential")
        #{
        #    Write-Debug "Credentials not supplied or of wrong type."
        #    try
        #    {
        #        $Credential = Microsoft.PowerShell.Security\get-credential
        #    }
        #    catch
        #    {
        #        throw "Use the parameter '-Credential' and 'Microsoft.PowerShell.Security\get-credential' to supply your credentials."
        #        break
        #    }
        #}
    }

    Process {

        $OutputPlugin = ""
        if ($EmailAddress)
        {
            $OutputPlugin = '{"plugin_name":"EmailOutputPlugin",'
            $OutputPlugin += '"plugin_args":{"email_address":"'+$EmailAddress+'","emails_limit":1}}'
        }

        $PluginArguments = Get-FlowArgs -Credential $Credential -Flow $Flow -Parameters $PSBoundParameters

        $Body = '{"flow":{"runner_args":{"flow_name":"'+$Flow+'",'
        $Body += '"output_plugins":['+$OutputPlugin+']},"args":'+$PluginArguments+'}}'

        foreach ($client in $ComputerName)
        {
            Write-Verbose "Check client '$client'"

            $params = @{
                'ComputerName' = $client;
                'Credential' = $Credential
                'OnlyLastSeen' = $true
            }

            $ClientId = Get-GRRClientIdFromComputerName @params

            if ($ClientId -and ($ClientId.PSobject.Properties.name -match "ClientId"))
            {
                $ClientId = $ClientId.ClientId

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
                            FlowId=($temp.urn).Substring(25)
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
            else
            {
                Write-warning "No GRR client id found for $client"
            }
        } # foreach computername
    } # process

    End {
        $ret
        Write-Verbose "$Function Leaving $Function"
    }

} # Invoke-GRRFlow


function Get-GRRFlow()
{
    param(
            [parameter(ValueFromPipeline=$True, Mandatory=$true)]
            [string]
            $ComputerName,

            [System.Management.Automation.PSCredential]
            [System.Management.Automation.Credential()]
            $Credential = (Get-GRRCredential),

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
                    'Url' = "/clients/$ClientId/flows";
                    'Credential' = $Credential
                }

            $ret = Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
        }
        else
        {
            Write-warning "No ClientId found for $ComputerName"
        }
    } # process

    End {
        $flows = @()

        if ($ret)
        {
            if ($PSBoundParameters.containskey('ShowJSON'))
            {
                $ret | ConvertTo-Json
            }
            elseif ($ret -and ($ret.PSobject.Properties.name -match "items"))
            {
                foreach ($r in $ret.items) {
                    $info=[ordered]@{
                        FlowID=$r.flow_id
                        Creator=$r.creator
                        Flow=$r.name
                        State=$r.state
                        StartetAt=$(ConvertFrom-EpocTime ($r.started_at).toString().Insert(10,"."))
                        LastActiveAt=$(ConvertFrom-EpocTime ($r.last_active_at).toString().Insert(10,"."))
                        ComputerName=$ComputerName
                        ClientId=$r.client_id
                    }

                    $flows += New-Object PSObject -Property $info
                }
                $flows
            }
        }

        Write-Verbose "$Function Leaving $Function"
    } #end

} # Get-GRRFlow


function Get-GRRFlowInfo()
{
    param(
        [parameter(ValueFromPipeline=$True, Mandatory=$true)]
        [string]
        $ComputerName,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [string]
        [Parameter(Mandatory=$true)]
        $FlowId,

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
                'Url' = "/clients/$ClientId/flows/$FlowId";
                'Credential' = $Credential
            }

            $ret = Invoke-GRRRequest @params -ShowJSON:$PSBoundParameters.containskey('ShowJSON')
        }
        else
        {
            Write-warning "No ClientId found for $ComputerName"
        }
    } # process

    End {
        if ($ret)
        {
            if ($PSBoundParameters.containskey('ShowJSON'))
            {
                $ret | ConvertTo-Json
            }
            else
            {
                $info=[ordered]@{
                    FlowID=$ret.flow_id
                    Creator=$ret.creator
                    Name=$ret.name
                    Args=$ret.args
                    State=$ret.state
                    StartetAt=$(ConvertFrom-EpocTime ($ret.started_at).toString().Insert(10,"."))
                    LastActiveAt=$(ConvertFrom-EpocTime ($ret.last_active_at).toString().Insert(10,"."))
                    ComputerName=$ComputerName
                    ClientId=$ret.client_id
                    Context=$ret.context
                }

                New-Object PSObject -Property $info
            }
        }

        Write-Verbose "$Function Leaving $Function"
    }

} # Get-GRRFlowInfo


function Get-GRRFlowResult()
{
    param(
        [parameter(ValueFromPipeline=$True, Mandatory=$true)]
        [string]
        $ComputerName,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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
            Write-warning "No ClientId found for $ComputerName"
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

function Get-GRRFlowExport()
{
    param(
        [parameter(ValueFromPipeline=$True, Mandatory=$true)]
        [string]
        $ComputerName,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [string]
        [Parameter(Mandatory=$true)]
        $FlowId,

        [string]
        $FilePath
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
            'Credential' = $Credential;
            'OnlyLastSeen' = $true
        }

        $ClientId = Get-GRRClientIdFromComputerName @params
        if ($ClientId)
        {
            $ClientId = $ClientId.ClientId

            $params =  @{
                'Url' = "/clients/$ClientId/flows/$FlowId/results/files-archive?archive_format=ZIP";
                'Credential' = $Credential
                'FilePath' = $FilePath
            }
            $ret = Invoke-GRRRequest @params
        }
        else
        {
            Write-warning "No ClientId found for $ComputerName"
        }
    } # process

    End {
        Write-Verbose "$Function Leaving $Function"
    }

} # Get-GRRFlowExport

Function Get-GRRLabel()
{
    [OutputType([string[]])]
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    $ret = @()

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
    [CmdletBinding(DefaultParameterSetName="Count")]
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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
                Created=$(ConvertFrom-EpocTime ($r.created).toString().Insert(10,"."))
                HuntId=$r.hunt_id
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


function Get-GRRFlowDescriptor()
{
    [CmdletBinding()]
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    $params = @{
        'Url' = "/flows/descriptors";
        'Credential' = $Credential;
        'ShowJSON' = $PSBoundParameters.containskey('ShowJSON');
    }

    Write-Verbose "URL: $($params.url)"

    $ret = Invoke-GRRRequest @params

    if ($ret -and !$PSBoundParameters.containskey('ShowJSON') -and $ret.items)
    {
        $ret.items
    }
    else
    {
        $ret
    }

    Write-Verbose "$Function Leaving $Function"
}


function Remove-GRRArtifact()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [Parameter(Mandatory=$true)]
        [string[]]
        $Artifact,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

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

        if ($pscmdlet.ShouldProcess($Artifact, "Remove artifact"))
        {
            if ($Headers -and $Websession)
            {
                $ValidatedArtifacts = Get-ValidatedGRRArtifact -Credential $Credential -Artifacts $Artifact

                if ($ValidatedArtifacts)
                {
                    $Body = '{"names":["'+ $($ValidatedArtifacts -join "`",`"") + '"]}'

                    $params =  @{
                        'Url' = "/artifacts";
                        'Credential' = $Credential;
                        'Body' = $Body;
                        'Method' = "Delete";
                        'Headers' = $Headers;
                        'Websession' = $Websession
                        'ShowJSON' = $PSBoundParameters.containskey('ShowJSON')
                    }

                    Invoke-GRRRequest @params
                }
                else
                {
                    Write-Error "No artifact found in GRR with the supplied names."
                }
            } # headers and websession set
        } #whatif
    } # Process block

    End {
        Write-Verbose "$Function Leaving $Function"
    }
}


function Get-ValidatedGRRArtifact()
{
    param(
        [Parameter(Mandatory=$true)]
        [string[]]
        $Artifacts,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    $Function = $MyInvocation.MyCommand
    Write-Verbose "$Function Entering $Function"

    $AllArtifacts = Get-GRRArtifact -Credential $Credential

    if ($AllArtifacts) {
        $AllArtifacts = $AllArtifacts | select -ExpandProperty name | Get-Unique
    }
    else
    {
        Throw "No artifacts found in GRR"
    }

    $ValidatedArtifacts = @()

    $Artifacts = $Artifacts | Get-Unique

    foreach ($Artifact in $Artifacts)
    {
        if ($AllArtifacts.contains($Artifact))
        {
            $ValidatedArtifacts += $Artifact
        }
        else
        {
            write-warning "Skipping artifact `'$Artifact`' because it is not defined in GRR."
        }
    }

    $ValidatedArtifacts

    Write-Verbose "$Function Leaving $Function"
}

function Add-GRRArtifact()
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [string]
        $ArtifactFile,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [switch]
        $ShowJSON
    )

    Begin {
        $Function = $MyInvocation.MyCommand
        Write-Verbose "$Function Entering $Function"
    }

    Process {
        Write-Progress -Activity "Running $Function"

        if (!(Test-Path $ArtifactFile))
        {
            throw "Artifact file not found."
        }
        else
        {
            $Headers,$Websession = Get-GRRSession -Credential $Credential

            if ($pscmdlet.ShouldProcess($ArtifactFile, "Add artifact"))
            {
                if ($Headers -and $Websession)
                {
                    $ret = gc $ArtifactFile | sls name; $ret = $ret -match "name: (.*)"
                    $ArtifactName = $matches[1]
                    $ArtifactExist = Get-GRRArtifact | ? { $_.name -match $ArtifactName  }

                    if ($ArtifactExist)
                    {
                        write-warning "Artifact $ArtifactName already exists. Remove it first using Remove-GRRArtifact before uploading a new version."
                    } else
                    {
                        $params =  @{
                            'Url' = "/artifacts";
                            'Credential' = $Credential;
                            'File' = $ArtifactFile;
                            'Headers' = $Headers;
                            'Websession' = $Websession;
                            'ShowJSON' = $PSBoundParameters.containskey('ShowJSON')
                        }
                        Invoke-GRRRequest @params
                    } # validate artifact and add
                } # headers and websession set
            } #whatif
        } # Artifact file found
    } # Process block

    End {
        Write-Verbose "$Function Leaving $Function"
    }
}


function Get-GRRArtifact()
{
    [CmdletBinding()]
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    $params = @{
        'Url' = "/artifacts";
        'Credential' = $Credential;
        'ShowJSON' = $PSBoundParameters.containskey('ShowJSON');
    }

    $ret = Invoke-GRRRequest @params

    $Artifacts = @()

    if ($ret -and !$PSBoundParameters.containskey('ShowJSON') -and ($ret.PSobject.Properties.name -match "items"))
    {
        # Build custom objects to only show relevant information
        foreach ($item in $ret.items)
        {
            $info=[ordered]@{
                Name=$item.artifact.name
                Description=$item.artifact.doc
                IsCustom=$item.is_custom
                URLs=$(if (($item.artifact).psobject.properties.name -match "urls"){$item.artifact.urls})
                Labels=$item.artifact.labels
                SupportedOS=$item.artifact.supported_os
                Type=$item.artifact.sources.type
                Attributes=$item.artifact.sources.attributes
            }

            $Artifacts += New-Object PSObject -Property $info
        }

        $Artifacts
    }
    else
    {
        $ret
    }

    Write-Verbose "$Function Leaving $Function"
}


Function Get-ClientCertificate()
{
    if (Get-Variable -Name GRRClientCertIssuer -ErrorAction SilentlyContinue -valueonly)
    {
        if ($PSVersionTable.Contains("platform") -and ($PSVersionTable.Platform -match "Unix"))
        {
            $ErrorMessageUnix = "It's not possible to use a cert issuer for reading "
            $ErrorMessageUnix += "the certificate on a non-Windows platform. See CONFIGURATION section on Github."
            Throw $ErrorMessageUnix
        }

        $Cert = Get-ChildItem Cert:\CurrentUser\My | Where-Object `
                {$_.Issuer -match $GRRClientCertIssuer }

        if ($Cert -and (($Cert | measure).count -eq 1))
        {
            $Cert.Thumbprint
        }
        else
        {
            Throw "No certificate found matching the given issuer ('$GRRClientCertIssuer'). Please check the config setting."
        }
    }
    elseif (Get-Variable -Name GRRClientCertFilePath -ErrorAction SilentlyContinue -valueonly)
    {
        if (Test-Path $GRRClientCertFilePath)
        {
            write-host "Reading client certificate..."
            Get-PfxCertificate($GRRClientCertFilePath)
        }
        else
        {
            Throw "Certificate file not found ('$GRRClientCertFilePath'). Please check the config setting."
        }

    }
    else
    {
        Write-verbose "No GRRClientCertIssuer or GRRClientCertFilePath variable is set in the config."
    }
} # Get-ClientCertificate


Function ConvertFrom-EpocTime()
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [long[]]$UnixTime
    )

    Process
    {
        $UnixTime | ForEach-Object {
            $time = $_
            if ($time.tostring().Length -gt 10 -and -not $time.tostring().Contains(".") )
            {
                [long]$time = $time.toString().Insert(10,".")
            }
            $epoch = New-Object System.DateTime (1970, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)
            $epoch.AddSeconds($time)
        }
    }
} # ConvertFrom-EpocTime


function Get-GRRSession ()
{
    param(
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential)
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function"

    $params = @{}

    if (Get-Variable -Name GRRUrl -ErrorAction SilentlyContinue -valueonly)
    {
        $GRRUrl = $GRRUrl.trim('/')

        # Todo Change back to the -Credential parameter after issue in PowerShell
        # core has been fixed: https://github.com/PowerShell/PowerShell/issues/4274.
        # ===> PR merged: https://github.com/PowerShell/PowerShell/pull/5052
        $userpassB64 = "$($Credential.GetNetworkCredential().UserName):"
        $userpassB64 += "$($Credential.GetNetworkCredential().Password)"
        $userpassB64 = $userpassB64 | ConvertTo-Base64
        $HeadersAuth = @{Authorization = "Basic $userpassB64"}
        $params += @{
            'Headers' = $HeadersAuth;
        }

        $params +=  @{
            'Uri' = $GRRUrl;
            #'Credential' = $Credential;
            'Method' = "get";
            'SessionVariable' = "Websession";
            'ContentType' = "application/x-www-form-urlencoded"
        }

        if (($PSVersionTable.PSVersion.Major -ge 6) -and (Get-Variable -Name GRRIgnoreCertificateErrors -ErrorAction SilentlyContinue -valueonly))
        {
            $params += @{
                'SkipCertificateCheck' = $true;
            }
        }

        if ($ClientCertificate)
        {
            if ($PSVersionTable.Contains("platform") -and ($PSVersionTable.Platform -match "Unix"))
            {
                Write-Verbose "Using client cert from file"
                $params += @{
                    'Certificate' = $ClientCertificate
                }
            }
            else
            {
                if (Get-Variable -Name GRRClientCertIssuer -ErrorAction SilentlyContinue -valueonly)
                {
                    Write-Verbose "Using client cert from cert store."
                    $params +=  @{
                        'CertificateThumbprint' = $ClientCertificate;
                    }
                }
                else
                {
                    Write-Verbose "Using client cert from file."
                    $params +=  @{
                        'Certificate' = $ClientCertificate;
                    }
                }
            }
        }

        $Web = Invoke-WebRequest @params -ea stop

        if ($Web)
        {
            $csrftoken = (($Web.Headers.'Set-Cookie') -split ";" -split "=")[1]
            $Headers += @{"x-csrftoken" = $($csrftoken)}

            return $Headers,$Websession
        }
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
        [Parameter(ParameterSetName="FILE", Mandatory=$true)]
        [string]
        $Url,

        [Parameter(ParameterSetName="POST", Mandatory=$true)]
        [string]
        $Body,

        [Parameter(ParameterSetName="FILE", Mandatory=$true)]
        [System.IO.FileInfo]
        $File,

        [Parameter(ParameterSetName="GET", Mandatory=$false)]
        [string]
        $FilePath,

        [Parameter(ParameterSetName="FILE", Mandatory=$true)]
        [Parameter(ParameterSetName="POST", Mandatory=$true)]
        [System.Collections.Hashtable]
        $Headers,

        [Parameter(ParameterSetName="POST", Mandatory=$true)]
        [Parameter(ParameterSetName="FILE", Mandatory=$true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $Websession,

        [string]
        [ValidateSet("POST","GET", "PATCH", "DELETE")]
        $Method,

        [Parameter(ParameterSetName="GET", Mandatory=$false)]
        [Parameter(ParameterSetName="POST", Mandatory=$false)]
        [Parameter(ParameterSetName="FILE", Mandatory=$false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-GRRCredential),

        [Parameter(ParameterSetName="GET", Mandatory=$false)]
        [Parameter(ParameterSetName="POST", Mandatory=$false)]
        [Parameter(ParameterSetName="FILE", Mandatory=$true)]
        [switch]
        $ShowJSON
    )

    $Function = $MyInvocation.MyCommand

    Write-Verbose "$Function Entering $Function"

    Write-Progress -Activity "Running $Function" `
                   -Status "Running API call from $(((Get-PSCallStack)[1]).Command)"

    $ret = ""
    $params = @{}

    if ($Url[0] -eq "/")
    {
        $Url = $Url.Substring(1)
    }

    if ($Url -match "\?") { $Url += "&" }
    else { $Url += "?" }
    $Url += "strip_type_info=1"

    if (Get-Variable -Name GRRUrl -ErrorAction SilentlyContinue -valueonly)
    {
        $GRRUrl = $GRRUrl.trim('/')

        # XXX PowerShell Core issue - change back to the -Credential parameter after 
        # issue in PowerShell Core has been fixed: https://github.com/PowerShell/PowerShell/issues/4274.
        $userpassB64 = "$($Credential.GetNetworkCredential().UserName):"
        $userpassB64 += "$($Credential.GetNetworkCredential().Password)"
        $userpassB64 = $userpassB64 | ConvertTo-Base64
        $HeadersAuth = @{Authorization = "Basic $userpassB64"}
        $Headers += $HeadersAuth

        $params += @{
            'Uri' = "$($GRRUrl)/api/$Url";
            #'Credential' = $Credential;
            'TimeoutSec' = 600
        }

        if (($PSVersionTable.PSVersion.Major -ge 6) -and (Get-Variable -Name GRRIgnoreCertificateErrors -ErrorAction SilentlyContinue -valueonly))
        {
            $params += @{
                'SkipCertificateCheck' = $true;
            }
        }

        if ($PSVersionTable.Contains("platform") -and ($PSVersionTable.Platform -match "Unix"))
        {
            if ($ClientCertificate)
            {
                $params += @{
                    'Certificate' = $ClientCertificate
                }
            }
        }
        else
        {
            if ($ClientCertificate)
            {
                if (Get-Variable -Name GRRClientCertIssuer -ErrorAction SilentlyContinue -valueonly)
                {
                    $params +=  @{
                        'CertificateThumbprint' = $ClientCertificate;
                    }
                }
                else
                {
                    $params +=  @{
                        'Certificate' = $ClientCertificate;
                    }
                }
            }
        }

        #Add further parameters if its a POST or PATCH request
        if ($File)
        {
            $Boundary = ([guid]::NewGuid()).guid
            $FileContent = get-content $File -enc byte -raw
            $Enc = [System.Text.Encoding]::GetEncoding('utf-8')

            $FileBodyTemplate = $Enc.GetString($FileContent) | ConvertTo-Json -Compress -Depth 1
            $Body = '{"artifact":'+$FileBodyTemplate+'}'
            $HeaderCT = @{"Content-Type" = "application/x-www-form-urlencoded"}
            $Headers += $HeaderCT

            $params += @{
                'Method' = "POST";
                'Websession' = $Websession;
                'Body' = $Body;
            }

        }
        elseif ($Body)
        {
            if ($Method -match "PATCH")
            {
                $params += @{
                    'Method' = "PATCH"
                    'ContentType' = "application/json"
                }
            }
            elseif ($Method -match "DELETE")
            {
                $params += @{
                    'Method' = "DELETE"
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
            }
        }


        $params += @{
            'Headers' = $Headers;
        }

        try
        {
            if ($FilePath) {
                $ret = Invoke-RestMethod @params -outfile $FilePath
            } else{
                $ret = Invoke-RestMethod @params
            }
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            Write-Error $ErrorMessage
        }

        if ($ret -and !($FilePath) )
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


function ConvertTo-Base64()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [AllowNull()]
        [AllowEmptyString()]
        [string[]]
        $Value,

        [Text.Encoding]
        $Encoding = ([Text.Encoding]::ASCII)
    )

    process
    {
        $Value | ForEach-Object {
            if( $_ -eq $null )
            {
                return $null
            }

            $bytes = $Encoding.GetBytes($_)
            [Convert]::ToBase64String($bytes)
        }
    }
}


Function ConvertFrom-Base64()
{
    param(
        [Parameter(ValueFromPipeline=$True)]
        [string]
        $String,

        [string]
        [ValidateSet("UTF8","Unicode")]
        $Encoding = "UTF8"
    )

    Process {
        if ($String)
        {
            [System.Text.Encoding]::$($Encoding).GetString([System.Convert]::FromBase64String($String))
        }
    }
} # ConvertFrom-Base64

function ConvertTo-Hex()
{
    param(
        [Parameter(ValueFromPipeline=$True, Mandatory=$true)]
        [string]
        $String
    )
    [System.BitConverter]::ToString([System.Text.Encoding]::Unicode.GetBytes($String)) -replace "-",""
}

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
        if (!( Get-Variable -name $param -scope 1 -ErrorAction SilentlyContinue -valueonly) )
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
    if($Mandatory)
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

Function Get-GRRConfig()
{
    $Config = New-Object PSObject

    $Value = ""

    $params = @{
        'InputObject' = $Config;
        'MemberType' = 'NoteProperty';
        'Name' = "ConfigFile";
        'Value' = $ConfigFile
    }
    add-member @params

    if (get-variable -name GRRUrl -ErrorAction SilentlyContinue -scope 1 -valueonly)
    {
        $Value = $GRRUrl
    }
    else
    {
        $Value = "none"
    }

    $params = @{
        'InputObject' = $Config;
        'MemberType' = 'NoteProperty';
        'Name' = "GRRUrl";
        'Value' = $Value
    }
    add-member @params

    if (get-variable -name GRRIgnoreCertificateErrors -ErrorAction SilentlyContinue -scope 1 -valueonly)
    {
        $Value = $GRRIgnoreCertificateErrors
    }
    else
    {
        $Value = "false (default)"
    }

    $params = @{
        'InputObject' = $Config;
        'MemberType' = 'NoteProperty';
        'Name' = "GRRIgnoreCertificateErrors";
        'Value' = $Value
    }
    add-member @params

    if (get-variable -name GRRClientCertIssuer -ErrorAction SilentlyContinue -scope 1 -valueonly)
    {
        $Value = $GRRClientCertIssuer
    }
    else
    {
        $Value = "none (default)"
    }

    $params = @{
        'InputObject' = $Config;
        'MemberType' = 'NoteProperty';
        'Name' = "GRRClientCertIssuer";
        'Value' = $Value
    }
    add-member @params

    if (get-variable -name GRRClientCertFilePath -ErrorAction SilentlyContinue -scope 1 -valueonly)
    {
        $Value = $GRRClientCertFilePath
    }
    else
    {
        $Value = "none (default)"
    }

    $params = @{
        'InputObject' = $Config;
        'MemberType' = 'NoteProperty';
        'Name' = "GRRClientCertFilePath";
        'Value' = $Value
    }
    add-member @params

    $Config
}

#endregion

#region INITIALIZATION

# Module path for all functions
$ModuleRoot = $PSScriptRoot

Remove-Variable GRRClientCertIssuer -ErrorAction SilentlyContinue
Remove-Variable GRRClientCertFilePath -ErrorAction SilentlyContinue
Remove-Variable GRRIgnoreCertificateErrors -ErrorAction SilentlyContinue
Remove-Variable GRRUrl -ErrorAction SilentlyContinue

# Read config from file and set variables as needed
$ConfigFile = ""
if (Test-Path "$ModuleRoot\$ConfigFileName")
{
    $ConfigFile = "$ModuleRoot\$ConfigFileName"
    . $ConfigFile
}
elseif ($PSVersionTable.Contains("platform") -and ($PSVersionTable.Platform -match "Unix") -and (Test-Path "$env:HOME\$ConfigFileName"))
{
    $ConfigFile = "$env:HOME\$ConfigFileName"
    . $ConfigFile
}
elseif (Test-Path "$env:USERPROFILE\$ConfigFileName")
{
    $ConfigFile = "$env:USERPROFILE\$ConfigFileName"
    . $ConfigFile
}
else
{
    throw $ErrorMessageMissingConfiguration
}

if (!(get-variable -name GRRUrl -scope 0 -ErrorAction SilentlyContinue -valueonly))
{
    throw "Set `$GRRUrl within the config file: $ConfigFile."
}

# read certificate based on config
$ClientCertificate = Get-ClientCertificate

write-host ""
write-host "Using $($GRRUrl) for the GRR URL."

# Add type for ignoring certificate warnings for Windows
# This is not available in macOS or Linux
# Use switch param "-SkipCertificateCheck" in Invoke-WebRequest and Invoke-RestMethod
# See https://github.com/PowerShell/PowerShell/issues/1945
if ($PSVersionTable.PSVersion.Major -lt 6)
{
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

    if (Get-Variable -Name GRRIgnoreCertificateErrors -ErrorAction SilentlyContinue -valueonly)
    {
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    }

    # Adjust the protocols, otherwise the API will reject connections
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
    [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
}

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
    'New-GRRClientApproval',
    'Get-GRRFlowDescriptor',
    'Get-GRRArtifact',
    'Get-GRRConfig',
    'ConvertTo-Base64',
    'Add-GRRArtifact',
    'Remove-GRRArtifact',
    'Get-GRRHuntApproval',
    'Get-GRRClientApproval',
    'ConvertTo-Hex',
    'Wait-GRRHuntApproval',
    'Wait-GRRClientApproval',
    'Get-GRRClientInfo',
    'ConvertFrom-EpocTime',
    'Get-GRRFlowInfo',
    'Get-GRRFlow',
    'Get-GRRFlowExport',
    'Get-GRRHuntExport'
)

#endregion
