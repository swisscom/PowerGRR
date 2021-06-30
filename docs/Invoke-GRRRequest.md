---
external help file: PowerGRR-help.xml
Module Name: PowerGRR
online version: https://github.com/swisscom/PowerGRR/blob/master/docs/Invoke-GRRRequest.md
schema: 2.0.0
---

# Invoke-GRRRequest

## SYNOPSIS
Helper function for GRR requests. If a function you need is not available you
can use this function to run the needed request.

## SYNTAX

### FILE
```
Invoke-GRRRequest [-Url] <String> -File <FileInfo> [-Headers] <Hashtable> [-Websession] <WebRequestSession>
 [-Method <String>] [[-Credential] <PSCredential>] [-ShowJSON] [<CommonParameters>]
```

### POST
```
Invoke-GRRRequest [-Url] <String> [-Body] <String> [-Headers] <Hashtable> [-Websession] <WebRequestSession>
 [-Method <String>] [[-Credential] <PSCredential>] [-ShowJSON] [<CommonParameters>]
```

### GET
```
Invoke-GRRRequest [-Url] <String> [-FilePath <String>] [-Method <String>] [[-Credential] <PSCredential>]
 [-ShowJSON] [<CommonParameters>]
```

## DESCRIPTION
Helper function for GRR requests. If a function you need is not available, you
can use this function to run the needed request. The headers and websession
are obtained by `Get-GRRSession` and only needed for POST requests.

## EXAMPLES

### Example 1
```
PS C:\> Invoke-GRRRequest -Url "/hunts/$HuntId" -Credential $Credential
```

Use the corresponding API endpoint to get the hunt info.

## PARAMETERS

### -Body
API POST request body.

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
GRR credentials.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
Headers for the API requests (CSRF ...)

```yaml
Type: Hashtable
Parameter Sets: FILE, POST
Aliases:

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowJSON
Return only plain JSON instead of converted JSON objects.

```yaml
Type: SwitchParameter
Parameter Sets: FILE
Aliases:

Required: True
Position: Benannt
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: POST, GET
Aliases:

Required: False
Position: Benannt
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
API endpoint.

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
Websession for the API request.

```yaml
Type: WebRequestSession
Parameter Sets: FILE, POST
Aliases:

Required: True
Position: Benannt
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
HTTP method.

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

### -File
File if an upload is performed.

```yaml
Type: FileInfo
Parameter Sets: FILE
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
File path for the output file from a GRR request.

```yaml
Type: String
Parameter Sets: GET
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
