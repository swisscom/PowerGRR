---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/New-GRRHunt.md
schema: 2.0.0
---

# New-GRRHunt

## SYNOPSIS
Create a new hunt.

Flow types:
- FileFinder: 
   - Path (m), Type: String[]
   - ActionType (m), ValidateSet: Hash, Download
   - ConditionType, ValidateSet: Regex,Literal
   - Mode, ValidateSet: All_HITS, FIRST_HIT
   - SearchString, Type: String
- RegistryFinder: 
   - Key (m), Type: String[]
- ListProcesses: 
   - FileNameRegex, Type: string
- ExecutePythonHack: 
   - HackName (m), Type: string
   - PyArgsName (m), Type: string
   - PyArgsValue (m), Type: string
- ArtifactCollectorFlow:
   - ArtifactList (m), Type: String[]
   - UseTsk, Type: switch
- YaraProcessScan:
   - YaraSignatureFile (m), Type: string

## SYNTAX

```
New-GRRHunt [-HuntDescription] <String> [-Flow] <String> [-RuleType] <String> [-ClientRate <Int32>]
 [-ClientLimit <Int32>] [[-EmailAddress] <String>] [-OnlyId] [-OnlyUrl] [[-Credential] <Object>] [-ShowJSON]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a new hunt with the given flow properties.

## EXAMPLES

### Example 1
```
PS C:\> New-GRRHunt -Credential $cred -HuntDescription "Hunting for malicious launch agent" -Flow FileFinder -EmailAddress emailadress@for-notifications.tld -MatchMode MATCH_ALL -OnlyUrl -RuleType label -Label label1 -path "/Users/knockknock/Library/LaunchAgents/apple.evil.plist" -actiontype hash
```

Create a new hunt and show only the URL after creating the hunt.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
GRR credentials.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAddress
Email address for the notification after the first result.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Flow
Flow type for the hunt.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: Netstat, ListProcesses, FileFinder, RegistryFinder, ExecutePythonHack, ArtifactCollectorFlow

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HuntDescription
Hunt description.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnlyUrl
Return only the url to the web ui.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RuleType
Rule type for the hunt.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: Label, OS

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowJSON
Return plain JSON instead of parsed JSON object.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientLimit
Client limit number. 0 for all hosts, 100 for 100 hosts only.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientRate
Client rate for that hunt. 0 no limit, 500 means 500 hosts per minute. Test
the possibilities for your environment. If the rate is set to high,
performance issues will arise.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnlyId
Return only the hunt id for post-processing (e.g. create an approval based on
this hunt id directly).

```yaml
Type: SwitchParameter
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

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

