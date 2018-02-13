---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# Invoke-GRRFlow

## SYNOPSIS
Invoke a flow on one or multiple clients.

## SYNTAX

```
Invoke-GRRFlow [-ComputerName] <String[]> [[-Credential] <Object>] [-Flow] <String> [[-EmailAddress] <String>]
 [-ShowJSON] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Invoke a flow on one or multiple clients. The dynamic parameter "Flow" allows
using dedicated parameters for each flow type.

Use the following dynamic parameters for each flow type (-Flow) to specifcy the
needed values. Mandatory parameters are attributed with (m). 
- Netstat: 
- FileFinder: 
   - Path (m), Type: String[]
   - ActionType (m), ValidateSet: Hash, Download
   - ConditionType, ValidateSet: Regex,Literal
   - Mode, ValidateSet: All_HITS, FIRST_HIT
   - SearchString, Type: String
- RegistryFinder: 
   - Key (m), Type: String[]
   - ConditionType, ValidateSet: Regex,Literal
   - Mode, ValidateSet: All_HITS, FIRST_HIT
   - ConditionValue, Type: String
- ListProcesses: 
   - FileNameRegex, Type: string
- ExecutePythonHack: 
   - HackName (m), Type: string
   - PyArgsName (m), Type: string
   - PyArgsValue (m), Type: string
- ArtifactCollectorFlow:
   - ArtifactList (m), Type: String[]
- YaraProcessScan:
   - YaraSignatureFile (m), Type: string

## EXAMPLES

### Example 1
```
PS C:\> Invoke-GRRFlow -ComputerName host1 -Credential $cred -Flow FileFinder -path "C:\test.exe" -actiontype hash
```

Start a new file finder flow.

### Example 2
```
PS C:\> Invoke-GRRFlow -ComputerName host1 -Credential $cred -Flow FileFinder -path "C:\Files\*" -actiontype hash -ConditionType Literal -SearchString "GRR"
```

Start a new file finder flow and use the literal condition.

### Example 3
```
PS C:\> Invoke-GRRFlow -ComputerName host1 -Credential $cred -Flow FileFinder -path "C:\Files\*" -actiontype hash -ConditionType Regex -SearchString ".*GRR.*"
```

Start a new file finder flow and use the regex condition.

### Example 4
```
Invoke-GRRFlow -Flow YaraProcessScan -ComputerName host1 -Credential $cred -YaraSignatureFile $FilePathToYaraRule
```

Start a Yara scan on the specific host with the provided Yara rule.


## PARAMETERS

### -ComputerName
ComputerName for the GRR flow. If multiple clients were found in GRR the last
seen on client will be used for the flow.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Benannt
Default value: False
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
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAddress
Email address for the output plugin. The count is set to 1 so your get en email
if something is found.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Flow
Dynamic parameter "flow" allows specificing the desired flow type. Use the flow
specific parameters to provide the needed information.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: Netstat, ListProcesses, FileFinder, RegistryFinder, ExecutePythonHack, ArtifactCollectorFlow

Required: True
Position: 2
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
Default value: False
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

