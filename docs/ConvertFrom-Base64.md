---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/ConvertFrom-Base64.md
schema: 2.0.0
---

# ConvertFrom-Base64

## SYNOPSIS
Decode a base64 encoded string. This function is used also inside fetching
results when only payload should be returned.

## SYNTAX

```
ConvertFrom-Base64 [-String] <String> [-Encoding <String>] [<CommonParameters>]
```

## DESCRIPTION
Some flows return an base64 encoded string in the payload.
Use this function to convert it.

## EXAMPLES

### Example 1
```
PS C:\> $sha256_b64 = $_.payload.hash_entry.sha256; $hash = Convertfrom-Base64 $sha256_b64 -Encoding Unicode | ConvertTo-Hex
```

Convert the collected sha256 hash (hash_entry e.g. from file finder flow) to
the corresponding hex representation. The payload from GRR is base64 encoded,
therefore Convertfrom-Base64 provides the needed step in between. For a hash
conversion the use of "-Encoding Unicode" is needed.

### Example 2
```
PS C:\> ConvertFrom-Base64 "R1JSIGlzIGF3ZXNvbWU="
```

Convert the collected sha256 hash (hash_entry e.g. from file finder flow) to
the corresponding hex representation. The payload from GRR is base64 encoded,
therefore Convertfrom-Base64 provides the needed step in between.

### Example 3
```
PS C:\> $ret = $ret.items | ? {($_.payload | ConvertFrom-Base64) -match "false" } 
```

Analyse return values from a hunt and filter them for specific payload values.

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

### -Encoding
Encoding to use. Unicode or UTF8.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
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

