---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Find-GRRClient.md
schema: 2.0.0
---

# Find-GRRClient

## SYNOPSIS
Use the GRR search function to search for clients. The function returns only
the computername or the whole GRR object.

## SYNTAX

```
Find-GRRClient [[-SearchString] <String>] [[-Credential] <PSCredential>] [-OnlyComputerName] [-ShowJSON]
 [<CommonParameters>]
```

## DESCRIPTION
Find GRR clients based on the given search string.

## EXAMPLES

### Example 1
```
PS C:\> Find-GRRClient -SearchString keyword -Credential $cred
```

Find GRR clients based on keywords. Use the available prefixes, e.g. "label:" or
"host:" to limit the search results. 

### Example 2
```
PS C:\> Find-GRRClient -SearchString keyword -Credential $cred -OnlyComputerName
```

Find GRR clients based on keywords. Use the available prefixes, e.g. "label:" or
"host:" to limit the search results. Use `-OnlyComputerName` to only display the host
names.

### Example 3
```
PS C:\> Find-GRRClient -SearchString "username" -OnlyComputerName -OnlyComputerName
```

Find GRR clients where the given user was logged in. Use `-OnlyComputerName` to only
display the host names.

### Example 4
```
PS C:\> $ret = Find-GRRClient -SearchString darwin -OnlyComputerName
```

Find GRR clients with the OS "darwin" (MacOS). Use `-OnlyComputerName` to only
display the host names.

## PARAMETERS

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

### -OnlyComputerName
Show only the computername.

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

### -SearchString
Search string with the needed prefix, e.g. label: or host:...

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowJSON
Show the response as JSON instead of parsed object.

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

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
