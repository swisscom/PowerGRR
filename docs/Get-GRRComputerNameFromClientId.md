---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# Get-GRRComputerNameFromClientId

## SYNOPSIS
Search for a specific client id and return the computer name.

## SYNTAX

```
Get-GRRComputerNameFromClientId [[-ClientId] <String[]>] [-Credential] <PSCredential> [-ShowJSON]
 [<CommonParameters>]
```

## DESCRIPTION
Search for a specific client id and return the computer name.

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

### Example 2
```
PS C:\> $ret.items.client_id | unique | Get-GRRComputerNameFromClientId -Credential $cred
PS C:\> $ret.items.client_id | unique | Get-GRRComputerNameFromClientId -Credential $cred | select -ExpandProperty computername | Get-GRRClientInfo -Credential $cred |  select -ExpandProperty usernames
```

Convert the client id's from a hunt into their corresponding computer names.
In the 2nd example the computer names are then used with `Get-GRRClientInfo` and
therefore the logged in users from these hosts can be found.

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
Return only plain JSON instead of converted JSON objects.

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

