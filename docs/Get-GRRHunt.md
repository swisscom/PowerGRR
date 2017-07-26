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

### Count (Default)
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
PS C:\> Get-GRRHunts -Credential $cred | select -First 1
```

Find last hunt id. You can use all the filtering from PowerShell. Each hunt is
represented as an own PowerShell object. The disadvantage of this
POST-filtering is that the command first returns every hunt. See next example
to use a PRE-filtering.

### Example 2
```
PS C:\> Get-GRRHunts -Credential $cred -Count 5
```

Find last 5 hunt id. You can use all the filtering from PowerShell. Each hunt
is represented as an own PowerShell object. The advantage of this usage is
that GRR server filters the hunts on the server before returning the response.

## PARAMETERS

### -Credential
GRR credentials.

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
The amount of returned hunts.

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
Author of a hunt.

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
Text which is contains within the hunt description.

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
Offset for the search.

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

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

