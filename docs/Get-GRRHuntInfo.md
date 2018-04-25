---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRHuntInfo.md
schema: 2.0.0
---

# Get-GRRHuntInfo

## SYNOPSIS
Get hunt info for a specific hunt.

## SYNTAX

```
Get-GRRHuntInfo [[-HuntId] <String>] [[-Credential] <PSCredential>] [-ShowResultCount] [-ShowJSON]
 [<CommonParameters>]
```

## DESCRIPTION
Get hunt info for a specific hunt.

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRHuntInfo "H:AAAAAAAA" -Credential $cred
```

Read the hunt infos based on a hunt id.

## PARAMETERS

### -Credential
GRR credentials.

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

### -HuntId
Hunt id for which the info should be returned.

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

### -ShowResultCount
{{Fill ShowResultCount Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
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

