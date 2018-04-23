---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRHuntApproval.md
schema: 2.0.0
---

# Get-GRRHuntApproval

## SYNOPSIS
Get hunt approval identified by the given filters. 

## SYNTAX

### ByUser (Default)
```
Get-GRRHuntApproval [-Credential] <PSCredential> [[-Offset] <Int32>] [[-Count] <Int32>] [-ShowJSON]
 [<CommonParameters>]
```

### ByApproval
```
Get-GRRHuntApproval [-Credential] <PSCredential> [-HuntId] <String> [-ApprovalId] <String> [-OnlyState]
 [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
Get hunt approval identified by approval id and hunt id or
list hunt approvals based on the available filters.

Get only the state of a hunt approval and use this in a loop to wait until the
approval is valid and you can continue with the desired actions.

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRHuntApproval -Credential $cred -Count 1

notified_users     : {user}
is_valid_message   : Requires 2 approvers for access.
reason             : Hunting for malicious binaries
email_cc_addresses : {email@domain.tld}
is_valid           : False
approvers          : {}
id                 : approval:AAAAAAAA
subject            : @{...}
```

Return latest hunt approval request.

### Example 2
```
PS C:\> Get-GRRHuntApproval -Credential $cred

notified_users     : {user}
is_valid_message   : Requires 2 approvers for access.
reason             : Hunting for malicious binaries
email_cc_addresses : {email@domain.tld}
is_valid           : False
approvers          : {}
id                 : approval:AAAAAAAA
subject            : @{...}

...
```

Return all hunt approval requests. Use PowerShell to filter them as needed.

### Example 3
```
PS C:\> Get-GRRHuntApproval -Credential $cred -HuntId H:11111111 -ApprovalId approval:AAAAAAAA

notified_users     : {user}
is_valid_message   : Requires 2 approvers for access.
reason             : Hunting for malicious binaries
email_cc_addresses : {email@domain.tld}
is_valid           : False
approvers          : {}
id                 : approval:AAAAAAAA
subject            : @{...}
```

Return a specific hunt approval request and use PowerShell to get a specifc values.

### Example 4
```
PS C:\> PS> Get-GRRHuntApproval -Credential $cred -HuntId H:11111111 -ApprovalId approval:AAAAAAAA -OnlyState
False
```

Return only the state of a specific hunt approval request. Use that for a loop
and if approval becomes valid start the hunt directly.

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

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HuntId
Hunt id for which an approval was requested.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

