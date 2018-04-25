---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRClientApproval.md
schema: 2.0.0
---

# Get-GRRClientApproval

## SYNOPSIS
Get client approval identified by the given filters. 

## SYNTAX

### ByUser (Default)
```
Get-GRRClientApproval [[-Credential] <PSCredential>] [[-ComputerName] <String>] [[-Offset] <Int32>]
 [[-Count] <Int32>] [[-State] <String>] [-ShowJSON] [<CommonParameters>]
```

### ByApproval
```
Get-GRRClientApproval [[-Credential] <PSCredential>] [-ComputerName] <String> [-ApprovalId] <String>
 [-OnlyState] [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
Get client approval identified by approval id and client id or list client
approvals based on the available filters. Use the ComputerName filter and let
PowerGRR translate this into the needed client id.

Get only the state of a client approval and use this in a loop to wait until the
approval is valid and you can continue with the desired actions.

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRClientApproval -Credential $cred -Count 1

notified_users     : {user}
is_valid_message   : Requires 2 approvers for access.
reason             : INC01
email_cc_addresses : {cc-email@your-domain.tld}
is_valid           : False
approvers          : {user}
id                 : approval:AAAAAAAA
subject            : @{...}
```

Return the latest approval. Use " | select -expandproperty is_valid" after the command
for only returning the state.

### Example 2
```
PS C:\> Get-GRRClientApproval -Credential $cred  -OnlyState -ComputerName host1 -ApprovalId approval:AAAAAAAA
False
```

Get the client approval for the host 'host1' and the approval id 'approval:AAAAAAAA'.
Use this command in a loop to wait until the approval is valid and you can continue with
the desired actions.

### Example 3
```
PS C:\> Get-GRRClientApproval -Credential $cred -State INVALID -Count 2

notified_users     : {user}
is_valid_message   : Requires 2 approvers for access.
reason             : INC01
email_cc_addresses : {cc-email@your-domain.tld}
is_valid           : False
approvers          : {user}
id                 : approval:AAAAAAAA
subject            : @{...}

notified_users     : {user2}
is_valid_message   : Requires 2 approvers for access.
reason             : INC02
email_cc_addresses : {cc-email@your-domain.tld}
is_valid           : False
approvers          : {user2}
id                 : approval:BBBBBBBB
subject            : @{...}
```

Get the latest two client approvals with the state "INVALID", that means not yet approved.

## PARAMETERS

### -ApprovalId
Approval id from New-GRRClientApproval.

```yaml
Type: String
Parameter Sets: ByApproval
Aliases: 

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputerName
ComputerName for which an approval was requested.

```yaml
Type: String
Parameter Sets: ByUser
Aliases: 

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ByApproval
Aliases: 

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Count
Amount of approvals to be returned.

```yaml
Type: Int32
Parameter Sets: ByUser
Aliases: 

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
GRR credentials.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Offset for the returned approvals.

```yaml
Type: Int32
Parameter Sets: ByUser
Aliases: 

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnlyState
Return only the state of the approval. Useful for loops.

```yaml
Type: SwitchParameter
Parameter Sets: ByApproval
Aliases: 

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowJSON
Return only plain JSON instead of converted JSON objects.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Filter for the approval state.

```yaml
Type: String
Parameter Sets: ByUser
Aliases: 
Accepted values: ANY, VALID, INVALID

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

