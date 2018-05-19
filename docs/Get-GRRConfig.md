---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRConfig.md
schema: 2.0.0
---

# Get-GRRConfig

## SYNOPSIS
Get the current PowerGRR config.

## SYNTAX

```
Get-GRRConfig [<CommonParameters>]
```

## DESCRIPTION
Get the current PowerGRR config.

## EXAMPLES

### Example 1
```
PS> Get-GRRConfig

ConfigFile              GRRUrl                GRRIgnoreCertificateErrors GRRClientCertIssuer
----------              ------                -------------------------- -------------------
...\powergrr-config.ps1 https://grrserver.tld false (default)            none (default)
```

Read the current config.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
