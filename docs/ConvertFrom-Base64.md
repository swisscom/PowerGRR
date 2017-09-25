---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/powergrr/docs/ConvertFrom-Base64.md
schema: 2.0.0
---

# ConvertFrom-Base64

## SYNOPSIS
Decode a base64 encoded string.

## SYNTAX

```
ConvertFrom-Base64 [-String] <String> [-Encoding <String>]
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

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

