---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/powergrr/docs/Add-GRRArtifact.md
schema: 2.0.0
---

# Add-GRRArtifact

## SYNOPSIS
Upload artifact to GRR.

## SYNTAX

```
Add-GRRArtifact [[-ArtifactFile] <String>] [-Credential] <PSCredential> [-ShowJSON] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Upload artifact to GRR.

## EXAMPLES

### Example 1
```
PS C:\> Add-GRRArtifact -Credential $cred -ArtifactFile .\DNSNameServer.yaml
```

Upload artifact "DNSNameServer" to GRR. See https://github.com/ForensicArtifacts/artifacts for more
information about artifact definition.

## PARAMETERS

### -ArtifactFile
Path to artifact file.

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
GRR credentials to use.

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
Return plain JSON instead of parsed JSON object.

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

