---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRFlowInfo.md
schema: 2.0.0
---

# Get-GRRFlowInfo

## SYNOPSIS
Read flow state and information.

## SYNTAX

```
Get-GRRFlowInfo [-ComputerName] <String> [[-Credential] <PSCredential>] [-FlowId] <String> [-ShowJSON]
 [<CommonParameters>]
```

## DESCRIPTION
Read flow state and information.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GRRFlowInfo -ComputerName $target -FlowId F:AAAAAAAA
```

Read flow information for flow F:AAAAAAAA.

## PARAMETERS

### -ComputerName
Computer name for which client the flow information should be read.

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
GRR credential object or when using GRRCredential
parameter is not needed.

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
Flow id to get information for.

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

### -ShowJSON
If given, the return value is json.

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

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
