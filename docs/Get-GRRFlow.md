---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRFlow.md
schema: 2.0.0
---

# Get-GRRFlow

## SYNOPSIS
List flows for a given client.

## SYNTAX

```
Get-GRRFlow [-ComputerName] <String> [[-Credential] <PSCredential>] [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
List all flows for a given client. The returned object allows filtering for
specific flows.

## EXAMPLES

### Example 1
```powershell
PS> Get-GRRFlow -ComputerName Worker1


FlowID       : AAAAAAAAAAAAAAAA
Creator      : GRRHunter
Flow         : ListProcesses
State        : RUNNING
StartetAt    : 20.05.2021 07:51:08
LastActiveAt : 20.05.2021 08:44:58
ComputerName : Worker1
ClientId     : C.1111111111111111
...
```

The command lists all flows for the client Worker1.

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
