---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRFlowResult.md
schema: 2.0.0
---

# Get-GRRFlowResult

## SYNOPSIS
Get flow results for a specific client and a flow.

## SYNTAX

```
Get-GRRFlowResult [-ComputerName] <String> [[-Credential] <PSCredential>] [-FlowId] <String> [-OnlyPayload]
 [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
Get flow results for a specific client and a flow.

## EXAMPLES

### Example 1
```
PS C:\> $res = Get-GRRFlowResult -Credential $cred -ComputerName host -FlowId "F:11111111"
PS C:\> $res.items.payload | ConvertFrom-Base64
```

Get the flow results and decode the base64 encoded payload. See next example
for a short version to get only the payload.

### Example 2
```
PS C:\> Get-GRRFlowResult -ComputerName host -Credential $cred -FlowId F:11111111 -OnlyPayload
```

Get the flow results and decode the base64 encoded payload directly.

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
Return only the payload. If possible already base64 decoded.

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
