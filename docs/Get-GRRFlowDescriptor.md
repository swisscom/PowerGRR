---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRFlowDescriptor.md
schema: 2.0.0
---

# Get-GRRFlowDescriptor

## SYNOPSIS
Get a list of all available flows.

## SYNTAX

```
Get-GRRFlowDescriptor [[-Credential] <PSCredential>] [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
List all flows and allow filtering based on category, name and doc content.

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRFlowDescriptor -Credential $cred
```

List all available flows.

### Example 2
```
PS C:\> $ret = Get-GRRFlowDescriptor -Credential $cred
PS C:\> $ret | select name
```

List all available flows and display all the flow names.

### Example 3
```
PS C:\> $ret = Get-GRRFlowDescriptor -Credential $cred
PS C:\> $ret | where { $_.category -match "memory"}
```

List all available flows from the memory category.

### Example 4
```
PS C:\> $ret = Get-GRRFlowDescriptor -Credential $cred
PS C:\> $ret | where { $_.category -match "file"} | select name
```

List all available flows from the file category and display only the flow names.

### Example 5
```
PS C:\> Get-GRRFlowDescriptor -Credential $cred | ? { $_.name -match "proc" }
```

List all available flows where "proc" is in the flow name.

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
Show plain JSON output.

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

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
