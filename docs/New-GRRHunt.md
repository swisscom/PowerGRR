---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/powergrr/docs/New-GRRHunt.md
schema: 2.0.0
---

# New-GRRHunt

## SYNOPSIS
Create a new hunt.

## SYNTAX

```
New-GRRHunt [[-HuntDescription] <String>] [-Flow] <String> [[-MatchMode] <String>] [[-RuleType] <String>]
 [[-OS] <String>] [[-Label] <String>] [[-EmailAddress] <String>] [-OnlyUrl] [-Credential] <PSCredential>
 [-ShowJSON] [-WhatIf] [-Confirm]
```

## DESCRIPTION
{{Fill in the Description}}

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
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: True
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

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
Label for which the hunt is created.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MatchMode
Match mode for the rules.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: MATCH_ALL, MATCH_ANY

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OS
OS filter for hunt.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: os_windows, os_darwin, os_linux

Required: False
Position: 4
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

Required: False
Position: 3
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

## INPUTS

### Keine


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

