---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Wait-GRRClientApproval.md
schema: 2.0.0
---

# Wait-GRRClientApproval

## SYNOPSIS
Wait for the given client approval gets valid.

## SYNTAX

```
Wait-GRRClientApproval [-ComputerName] <String> [[-Credential] <PSCredential>] [-ApprovalId] <String>
 [[-TimeoutInMinutes] <Int32>] [[-Interval] <Int32>] [-ShowJSON] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Wait for the given client approval gets valid.

## EXAMPLES

### Example 1
```
PS C:\> Wait-GRRClientApproval -ComputerName host -Credential $cred -ApprovalId 1111111111111111 -TimeoutInMinutes 1
```

Wait for that specific approval to get valid. Wait 1 minute otherwise exit the
wait.

## PARAMETERS

### -ApprovalId
Approval id to wait for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputerName
Client for which the approval was made.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
GRR credential.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interval
Interval for the check.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### -TimeoutInMinutes
Timeout to wait for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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
