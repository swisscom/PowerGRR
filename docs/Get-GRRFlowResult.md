---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# Get-GRRFlowResult

## SYNOPSIS
Get flow results for a specific client and a flow.

## SYNTAX

```
Get-GRRFlowResult [-ComputerName] <String> [-Credential] <PSCredential> [-FlowId] <String> [-OnlyPayload]
 [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> $res = Get-GRRFlowResult -Credential $cred -ComputerName u261354 -FlowId "F:11111111"
PS C:\> $res.items.payload | ConvertFrom-Base64
```

Get the flow results and decode the base64 encoded payload.

## PARAMETERS

### -ComputerName
Computername of the client.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Credential
{{Fill Credential Description}}

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

### -FlowId
Flow id for which the results should be returned.

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

### -OnlyPayload
{{Fill OnlyPayload Description}}

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

### -ShowJSON
{{Fill ShowJSON Description}}

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

