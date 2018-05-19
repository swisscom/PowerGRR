---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRLabel.md
schema: 2.0.0
---

# Get-GRRLabel

## SYNOPSIS
Get all labels.

## SYNTAX

```
Get-GRRLabel [[-Credential] <PSCredential>] [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
Get all labels.

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRLabel -Credential $creds
```

Return every label which is available in GRR.

### Example 2
```
PS C:\> Get-GRRLabel -Credential $creds | sls osx
```

Return every available label which contains "osx".

## PARAMETERS

### -Credential
GRR credentials.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowJSON
Return plain JSON instead of parsed JSON object.

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

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
