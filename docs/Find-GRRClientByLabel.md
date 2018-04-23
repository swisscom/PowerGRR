---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Find-GRRClientByLabel.md
schema: 2.0.0
---

# Find-GRRClientByLabel

## SYNOPSIS
Search for clients with a given label.

## SYNTAX

```
Find-GRRClientByLabel [[-SearchString] <String>] [-Credential] <PSCredential> [-OnlyComputerName] [-ShowJSON]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> Find-GRRClientByLabel -Credential $creds -SearchString label
```

Search for clients with a specific label.

### Example 2
```
PS C:\> Find-GRRClientByLabel -Credential $creds -SearchString label -OnlyComputerName
```

Search for clients with a specific label and show only the host names.

## PARAMETERS

### -Credential
GRR credentials.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnlyComputerName
Show only the computername.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Benannt
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchString
Label to search for.

```yaml
Type: String
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

