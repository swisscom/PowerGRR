---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRClientIdFromComputerName.md
schema: 2.0.0
---

# Get-GRRClientIdFromComputerName

## SYNOPSIS
Convert a list of computer names into the corresponding GRR client id.

## SYNTAX

```
Get-GRRClientIdFromComputerName [[-ComputerName] <String[]>] [[-Credential] <PSCredential>] [-OnlyLastSeen]
 [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
Convert a list of computer names into the corresponding GRR client id and
display further information about the client.

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRClientIdFromComputerName -ComputerName host1,host2 -Credential $creds

Node    ClientId           LastSeenAt          OSVersion
----    --------           ----------          ---------
host1   C.1111111111111111 18.05.2017 15:48:17 10.0.10586
host1   C.2222222222222222 03.04.2017 14:55:37 6.1.7601
host2   C.3333333333333333 26.06.2017 09:31:32 6.1.7601
```

Search for the client ids for the two hosts. If one host has multiple IDs
(e.g. after a new installation) both are shown. See Example 2 to only show
last seen hosts.

### Example 2
```
PS C:\> Get-GRRClientIdFromComputerName -ComputerName host1,host2 -Credential $creds -OnlyLastSeen

Node    ClientId           LastSeenAt          OSVersion
----    --------           ----------          ---------
host1   C.1111111111111111 18.05.2017 15:48:17 10.0.10586
host2   C.3333333333333333 26.06.2017 09:31:32 6.1.7601
```

Search for the client ids for the two hosts. If multiple client ids are
found, the parameter "OnlyLastSeen" reduce the output to last seen one per
each host. Compare the output to EXAMPLE 1.

### Example 3
```
PS C:\> (Get-GRRClientIdFromComputerName -ComputerName host1,host2  -Credential $creds -OnlyLastSeen).clientid
C.1111111111111111
C.2222222222222222
```

Search for the client id for the two hosts and return only the client id.

## PARAMETERS

### -ComputerName
Computername to search for.

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

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnlyLastSeen
Use the switch to only show the latest seen client id.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Benannt
Default value: False
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

### System.String[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

