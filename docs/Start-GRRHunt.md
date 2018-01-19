---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# Start-GRRHunt

## SYNOPSIS
Start a GRR hunt based on the hunt id.

## SYNTAX

### Default (Default)
```
Start-GRRHunt [-Credential] <PSCredential> [[-HuntId] <String>] [-ShowJSON] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### WaitForApproval
```
Start-GRRHunt [-Credential] <PSCredential> [[-HuntId] <String>] [-Wait] -ApprovalId <String>
 [-TimeoutInMinutes <Int32>] [-ShowJSON] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> Start-GRRHunt -Credential $cred -HuntId H:AAAAAAAA
```

Start the specific hunt. Approval must be granted before.

### Example 2
```
Start-GRRHunt -HuntId $huntid -Credential $cred -Wait -ApprovalId $approval -TimeoutInMinutes 15 -Verbose
```

Start the specific hunt and wait until given approval gets valid.

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
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HuntId
HuntId of the hunt which should be started.

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
Show plain JSON as output instead of the return object.

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

### -ApprovalId
{{Fill ApprovalId Description}}

```yaml
Type: String
Parameter Sets: WaitForApproval
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutInMinutes
{{Fill TimeoutInMinutes Description}}

```yaml
Type: Int32
Parameter Sets: WaitForApproval
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
{{Fill Wait Description}}

```yaml
Type: SwitchParameter
Parameter Sets: WaitForApproval
Aliases: 

Required: True
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

