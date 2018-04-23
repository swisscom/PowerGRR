---
Module Name: PowerGRR
Module Guid: 5bdf023f-fe8a-4748-bd73-43a449791ba8
Download Help Link: https://github.com/swisscom/PowerGRR/blob/master/en-us/PowerGRR-help.xml
Help Version: 1.0.0.0
Locale: en-US
---

# PowerGRR Module
## Description

PowerGRR is a PowerShell module for working with the GRR API. It allows
working with flows, hunts, labels and the GRR search. Furthermore, it allows
working with the computer names instead of the GRR internal client id. This
makes the handling and working with other tools more easy because often you
just have the computer names.

## PowerGRR Cmdlets
### [Add-GRRArtifact](Add-GRRArtifact.md)
Upload artifact to GRR.

### [ConvertFrom-Base64](ConvertFrom-Base64.md)
Decode a base64 encoded string.

### [Get-GRRArtifact](Get-GRRArtifact.md)
Get the list of available artifacts.

### [Find-GRRClient](Find-GRRClient.md)
Use the GRR search function to search for clients. The function returns only
the computername or the whole GRR object.

### [Find-GRRClientByLabel](Find-GRRClientByLabel.md)
Search for clients with a given label.

### [Get-GRRClientApproval](Get-GRRClientApproval.md)
Get client approvals identified by the given filters. 

### [Get-GRRClientIdFromComputerName](Get-GRRClientIdFromComputerName.md)
Convert a computername into the corresponding GRR client id.

### [Get-GRRClientInfo](Get-GRRClientInfo.md)
Get various information about a specific host.

### [Get-GRRComputerNameFromClientId](Get-GRRComputerNameFromClientId.md)
Search for a specific client id and return the computername.

### [Get-GRRConfig](Get-GRRConfig.md)
Get the current PowerGRR config.

### [Get-GRRFlowDescriptor](Get-GRRFlowDescriptor.md)
Get a list of all available flows.

### [Get-GRRFlowResult](Get-GRRFlowResult.md)
Get flow results for a specific client and a flow.

### [Get-GRRHunt](Get-GRRHunt.md)
Get a list of available hunts. Filter the list with the parameter or
afterwards with PowerShell.

### [Get-GRRHuntApproval](Get-GRRHuntApproval.md)
Get hunt approvals identified by the given filters. 

### [Get-GRRHuntInfo](Get-GRRHuntInfo.md)
Get hunt info for a specific hunt.

### [Get-GRRHuntResult](Get-GRRHuntResult.md)
Get hunt results for a specific hunt.

### [Get-GRRLabel](Get-GRRLabel.md)
Get all labels.

### [Get-GRRSession](Get-GRRSession.md)
Return the headers and the websession for a specific GRR server.

### [Invoke-GRRFlow](Invoke-GRRFlow.md)
Invoke a flow on one or multiple clients.

### [Invoke-GRRRequest](Invoke-GRRRequest.md)
Helper function for GRR requests. If a function you need is not available you
can use this function to run the needed request.

### [New-GRRClientApproval](New-GRRClientApproval.md)
Create a new client approval.

### [New-GRRHunt](New-GRRHunt.md)
Create a new hunt.

### [New-GRRHuntApproval](New-GRRHuntApproval.md)
Create a new hunt approval.

### [Remove-GRRArtifact](Remove-GRRArtifact.md)
Remove artifact in GRR.

### [Remove-GRRLabel](Remove-GRRLabel.md)
Remove a label on a range of clients.

### [Set-GRRLabel](Set-GRRLabel.md)
Set a label on one or multiple clients. The function has pipeline support.

### [Start-GRRHunt](Start-GRRHunt.md)
Start a GRR hunt based on the hunt id.

### [Stop-GRRHunt](Stop-GRRHunt.md)
Stop a GRR hunt based on the hunt id.

### [Wait-GRRClientApproval](Wait-GRRClientApproval.md)
Wait for client approval.

### [Wait-GRRHuntApproval](Wait-GRRHuntApproval.md)
Wait for hunt approval.
