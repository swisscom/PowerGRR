---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# Get-GRRComputerNameFromClientId

## SYNOPSIS
Search for a specific client id and return the computername.

## SYNTAX

```
Get-GRRComputerNameFromClientId [[-ClientId] <String[]>] [-Credential] <PSCredential> [-ShowJSON]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRComputerNameFromClientId -Credential $creds -ClientId c.1111111111111111
PS C:\> Get-GRRComputerNameFromClientId -Credential $creds -ClientId c.1111111111111111, c.2222222222222222
PS C:\> c.1111111111111111 | Get-GRRComputerNameFromClientId -Credential $cred
PS C:\> c.1111111111111111,c.2222222222222222 | Get-GRRComputerNameFromClientId -Credential $cred
```

Returns the host name for one or multiple client ids. Use the parameter
ClientId or the pipeline as input.

## PARAMETERS

### -ClientId
Client id to search for.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
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

Required: True
Position: 1
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

### System.String[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

