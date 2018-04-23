---
external help file: PowerGRR-help.xml
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Get-GRRArtifact.md
schema: 2.0.0
---

# Get-GRRArtifact

## SYNOPSIS
Get a list of all GRR artifacts.

## SYNTAX

```
Get-GRRArtifact [-Credential] <PSCredential> [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
Get the list of available artifacts. The return object is a PowerShell object
which is easily to filter with common PowerShell cmdlets. See example.

## EXAMPLES

### Example 1
```
PS C:\> Get-GRRArtifact -Credential $cred
```

List all artifacts.

### Example 2
```
PS C:\> $osx = Get-GRRArtifact -Credential $cred | ? {$_.name -match "osx"} | select name, description, iscustom
PS C:\> $osx

Name                  Description                                                      IsCustom
----                  -----------                                                      --------
OSXSPHardwareDataType Mac OS X system profiler.                                           False
OSXServices           Running services from the Max OS X service management framework.    False
OSXUsers              Users directories in /Users                                         False
```

### Example 3
```
PS C:\> Get-GRRArtifact -Credential $cred | ?{ $_.SupportedOS -match "windows" -and $_.name -match "dns" }

Name        : WindowsDNSNameServer
Description : Windows DNS and DHCP Server Registry Keys.
IsCustom    : True
URLs        : https://technet.microsoft.com/en-us/library/dd197418(v=ws.10).aspx
Labels      : {System, Network}
SupportedOS : {Windows}
Type        : REGISTRY_VALUE
Attributes  : @{key_value_pairs=System.Object[]}
```

### Example 4
```
PS C:\> Get-GRRArtifact -Credential $cred | ? {$_iscustom -eq $true}

Name        : WindowsDNSNameServer
Description : Windows DNS and DHCP Server Registry Keys.
IsCustom    : True
URLs        : https://technet.microsoft.com/en-us/library/dd197418(v=ws.10).aspx
Labels      : {System, Network}
SupportedOS : {Windows}
Type        : REGISTRY_VALUE
Attributes  : @{key_value_pairs=System.Object[]}
```

List all custom artifacts.

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

### -ShowJSON
Return only plain JSON instead of converted JSON objects.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Keine

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

