---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/powergrr/docs/Wait-GRRHuntApproval.md
schema: 2.0.0
---

# Wait-GRRHuntApproval

## SYNOPSIS
Wait for the hunt approval to get valid.

## SYNTAX

```
Wait-GRRHuntApproval [-Credential] <PSCredential> [-HuntId] <String> [-ApprovalId] <String>
 [[-TimeoutInMinutes] <Int32>] [[-Interval] <Int32>] [-ShowJSON] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Wait for the hunt approval to get valid.

## EXAMPLES

### Example 1
```
PS C:\> Wait-GRRHuntApproval -Credential $cred -HuntId "H:AAAAAAAA" -ApprovalId "approval:AAAAAAAA" -Timeout 10 
```

Wait 10 minutes for the hunt approval to get valid.

### Example 2
```
PS C:\> Wait-GRRHuntApproval -Credential $cred -HuntId "H:AAAAAAAA" -ApprovalId "approval:AAAAAAAA" -Timeout 10 -StartHuntAfterApproval
```

Wait 10 minutes for the hunt approval to get valid. Start the hunt after the
approval got valid.

## PARAMETERS

### -ApprovalId
Approval to wait for.

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

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HuntId
Hunt id for which the approval was created.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Interval
{{Fill Interval Description}}

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
Timeout to wait.

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

