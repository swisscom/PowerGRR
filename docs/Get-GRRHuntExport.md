---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRHuntExport.md
schema: 2.0.0
---

# Get-GRRHuntExport

## SYNOPSIS
Export files archive from a hunt.

## SYNTAX

```
Get-GRRHuntExport [[-HuntId] <String>] [[-FilePath] <String>] [[-Credential] <PSCredential>]
 [<CommonParameters>]
```

## DESCRIPTION
Export files archive from a hunt.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-GRRHuntExport -HuntId AAAAAAAAAAAAAAAA -FilePath export.zip
```

Export files archive from hunt AAAAAAAAAAAAAAAA and save the output to
export.zip.

## PARAMETERS

### -Credential
GRR credentials.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
Export zip file path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HuntId
Hunt for which the files archive is exported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
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
