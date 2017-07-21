---
external help file: PowerGRR-help.xml
online version: 
schema: 2.0.0
---

# Invoke-GRRRequest

## SYNOPSIS
Helper function for GRR requests. If a function you need is not available you
can use this function to run the needed request.

## SYNTAX

### POST
```
Invoke-GRRRequest [-Url] <String> [-Body] <String> [-Headers] <Hashtable> [-Websession] <WebRequestSession>
 [-Method <String>] [-Credential] <PSCredential> [-ShowJSON] [<CommonParameters>]
```

### GET
```
Invoke-GRRRequest [-Url] <String> [-Method <String>] [-Credential] <PSCredential> [-ShowJSON]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Body
{{Fill Body Description}}

```yaml
Type: String
Parameter Sets: POST
Aliases: 

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
{{Fill Credential Description}}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
{{Fill Headers Description}}

```yaml
Type: Hashtable
Parameter Sets: POST
Aliases: 

Required: True
Position: Benannt
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
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
{{Fill Url Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Websession
{{Fill Websession Description}}

```yaml
Type: WebRequestSession
Parameter Sets: POST
Aliases: 

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
{{Fill Method Description}}

```yaml
Type: String
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

