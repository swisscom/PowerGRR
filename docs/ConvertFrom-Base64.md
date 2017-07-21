---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# ConvertFrom-Base64

## SYNOPSIS
Decode a base64 encoded string.

## SYNTAX

```
ConvertFrom-Base64 [-String] <String> [<CommonParameters>]
```

## DESCRIPTION
Some flows return an base64 encoded string in the payload. Use this function
to convert it.

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -String
Base64 encoded string to decode.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

