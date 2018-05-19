---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/powergrr/blob/master/docs/ConvertFrom-EpocTime.md
schema: 2.0.0
---

# ConvertFrom-EpocTime

## SYNOPSIS
Convert a unix timestamp into UTC.

## SYNTAX

```
ConvertFrom-EpocTime [-UnixTime] <Int64[]> [<CommonParameters>]
```

## DESCRIPTION
Convert a unix timestamp into UTC.

## EXAMPLES

### Example 1
```
PS C:\> ConvertFrom-EpocTime 1514997715

Mittwoch, 3. Januar 2018 16:41:55

PS C:\> 1514997715 | ConvertFrom-EpocTime

Mittwoch, 3. Januar 2018 16:41:55
```

Convert the specified unix timestamp into UTC. Use pipeline if needed.

## PARAMETERS

### -UnixTime
Unix timestamp to convert.

```yaml
Type: Int64[]
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

### System.Int64[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
