---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Remove-GRRLabel.md
schema: 2.0.0
---

# Remove-GRRLabel

## SYNOPSIS
Remove a label on a range of clients.

## SYNTAX

```
Remove-GRRLabel [[-ComputerName] <String[]>] [[-Label] <String[]>] [[-Credential] <PSCredential>] [-ShowJSON]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a label on a range of clients.

## EXAMPLES

### Example 1
```
PS C:\> Remove-GRRLabel -ComputerName host1, host2 -Label label1 -Credential $creds
PS C:\> "host1", "host2" | Remove-GRRLabel -Label label1 -Credential $creds
```

Remove the label "label1" to both hosts. It's possible to use pipeline to remove the
labels.

### Example 2
```
PS C:\> Remove-GRRLabel -ComputerName (Find-GRRClient -SearchString keyword -Credential $cred -OnlyNode) -Label test5,test3 -Credential $creds
```

Use the GRR search to find specific clients on which both labels should be
removed.

## PARAMETERS

### -ComputerName
Computer name(s) for which the label must be set.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
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
Default value: False
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
Label which must be set.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowJSON
Return plain JSON instead of converted JSON.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
