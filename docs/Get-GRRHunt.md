---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# Get-GRRHunt

## SYNOPSIS
Get a list of available hunts. Filter the list with the parameter or
afterwards with PowerShell.

## SYNTAX

### count (Default)
```
Get-GRRHunt [-Credential] <PSCredential> [-ShowJSON] [<CommonParameters>]
```

### Count
```
Get-GRRHunt [-Credential] <PSCredential> [-Count <Int32>] [-Offset <Int32>] [-ShowJSON] [<CommonParameters>]
```

### CreatedBy
```
Get-GRRHunt [-Credential] <PSCredential> [-CreatedBy <String>] -ActiveWithin <String> [-ShowJSON]
 [<CommonParameters>]
```

### DescriptionContains
```
Get-GRRHunt [-Credential] <PSCredential> [-DescriptionContains <String>] -ActiveWithin <String> [-ShowJSON]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Credential
{{Fill Credential Description}}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActiveWithin
{{Fill ActiveWithin Description}}

```yaml
Type: String
Parameter Sets: CreatedBy, DescriptionContains
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Count
{{Fill Count Description}}

```yaml
Type: Int32
Parameter Sets: Count
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatedBy
{{Fill CreatedBy Description}}

```yaml
Type: String
Parameter Sets: CreatedBy
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DescriptionContains
{{Fill DescriptionContains Description}}

```yaml
Type: String
Parameter Sets: DescriptionContains
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
{{Fill Offset Description}}

```yaml
Type: Int32
Parameter Sets: Count
Aliases: 

Required: False
Position: Named
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
Position: Named
Default value: False
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

