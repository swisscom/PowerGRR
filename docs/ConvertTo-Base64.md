---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/ConvertTo-Base64.md
schema: 2.0.0
---

# ConvertTo-Base64

## SYNOPSIS
Encodes a string into base64.

This function is used inside other functions. Not used directly for day to day
work.

## SYNTAX

```
ConvertTo-Base64 [-Value] <String[]> [[-Encoding] <Encoding>] [<CommonParameters>]
```

## DESCRIPTION
Encodes a string into base64.

## EXAMPLES

### Example 1
```
PS C:\> "string to convert" | ConvertTo-Base64
```

Convert the string to base64.

## PARAMETERS

### -Encoding
Encoding type - use `[Text.Encoding]::...` to specify the encoding.

`[Text.Encoding]::ASCII` is used by default.

```yaml
Type: Encoding
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
String to convert to base64.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
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

