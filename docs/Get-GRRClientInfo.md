---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRClientInfo.md
schema: 2.0.0
---

# Get-GRRClientInfo

## SYNOPSIS
Get important client infos.

## SYNTAX

```
Get-GRRClientInfo [[-ComputerName] <String[]>] [-Credential] <PSCredential> [-OnlyLastSeen] [-ShowJSON]
 [<CommonParameters>]
```

## DESCRIPTION
Get important client infos.

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRClientInfo -ComputerName host1
```

Get host information for that specific host. No `-Credential` param is needed
because `$GRRCredential` was set before running the command.

### Example 2
```
PS C:\> "host1","host" | Get-GRRClientInfo -Credential $cred
```

Get host information for that specific host based on the pipeline input.

## PARAMETERS

### -ComputerName
Computer name to search for.

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

### -OnlyLastSeen
Flag, if only the last seen client ids should be returned for the host.

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

### -ShowJSON
Return plain JSON instead of converted JSON.

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

### System.String[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

