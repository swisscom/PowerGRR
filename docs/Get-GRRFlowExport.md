---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRFlowExport.md
schema: 2.0.0
---

# Get-GRRFlowExport

## SYNOPSIS
Export files archive from a flow.

## SYNTAX

```
Get-GRRFlowExport [-ComputerName] <String> [[-Credential] <PSCredential>] [-FlowId] <String>
 [[-FilePath] <String>] [<CommonParameters>]
```

## DESCRIPTION
Export files archive from a flow.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GRRFlowExport -ComputerName LNX1337 -FlowId AAAAAAAAAAAAAAAA -FilePath .\export.zip
```

Export files archive for host LNX1337 and flow AAAAAAAAAAAAAAAA and save the
output to export.zip.

## PARAMETERS

### -ComputerName
Computer name for which the export is triggered.

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
GRR credentials.

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

### -FilePath
Export zip file path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FlowId
Flow id.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
