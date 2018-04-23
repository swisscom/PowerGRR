---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# Get-GRRHuntResult

## SYNOPSIS
Get hunt results for a specific hunt.

## SYNTAX

```
Get-GRRHuntResult [[-HuntId] <String>] [-Credential] <PSCredential> [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
Get hunt results for a specific hunt.

## EXAMPLES

### Example 1
```
PS C:\> $res = Get-GRRHuntResult -HuntId H:AAAAAAAA -Credential $creds
PS C:\> ($res.items.payload.stat_entry.aff4path).substring(31) | sort -u
PS C:\> $res.items.client_id | sort -u
```

Get hunt results based on a hunt id. Display all the unique file paths which
were found with a file finder hunt. Only display the unique GRR client id's.
then you can use `Get-GRRComputerNameByClientId` to display only the computer
names.

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

### -HuntId
Hunt id for which the results should be returned.

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
Return only plain JSON instead of converted JSON objects.

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

