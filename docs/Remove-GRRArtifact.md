---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/powergrr/docs/Remove-GRRArtifact.md
schema: 2.0.0
---

# Remove-GRRArtifact

## SYNOPSIS
Delete artifacts in GRR.

## SYNTAX

```
Remove-GRRArtifact [-Artifact] <String[]> [-Credential] <PSCredential> [-ShowJSON] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Delete artifacts in GRR.

## EXAMPLES

### Example 1
```
PS C:\> Remove-GRRArtifact -Credential $cred -Artifact WindowsDNSNameServer

status
------
OK
```

Delete WindowsDNSNameServer artifact in GRR.

### Example 2
```
PS> Remove-GRRArtifact -Credential $cred -Artifact WindowsDNSNameServer,WindowsDNSNameServer2v
WARNUNG: Skipping artifact 'WindowsDNSNameServer2v' because it is not defined in GRR.

status
------
OK
```

Delete WindowsDNSNameServer and WindowsDNSNameServer2v artifacts in GRR. A
warning is returned because one of the given artifacts was not found in GRR.

## PARAMETERS

### -Artifact
Name of artifact to delete.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
GRR credential.

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

### -ShowJSON
{{Fill ShowJSON Description}}

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

