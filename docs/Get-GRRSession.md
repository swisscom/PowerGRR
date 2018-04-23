---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# Get-GRRSession

## SYNOPSIS
Return the headers and the websession for a specific GRR server.

## SYNTAX

```
Get-GRRSession [-Credential] <PSCredential> [<CommonParameters>]
```

## DESCRIPTION
Return the headers and the websession for a specific GRR server.

Used inside GRR requests to get the GRR session. Can be used manually in the
console. 

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRSession -Credential $cred
```

Gets a new GRR session and obtains the headers and the CSRF token.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

