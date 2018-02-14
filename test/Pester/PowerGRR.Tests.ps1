Set-StrictMode -Version latest

$BasePath = "$PSScriptRoot\..\..\"

Import-Module -Force $BasePath\PowerGRR.psm1

# Setup before all tests

$password = "bad"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$global:PesterTestCredentials = New-Object System.Management.Automation.PSCredential -ArgumentList "user", $secureStringPwd

$global:NoItem = @"
)]}`'
{`"noitem`": []}
"@

$global:EmptyItem = @"
)]}`'
{`"items`": []}
"@

$global:StatusOK = @"
)]}`'
{`"Status`": `"OK`"}
"@

$global:EmptyReturnObject = @"
)]}`'
{`"items`": [], `"total_count`": 0}
"@

$global:ValidLabels = @"
)]}`'
{`"items`": [{`"name`": `"label1`"}, {`"name`": `"label2`"}, {`"name`": `"label3`"}]}
"@

$global:ValidClientItem = @"
)]}`'
{`"items`": [{`"users`": [{`"username`": `"doej`", `"cookies`": `"C:\\Users\\doej\\AppData\\Local\\Microsoft\\Windows\\INetCookies`", `"appdata`": `"C:\\Users\\doej\\AppData\\Roaming`", `"temp`": `"C:\\Users\\doej\\AppData\\Local\\Temp`", `"userdomain`": `"aaaaaaaaaaaa`", `"personal`": `"\\\\aaaaaaaa\\doej$\\Documents`", `"userprofile`": `"C:\\Users\\doej`", `"startup`": `"C:\\Users\\doej\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup`", `"desktop`": `"\\\\aaaaaaaa\\doej$\\Desktop`", `"localappdata_low`": `"C:\\Users\\doej\\AppData\\LocalLow`", `"internet_cache`": `"C:\\Users\\doej\\AppData\\Local\\Microsoft\\Windows\\INetCache`", `"localappdata`": `"C:\\Users\\doej\\AppData\\Local`", `"sid`": `"S-1-1-11-123456789-1234567890-123456789-123456`", `"recent`": `"C:\\Users\\doej\\AppData\\Roaming\\Microsoft\\Windows\\Recent`", `"homedir`": `"C:\\Users\\doej`"}, {`"username`": `"doej`", `"sid`": `"S-1-1-11-123456789-1234567890-123456789-123456`", `"homedir`": `"C:\\Users\\doej`", `"userprofile`": `"C:\\Users\\doej`"}], `"urn`": `"aff4:/C.1234567890123456`", `"labels`": [{`"owner`": `"john.doe`", `"timestamp`": 1492512048460665, `"name`": `"aaaaaaa`"}, {`"owner`": `"john.doe`", `"timestamp`": 1495125219951270, `"name`": `"doej`"}, {`"owner`": `"john.doe`", `"timestamp`": 1496419392959513, `"name`": `"testxy`"}], `"agent_info`": {`"client_name`": `"GRR`", `"client_description`": `"GRR windows amd64`", `"client_version`": 3102, `"build_time`": `"2016-06-17 01:18:24`"}, `"last_clock`": 1497265714831000, `"hardware_info`": {`"serial_number`": `"aaaaaaaaaa`", `"system_manufacturer`": `"Hewlett-Packard`"}, `"last_booted_at`": 1496141438000000, `"volumes`": [{`"sectors_per_allocation_unit`": 1, `"name`": `"SYSTEM`", `"windowsvolume`": {`"drive_letter`": `"C:`", `"drive_type`": `"DRIVE_FIXED`"}, `"file_system_type`": `"NTFS`", `"actual_available_allocation_units`": 87678074880, `"total_allocation_units`": 234177425408, `"serial_number`": `"26C76245`", `"bytes_per_sector`": 1}], `"interfaces`": [{`"ifname`": `"Intel(R) Ethernet Connection I218-LM`", `"addresses`": [{`"packed_bytes`": `"CjnbMQ==`", `"address_type`": `"INET`"}, {`"packed_bytes`": `"/oAAAAAAAAA0JStyIQZoGg==`", `"address_type`": `"INET6`"}], `"mac_address`": `"0L+cJSlp`"}, {`"ifname`": `"VirtualBox Host-Only Ethernet Adapter`", `"addresses`": [{`"packed_bytes`": `"wKg4AQ==`", `"address_type`": `"INET`"}, {`"packed_bytes`": `"/oAAAAAAAAAda8/cvH0Mkw==`", `"address_type`": `"INET6`"}], `"mac_address`": `"CgAnAAAC`"}], `"last_seen_at`": 1497265714865771, `"first_seen_at`": 1491288947032091, `"os_info`": {`"node`": `"AABBCCDD`", `"kernel`": `"10.0.10586`", `"install_date`": 1491234822000000, `"system`": `"Windows`", `"fqdn`": `"AABBCCDD.aaaaaaaaaa.net`", `"machine`": `"AMD64`", `"version`": `"10.0.10586SP0`", `"release`": `"10`"}},{`"users`": [{`"username`": `"doej`", `"cookies`": `"C:\\Users\\doej\\AppData\\Local\\Microsoft\\Windows\\INetCookies`", `"appdata`": `"C:\\Users\\doej\\AppData\\Roaming`", `"temp`": `"C:\\Users\\doej\\AppData\\Local\\Temp`", `"userdomain`": `"aaaaaaaaaa`", `"personal`": `"\\\\aaaaaaaa\\doej$\\Documents`", `"userprofile`": `"C:\\Users\\doej`", `"startup`": `"C:\\Users\\doej\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup`", `"desktop`": `"\\\\aaaaaaaa\\doej$\\Desktop`", `"localappdata_low`": `"C:\\Users\\doej\\AppData\\LocalLow`", `"internet_cache`": `"C:\\Users\\doej\\AppData\\Local\\Microsoft\\Windows\\INetCache`", `"localappdata`": `"C:\\Users\\doej\\AppData\\Local`", `"sid`": `"S-1-1-11-123456789-1234567890-123456789-123456`", `"recent`": `"C:\\Users\\doej\\AppData\\Roaming\\Microsoft\\Windows\\Recent`", `"homedir`": `"C:\\Users\\doej`"}, {`"username`": `"doej`", `"sid`": `"S-1-1-11-123456789-1234567890-123456789-123456`", `"homedir`": `"C:\\Users\\doej`", `"userprofile`": `"C:\\Users\\doej`"}], `"urn`": `"aff4:/C.1234567890123456`", `"labels`": [{`"owner`": `"john.doe`", `"timestamp`": 1492512048460665, `"name`": `"aaaaaaa`"}, {`"owner`": `"john.doe`", `"timestamp`": 1495125219951270, `"name`": `"doej`"}, {`"owner`": `"john.doe`", `"timestamp`": 1496419392959513, `"name`": `"testxy`"}], `"agent_info`": {`"client_name`": `"GRR`", `"client_description`": `"GRR windows amd64`", `"client_version`": 3102, `"build_time`": `"2016-06-17 01:18:24`"}, `"last_clock`": 1497265714831000, `"hardware_info`": {`"serial_number`": `"aaaaaaaaaa`", `"system_manufacturer`": `"Hewlett-Packard`"}, `"last_booted_at`": 1496141438000000, `"volumes`": [{`"sectors_per_allocation_unit`": 1, `"name`": `"SYSTEM`", `"windowsvolume`": {`"drive_letter`": `"C:`", `"drive_type`": `"DRIVE_FIXED`"}, `"file_system_type`": `"NTFS`", `"actual_available_allocation_units`": 87678074880, `"total_allocation_units`": 234177425408, `"serial_number`": `"26C76245`", `"bytes_per_sector`": 1}], `"interfaces`": [{`"ifname`": `"Intel(R) Ethernet Connection I218-LM`", `"addresses`": [{`"packed_bytes`": `"CjnbMQ==`", `"address_type`": `"INET`"}, {`"packed_bytes`": `"/oAAAAAAAAA0JStyIQZoGg==`", `"address_type`": `"INET6`"}], `"mac_address`": `"0L+cJSlp`"}, {`"ifname`": `"VirtualBox Host-Only Ethernet Adapter`", `"addresses`": [{`"packed_bytes`": `"wKg4AQ==`", `"address_type`": `"INET`"}, {`"packed_bytes`": `"/oAAAAAAAAAda8/cvH0Mkw==`", `"address_type`": `"INET6`"}], `"mac_address`": `"CgAnAAAC`"}], `"last_seen_at`": 1497265714865771, `"first_seen_at`": 1491288947032091, `"os_info`": {`"node`": `"AABBCCDD`", `"kernel`": `"10.0.10586`", `"install_date`": 1491234822000000, `"system`": `"Windows`", `"fqdn`": `"AABBCCDD.aaaaaaaaaaaaa.net`", `"machine`": `"AMD64`", `"version`": `"10.0.10586SP0`", `"release`": `"10`"}}]}
"@

$global:ValidSingleClientItem = @"
)]}`'
{`"items`": [{`"users`": [{`"username`": `"doej`", `"cookies`": `"C:\\Users\\doej\\AppData\\Local\\Microsoft\\Windows\\INetCookies`", `"appdata`": `"C:\\Users\\doej\\AppData\\Roaming`", `"temp`": `"C:\\Users\\doej\\AppData\\Local\\Temp`", `"userdomain`": `"aaaaaaaaaaaa`", `"personal`": `"\\\\aaaaaaaa\\doej$\\Documents`", `"userprofile`": `"C:\\Users\\doej`", `"startup`": `"C:\\Users\\doej\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup`", `"desktop`": `"\\\\aaaaaaaa\\doej$\\Desktop`", `"localappdata_low`": `"C:\\Users\\doej\\AppData\\LocalLow`", `"internet_cache`": `"C:\\Users\\doej\\AppData\\Local\\Microsoft\\Windows\\INetCache`", `"localappdata`": `"C:\\Users\\doej\\AppData\\Local`", `"sid`": `"S-1-1-11-123456789-1234567890-123456789-123456`", `"recent`": `"C:\\Users\\doej\\AppData\\Roaming\\Microsoft\\Windows\\Recent`", `"homedir`": `"C:\\Users\\doej`"}, {`"username`": `"doej`", `"sid`": `"S-1-1-11-123456789-1234567890-123456789-123456`", `"homedir`": `"C:\\Users\\doej`", `"userprofile`": `"C:\\Users\\doej`"}], `"urn`": `"aff4:/C.1234567890123456`", `"labels`": [{`"owner`": `"john.doe`", `"timestamp`": 1492512048460665, `"name`": `"aaaaaaa`"}, {`"owner`": `"john.doe`", `"timestamp`": 1495125219951270, `"name`": `"doej`"}, {`"owner`": `"john.doe`", `"timestamp`": 1496419392959513, `"name`": `"testxy`"}], `"agent_info`": {`"client_name`": `"GRR`", `"client_description`": `"GRR windows amd64`", `"client_version`": 3102, `"build_time`": `"2016-06-17 01:18:24`"}, `"last_clock`": 1497265714831000, `"hardware_info`": {`"serial_number`": `"aaaaaaaaaa`", `"system_manufacturer`": `"Hewlett-Packard`"}, `"last_booted_at`": 1496141438000000, `"volumes`": [{`"sectors_per_allocation_unit`": 1, `"name`": `"SYSTEM`", `"windowsvolume`": {`"drive_letter`": `"C:`", `"drive_type`": `"DRIVE_FIXED`"}, `"file_system_type`": `"NTFS`", `"actual_available_allocation_units`": 87678074880, `"total_allocation_units`": 234177425408, `"serial_number`": `"26C76245`", `"bytes_per_sector`": 1}], `"interfaces`": [{`"ifname`": `"Intel(R) Ethernet Connection I218-LM`", `"addresses`": [{`"packed_bytes`": `"CjnbMQ==`", `"address_type`": `"INET`"}, {`"packed_bytes`": `"/oAAAAAAAAA0JStyIQZoGg==`", `"address_type`": `"INET6`"}], `"mac_address`": `"0L+cJSlp`"}, {`"ifname`": `"VirtualBox Host-Only Ethernet Adapter`", `"addresses`": [{`"packed_bytes`": `"wKg4AQ==`", `"address_type`": `"INET`"}, {`"packed_bytes`": `"/oAAAAAAAAAda8/cvH0Mkw==`", `"address_type`": `"INET6`"}], `"mac_address`": `"CgAnAAAC`"}], `"last_seen_at`": 1497265714865771, `"first_seen_at`": 1491288947032091, `"os_info`": {`"node`": `"AABBCCDD`", `"kernel`": `"10.0.10586`", `"install_date`": 1491234822000000, `"system`": `"Windows`", `"fqdn`": `"AABBCCDD.aaaaaaaaaa.net`", `"machine`": `"AMD64`", `"version`": `"10.0.10586SP0`", `"release`": `"10`"}}]}
"@

$global:ValidHuntInfo = @"
)]}`'
{`"hunt_runner_args`": {`"client_rule_set`": {`"rules`": [{`"os`": {`"os_windows`": true}}]}, `"description`": `"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa`", `"hunt_name`": `"GenericHunt`", `"client_limit`": 0, `"token`": {`"username`": `"john.doe`", `"process`": `"GRRAdminUI`", `"reason`": `"`", `"source_ips`": [`"127.0.0.1`"], `"expiry`": 1496838098743458}, `"client_rate`": 500.0}, `"client_rule_set`": {`"rules`": [{`"os`": {`"os_windows`": true}}]}, `"name`": `"GenericHunt`", `"created`": 1496838038743899, `"completed_clients_count`": 11, `"urn`": `"aff4:/hunts/H:aaaaaaaa`", `"expires`": 1498047836000000, `"total_net_usage`": 33162796, `"remaining_clients_count`": 1111, `"is_robot`": false, `"state`": `"STARTED`", `"all_clients_count`": 1234, `"creator`": `"john.doe`", `"client_limit`": 0, `"hunt_args`": {`"flow_runner_args`": {`"base_session_id`": `"aff4:/hunts/H:aaaaaaaa/C.1234567890123456`", `"flow_name`": `"RegistryFinder`", `"write_intermediate_results`": false, `"creator`": `"john.doe`", `"queue`": `"aff4:/H`", `"token`": {`"username`": `"GRRWorker`"}, `"client_id`": `"aff4:/C.1234567890123456`", `"notify_to_user`": false, `"request_state`": {`"response_count`": 0, `"client_id`": `"aff4:/C.1234567890123456`", `"id`": 20312, `"session_id`": `"aff4:/hunts/H:aaaaaaaa`", `"next_state`": `"MarkDone`"}, `"logs_collection_urn`": `"aff4:/hunts/H:aaaaaaaa/Logs`"}, `"flow_args`": {`"keys_paths`": [`"HKEY_LOCAL_MACHINE\\SYSTEM\\ControlSet00#\\Services\\aaaaaaaaa`", `"HKEY_LOCAL_MACHINE\\Software\\CLASSES\\aa\\aaaaa`", `"HKEY_LOCAL_MACHINE\\Software\\CLASSES\\aa`"]}}, `"client_rate`": 500, `"total_cpu_usage`": 4360.63303694129, `"description`": `"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa`"}
"@

$global:ValidHuntResults = @"
)]}`'
{`"items`": [{`"timestamp`": 1496410785929141, `"payload`": `"Cg==`", `"client_id`": `"aff4:/C.1234567890123456`", `"payload_type`": `"RDFBytes`"}], `"total_count`": 1}
"@

$global:ValidStartFlowReturnObject = @"
)]}`'
{`"last_active_at`": 1497268188392255, `"name`": `"RegistryFinder`", `"creator`": `"john.doe`", `"urn`": `"aff4:/C.1234567890123456/flows/F:22222222`", `"args`": {`"keys_paths`": [`"HKEY_USERS/%%users.sid%%/Software/Microsoft/Windows/CurrentVersion/Run/*`"]}, `"state`": `"RUNNING`", `"started_at`": 1497268188370316}
"@

$global:ValidFlowDescriptor = @"
)]}`'
{`"items`": [{`"category`": `"Processes`", `"name`": `"ListProcesses`", `"doc`": `"List running processes on a system.\n\n  Call Spec:\n    flow.GRRFlow.StartFlow(client_id=client_id, flow_name=\`"ListProcesses\`", filename_regex=filename_regex, fetch_binaries=fetch_binaries, connection_states=connection_states)\n\n  Args:\n    connection_states\n      description: Network connection states to match. If a process has any network connections in any status listed here, it will be considered a match\n      type: \n      default: None\n\n    fetch_binaries\n      description: \n      type: RDFBool\n      default: 0\n\n    filename_regex\n      description: Regex used to filter the list of processes.\n      type: RegularExpression\n      default: .\n`", `"args_type`": `"ListProcessesArgs`", `"behaviours`": [`"ADVANCED`", `"BASIC`", `"Client Flow`"], `"default_args`": {}}]}
"@

$global:ValidArtifacts = @"
)]}`'
{`"items`": [{`"is_custom`": false, `"processors`": [{`"output_types`": [`"AttributedDict`"], `"name`": `"APTPackageSourceParser`", `"description`": `"Parser for APT source lists to extract URIs only.`"}], `"path_dependencies`": [], `"artifact_source`": `"{ \`"conditions\`": [],\n  \`"dependencies\`": [],\n  \`"doc\`": \`"APT package sources list\`",\n  \`"labels\`": [ \`"Configuration Files\`", \`"System\`"\n  ],\n  \`"name\`": \`"APTSources\`",\n  \`"provides\`": [],\n  \`"sources\`": [\n    { \`"attributes\`": { \`"paths\`": [\n          \`"/etc/apt/sources.list\`",\n          \`"/etc/apt/sources.list.d/*.list\`"\n        ]\n      },\n      \`"returned_types\`": [],\n      \`"type\`": \`"FILE\`"\n    }\n  ],\n  \`"supported_os\`": [ \`"Linux\`" ],\n  \`"urls\`": [ \`"http://manpages.ubuntu.com/manpages/trusty/en/man5/sources.list.5.html\`" ]\n}`", `"error_message`": `"`", `"artifact`": {`"urls`": [`"http://manpages.ubuntu.com/manpages/trusty/en/man5/sources.list.5.html`"], `"name`": `"APTSources`", `"doc`": `"APT package sources list`", `"labels`": [`"Configuration Files`", `"System`"], `"sources`": [{`"attributes`": {`"paths`": [`"/etc/apt/sources.list`", `"/etc/apt/sources.list.d/*.list`"]}, `"type`": `"FILE`", `"returned_types`": []}], `"supported_os`": [`"Linux`"], `"provides`": [], `"conditions`": []}, `"dependencies`": []}, {`"is_custom`": false, `"path_dependencies`": [], `"artifact_source`": `"{ \`"conditions\`": [],\n  \`"dependencies\`": [],\n  \`"doc\`": \`"APT trusted keys\`",\n  \`"labels\`": [ \`"Configuration Files\`", \`"System\`"\n  ],\n  \`"name\`": \`"APTTrustKeys\`",\n  \`"provides\`": [],\n  \`"sources\`": [\n    { \`"attributes\`": { \`"paths\`": [\n          \`"/etc/apt/trusted.gpg\`",\n          \`"/etc/apt/trusted.gpg.d/*.gpg\`",\n          \`"/etc/apt/trustdb.gpg\`",\n          \`"/usr/share/keyrings/*.gpg\`"\n        ]\n      },\n      \`"returned_types\`": [],\n      \`"type\`": \`"FILE\`"\n    }\n  ],\n  \`"supported_os\`": [ \`"Linux\`" ],\n  \`"urls\`": [ \`"https://wiki.debian.org/SecureApt\`" ]\n}`", `"error_message`": `"`", `"artifact`": {`"urls`": [`"https://wiki.debian.org/SecureApt`"], `"name`": `"APTTrustKeys`", `"doc`": `"APT trusted keys`", `"labels`": [`"Configuration Files`", `"System`"], `"sources`": [{`"attributes`": {`"paths`": [`"/etc/apt/trusted.gpg`", `"/etc/apt/trusted.gpg.d/*.gpg`", `"/etc/apt/trustdb.gpg`", `"/usr/share/keyrings/*.gpg`"]}, `"type`": `"FILE`", `"returned_types`": []}], `"supported_os`": [`"Linux`"], `"provides`": [], `"conditions`": []}, `"dependencies`": []}], `"total_count`": 422}
"@

$global:ValidExecutePythonHackFlowRequest = @"
)]}`'
{`"last_active_at`": 1111111111111111, `"name`": `"ExecutePythonHack`", `"creator`": `"user`", `"urn`": `"aff4:/C.1111111111111111/flows/F:AAAAAAAA`", `"args`": {`"hack_name`": `"hack`", `"py_args`": {`"argname`": `"args`"}}, `"state`": `"RUNNING`", `"flow_id`": `"F:AAAAAAAA`", `"started_at`": 1111111111111111, `"runner_args`": {`"flow_name`": `"ExecutePythonHack`", `"client_id`": `"aff4:/C.1111111111111111`"}}
"@

$global:HuntApprovalInvalidWithinItems = @"
)]}`'
{`"items`": [{`"notified_users`": [`"user.name`"], `"is_valid_message`": `"Requires 2 approvers for access.`", `"reason`": `"Hunt approval request`", `"email_cc_addresses`": [`"email@domain.tld`"], `"is_valid`": false, `"approvers`": [`"requester`"], `"id`": `"approval:AAAAAAAA`", `"subject`": {`"name`": `"GenericHunt`", `"created`": 1505384999744562, `"urn`": `"aff4:/hunts/H:AAAAAAAA`", `"expires`": 1506594599000000, `"total_net_usage`": 0, `"is_robot`": false, `"state`": `"PAUSED`", `"client_rate`": 20.5, `"creator`": `"requester`", `"client_limit`": 100, `"total_cpu_usage`": 0, `"description`": `"Process listing for clients`"}}]}
"@

$global:HuntApprovalInvalid = @"
)]}`'
{`"notified_users`": [`"user.name`"], `"is_valid_message`": `"Requires 2 approvers for access.`", `"reason`": `"Hunt approval request`", `"email_cc_addresses`": [`"email@domain.tld`"], `"is_valid`": false, `"approvers`": [`"requester`"], `"id`": `"approval:AAAAAAAA`", `"subject`": {`"name`": `"GenericHunt`", `"created`": 1505384999744562, `"urn`": `"aff4:/hunts/H:AAAAAAAA`", `"expires`": 1506594599000000, `"total_net_usage`": 0, `"is_robot`": false, `"state`": `"PAUSED`", `"client_rate`": 20.5, `"creator`": `"requester`", `"client_limit`": 100, `"total_cpu_usage`": 0, `"description`": `"Process listing for clients`"}}
"@

$global:HuntApprovalValidWithinItems = @"
)]}`'
{`"items`": [{`"notified_users`": [`"user.name`"], `"reason`": `"Hunt approval request`", `"email_cc_addresses`": [`"email@domain.tld`"], `"is_valid`": true, `"approvers`": [`"approver1, approver2`"], `"id`": `"approval:AAAAAAAA`", `"subject`": {`"name`": `"GenericHunt`", `"created`": 1505384999744562, `"urn`": `"aff4:/hunts/H:AAAAAAAA`", `"expires`": 1506594599000000, `"total_net_usage`": 0, `"is_robot`": false, `"state`": `"PAUSED`", `"client_rate`": 20.5, `"creator`": `"requester`", `"client_limit`": 100, `"total_cpu_usage`": 0, `"description`": `"Process listing for clients`"}}]}
"@

$global:HuntApprovalValid = @"
)]}`'
{`"notified_users`": [`"user.name`"], `"reason`": `"Hunt approval request`", `"email_cc_addresses`": [`"email@domain.tld`"], `"is_valid`": true, `"approvers`": [`"approver1, approver2`"], `"id`": `"approval:AAAAAAAA`", `"subject`": {`"name`": `"GenericHunt`", `"created`": 1505384999744562, `"urn`": `"aff4:/hunts/H:AAAAAAAA`", `"expires`": 1506594599000000, `"total_net_usage`": 0, `"is_robot`": false, `"state`": `"PAUSED`", `"client_rate`": 20.5, `"creator`": `"requester`", `"client_limit`": 100, `"total_cpu_usage`": 0, `"description`": `"Process listing for clients`"}}
"@

$global:ClientApprovalValid = @"
)]}`'
{`"notified_users`": [`"user.name`"], `"reason`": `"Client approval request`", `"email_cc_addresses`": [`"email@domain.tld`"], `"is_valid`": true, `"approvers`": [`"approver1, approver2`"], `"id`": `"approval:AAAAAAAA`", `"subject`": {`"name`": `"subject text`"}}
"@

$global:ClientApprovalInvalid = @"
)]}`'
{`"notified_users`": [`"user.name`"], `"reason`": `"Client approval request`", `"email_cc_addresses`": [`"email@domain.tld`"], `"is_valid`": false, `"approvers`": [`"approver1, approver2`"], `"id`": `"approval:AAAAAAAA`", `"subject`": {`"name`": `"subject text`"}}
"@

# Pester tests

Describe 'Get-GRRHuntResult' {
    Context 'when there are errors.' {
        It 'has no hunt id' {
            { Get-GRRHuntResult -Credential $PesterTestCredentials } | should Throw "Provide a hunt id with -HuntId"
        }

        It 'has no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR

            $ret = Get-GRRHuntResult -HuntId "H:aaaaaaaa" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }

        #It 'Read hunt results when with exception in web request' {
        #    Mock Invoke-GRRRequest {throw "pester test"} -ModuleName PowerGRR

        #    $ret = Get-GRRHuntResult -HuntId "H:CA0E68E9" -Credential $PesterTestCredentials
        #    $ret | should BeNullOrEmpty
        #    {$ret.total_count} | should throw
        #}
    }

    Context 'when there is a valid response' {
        It 'read valid empty hunt results' {

            Mock Invoke-GRRRequest {
                ($EmptyReturnObject).Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntResult -HuntId "H:aaaaaaaa" -Credential $PesterTestCredentials
            $ret | should not BeNullOrEmpty
            $ret.total_count | should be 0
        }

        It 'read valid hunt results' {

            Mock Invoke-GRRRequest {
                $ValidHuntResults.substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntResult -HuntId "H:aaaaaaaa" -Credential $PesterTestCredentials
            $ret | should not BeNullOrEmpty
            $ret.total_count | should be 1
        }
    }
}

Describe 'Get-GRRHuntInfo' {
    Context 'when there are errors.' {
        It 'has no hunt id' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            { Get-GRRHuntInfo -Credential $PesterTestCredentials } | should Throw "Provide a hunt id with -HuntId"
        }

        It 'has no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR

            $ret = Get-GRRHuntInfo -HuntId "H:11111111" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'when there is a valid response' {

        It 'read valid hunt info' {
            Mock Invoke-GRRRequest {
                $ValidHuntInfo.substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntInfo -HuntId "H:11111111" -Credential $PesterTestCredentials
            $ret | should not BeNullOrEmpty
            $ret.description | should be "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        }

        It 'read valid hunt info with option showjson' {
            Mock Invoke-GRRRequest {
                $ValidHuntInfo
            } -ModuleName PowerGRR

            Mock Get-GRRHuntResult {
                $ValidHuntResults.substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $json = Get-GRRHuntInfo -HuntId "H:11111111" -Credential $PesterTestCredentials -ShowJSON -ShowResultCount
            $json | should not BeNullOrEmpty
            $ret = $json | ConvertFrom-Json
            $ret.description | should be "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
            $ret.total_results | should be 1
        }
    }
}

Describe 'Get-GRRComputerNameFromClientId' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR

            $ret = Get-GRRComputerNameFromClientId -clientid "C.1111222233334444" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'when there is a valid response' {
        Mock Invoke-GRRRequest {
            $ValidSingleClientItem.substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'convert clientid to hostname' {
            $ret = Get-GRRComputerNameFromClientId -clientid "C.1111222233334444" -Credential $PesterTestCredentials
            $ret.computername | should be "AABBCCDD"
        }

        It 'Convert clientid with aff4 prefix to hostname' {
            $ret = Get-GRRComputerNameFromClientId -clientid "aff4:/C.1111222233334444" -Credential $PesterTestCredentials
            $ret.computername | should be "AABBCCDD"
        }
    }
}

Describe 'Get-GRRClientIdFromComputerName' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR

            $ret = Get-GRRClientIdFromComputerName -computername "hostname-aabbcc" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'when there is a valid response' {
        Mock Invoke-GRRRequest {
            $ValidClientItem.substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'Get clientid from computername' {
            $ret = Get-GRRClientIdFromComputerName -computername "hostname-aabbcc" -Credential $PesterTestCredentials
            $ret | select -expandproperty clientid | should be @("C.1234567890123456","C.1234567890123456")
            ($ret | measure).count | Should Be 2
        }

        It 'Get clientid from computername and show only last seen' {
            $ret = Get-GRRClientIdFromComputerName -computername "hostname-aabbcc" -Credential $PesterTestCredentials -OnlyLastSeen
            $ret | select -expandproperty clientid |  should be "C.1234567890123456"
            ($ret | measure).count | Should Be 1
        }
    }
}

Describe 'Find-GRRClient' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR

            $ret = Find-GRRClient -SearchString "hostname-aabbcc" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'when there is a valid response' {
        Mock Invoke-GRRRequest {
            $ValidClientItem.substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'find specific client and show only hostname' {
            $ret = Find-GRRClient -SearchString "hostname-aabbcc" -Credential $PesterTestCredentials -OnlyComputerName
            $ret | should be @("AABBCCDD","AABBCCDD")
            ($ret | measure).count | Should Be 2
        }

        It 'find specific client and show only last seen hostname' {
            $ret = Find-GRRClient -SearchString "hostname-aabbcc" -Credential $PesterTestCredentials -OnlyComputerName
            $ret | should be @("AABBCCDD","AABBCCDD")
            ($ret | measure).count | Should Be 2
        }

        It 'find specific client' {
            $ret = Find-GRRClient -SearchString "hostname-aabbcc" -Credential $PesterTestCredentials
            $ret.items | should not BeNullOrEmpty
            ($ret | measure).count | Should Be 1
            ($ret.items | measure).count | Should Be 2
        }
    }
}

Describe 'Find-GRRClientByLabel' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Find-GRRClientByLabel -SearchString "LabelX" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw

            { Find-GRRClientByLabel -Credential $PesterTestCredentials } | should throw
        }
    }

    Context 'when there is a valid response' {
        Mock Invoke-GRRRequest {
            $ValidClientItem.substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'use valid client search' {
            $ret = Find-GRRClientByLabel -SearchString "LabelX" -Credential $PesterTestCredentials -OnlyComputerName
            $ret | should be @("AABBCCDD","AABBCCDD")
        }
    }
}

Describe 'Set-GRRLabel' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR
            $ret = Set-GRRLabel -ComputerName XY -Label "LabelX" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }
    Context 'with valid but empty response' {
        It 'empty items' {
            Mock Invoke-GRRRequest {
                $EmptyItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR

            $ret = Set-GRRLabel -ComputerName XY -Label "LabelX" -Credential $PesterTestCredentials
            $ret | Should BeNullOrEmpty
        }
    }
}

Describe 'Remove-GRRLabel' {
    Context 'when there are errors.' {
        It 'No web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR
            $ret = Remove-GRRLabel -ComputerName XY -Label "LabelX" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }
    Context 'with valid but empty response' {
        It 'empty items' {
            Mock Invoke-GRRRequest {
                $EmptyItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR

            $ret = Remove-GRRLabel -ComputerName XY -Label "LabelX" -Credential $PesterTestCredentials
            $ret | Should BeNullOrEmpty
        }
    }
}

Describe 'Invoke-GRRFlow' {
    Context 'when there are errors.' {
        Mock Invoke-GRRRequest {} -ModuleName PowerGRR

        Mock Get-GRRSession {} -ModuleName PowerGRR

        It 'no web response in RegistryFinder' {
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "RegistryFinder" -Key "HKCM" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw

        }

        It 'no web response in FileFinder' {
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "FileFinder" -Path "C:\dummy" -Action Hash -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }

        It 'no web response in ExecutePythonHack' {
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "ExecutePythonHack" -HackName "powershell" -PyArgsName cmd -PyArgsValue "get-process" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }

        It 'no web response in ListProcesses' {
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "ListProcesses" -FileNameRegex ".*shell.*" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }

        It 'no web response in ArtifactCollectorFlow' {
            { Invoke-GRRFlow -ComputerName XY -Flow "ArtifactCollectorFlow" -Artifact "WindowsAutorun" -Credential $PesterTestCredentials } | should throw
        }

        It 'has invalid flow name' {
            { Invoke-GRRFlow -Flow "InvalidFlow" -Key "HKCM" -Credential $PesterTestCredentials } | Should Throw
        }
    }

    Context 'when there is a valid response' {
        Mock Get-GRRSession {
            $Headers = @{test="test"}
            $Websession = new-object -type Microsoft.PowerShell.Commands.WebRequestSession
            $Headers, $Websession
        } -ModuleName PowerGRR


        Mock Get-GRRClientIdFromComputerName {
            $json = '{"clientid":"C.1111111111111111"}'
            $json | ConvertFrom-Json
        } -ModuleName PowerGRR

        Mock Invoke-GRRRequest {
            $ValidStartFlowReturnObject.Substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'invoke a valid RegistryFinder flow' {
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "RegistryFinder" -Key "Key" -Credential $PesterTestCredentials
            $ret.flowid | Should Be F:22222222
        }

        Mock Invoke-GRRRequest {
            $ValidExecutePythonHackFlowRequest.Substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'invoke a valid ExecutePythonHack flow' {
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "ExecutePythonHack" -HackName "hack" -PyArgsName "argsname" -PyArgsValue "argsvalue" -Credential $PesterTestCredentials
            $ret.flowid | Should Be F:AAAAAAAA
        }

        Mock Invoke-GRRRequest {
            $ValidExecutePythonHackFlowRequest.Substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'invoke a valid FileFinder flow' {
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "FileFinder" -Path "C:\dummy" -Action Hash -Credential $PesterTestCredentials
            $ret.flowid | Should Be F:AAAAAAAA
        }

        It 'invoke a valid ListProcesses flow' {
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "ListProcesses" -FileNameRegex ".*shell.*" -Credential $PesterTestCredentials
            $ret.flowid | Should Be F:AAAAAAAA
        }

        It 'invoke a valid ArtifactCollector flow but without any artifacts available' {
            Mock Get-GRRArtifact {} -ModuleName PowerGRR
            { Invoke-GRRFlow -ComputerName XY -Flow "ArtifactCollectorFlow" -Artifact "WindowsAutorun" -Credential $PesterTestCredentials } | Should throw
        }

        It 'invoke a valid ArtifactCollector flow with the correct artifacts available' {
            Mock Get-GRRArtifact {
                $info = @{}
                $info.Name="WindowsAutorun"
                New-Object PSObject -Property $info
            } -ModuleName PowerGRR
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "ArtifactCollectorFlow" -Artifact "WindowsAutorun" -Credential $PesterTestCredentials
            $ret.flowid | Should Be F:AAAAAAAA
        }

        It 'invoke a valid ArtifactCollector flow but without the correct artifacts available' {
            Mock Get-GRRArtifact {
                $info = @{}
                $info.Name="WindowsAutostart"
                New-Object PSObject -Property $info
            } -ModuleName PowerGRR
            { Invoke-GRRFlow -ComputerName XY -Flow "ArtifactCollectorFlow" -Artifact "WindowsAutorun" -Credential $PesterTestCredentials } | should throw
        }
    }
}

Describe 'Get-GRRFlowResult' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRFlowResult -ComputerName XY -FlowId "F:111111" -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }
    Context 'with valid response' {
        It 'valid but empty items' {
            Mock Invoke-GRRRequest {
                $EmptyItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRFlowResult -ComputerName XY -FlowId "F:111111" -Credential $PesterTestCredentials
            $ret | Should BeNullOrEmpty
        }
    }
}

Describe 'Get-GRRLabel' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRLabel -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }
    Context 'with valid response' {
        It 'valid but empty items' {
            Mock Invoke-GRRRequest {
                $EmptyItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR

            $ret = Get-GRRLabel -Credential $PesterTestCredentials
            $ret | Should BeNullOrEmpty
        }

        It 'valid items' {
            Mock Invoke-GRRRequest {
                $ValidLabels.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR

            $ret = Get-GRRLabel -Credential $PesterTestCredentials
            $ret | Should Not BeNullOrEmpty
            $ret[0] | should be "label1"
        }
    }
}

Describe 'Get-GRRHunt' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRHunt -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }
    Context 'with valid response' {
        It 'valid but empty items' {
            Mock Invoke-GRRRequest {
                $EmptyItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR

            $ret = Get-GRRHunt -Credential $PesterTestCredentials
            $ret | Should BeNullOrEmpty
        }
    }
}

Describe 'Get-GRRSession' {
    Context 'when there are errors.' {
        It 'todo' {
            #todo
        }
    }
}

Describe 'Invoke-GRRRequest' {
    Context 'when RestMethod throws an exception.' {
        Mock Invoke-RestMethod {
            throw "pester test"
        } -ModuleName PowerGRR

        It 'GET request' {
            $ret = Invoke-GRRRequest -Url "/hunts/myurl" -Credential $PesterTestCredentials -ShowJSON
            $ret | should BeNullOrEmpty
            { $ret.substring(5) } | should throw
        }

        $Body = '{"flow":{"runner_args":{"flow_name":"ListProcesses","output_plugins":[]},"args":{}}}'
        $Headers = @{test="test"}
        $Websession = new-object -type Microsoft.PowerShell.Commands.WebRequestSession

        $params = @{
            'Url' = "/clients/C.1111111111111111/flows";
            'Credential' = $PesterTestCredentials;
            'Body' = $Body;
            'Headers' = $Headers;
            'Websession' = $Websession
        }

        It 'POST request' {
            $ret = Invoke-GRRRequest @params -ShowJSON
            $ret | should BeNullOrEmpty
            { $ret.substring(5) } | should throw
        }
    }

    Context 'GET requests with a valid response' {
        Mock Invoke-RestMethod {
            $EmptyReturnObject
        } -ModuleName PowerGRR

        It 'returning JSON' {
            $ret = Invoke-GRRRequest -Url "/hunts/myurl" -Credential $PesterTestCredentials -ShowJSON
            $ret | should not BeNullOrEmpty
            $ret | should be $EmptyReturnObject
        }

        It 'returning converted JSON object' {
            $ret = Invoke-GRRRequest -Url "hunts/myurl" -Credential $PesterTestCredentials
            $ret | should not BeNullOrEmpty
            $ret.total_count | should be 0
            $ret.items | should BeNullOrEmpty
        }
    }

    Context 'POST requests with a valid response' {
        $Body = '{"flow":{"runner_args":{"flow_name":"ListProcesses","output_plugins":[]},"args":{}}}'
        $Headers = @{test="test"}
        $Websession = new-object -type Microsoft.PowerShell.Commands.WebRequestSession

        $params = @{
            'Url' = "/clients/C.1111111111111111/flows";
            'Credential' = $PesterTestCredentials;
            'Body' = $Body;
            'Headers' = $Headers;
            'Websession' = $Websession
        }

        Mock Invoke-RestMethod {
            $ValidStartFlowReturnObject
        } -ModuleName PowerGRR

        It 'returning JSON object' {
            $ret = Invoke-GRRRequest @params -ShowJSON
            $ret | should not BeNullOrEmpty
            $ret | should match ".*RegistryFinder.*F:22222222"
        }

        It 'returning converted JSON object' {
            $ret = Invoke-GRRRequest @params
            $ret | should not BeNullOrEmpty
            ($ret.urn).Substring(31) | should be "F:22222222"
        }
    }
}

Describe 'Get-GRRFlowDescriptor' {
    Context 'when there are errors' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRFlowDescriptor -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'with valid response' {
        It 'valid but empty items' {
            Mock Invoke-GRRRequest {
                $EmptyItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR

            $ret = Get-GRRFlowDescriptor -Credential $PesterTestCredentials
            $ret | Should not BeNullOrEmpty
            $ret.items | Should BeNullOrEmpty
        }

        It 'valid items' {
            Mock Invoke-GRRRequest {
                $ValidFlowDescriptor.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR

            $ret = Get-GRRFlowDescriptor -Credential $PesterTestCredentials
            $ret | Should Not BeNullOrEmpty
            $ret | select -expandproperty category | Should Be "Processes"
            $ret | select -expandproperty name | Should Be "ListProcesses"
        }
    }
}

Describe 'Add-GRRArtifact' {
    Context 'when there are errors' {
        Mock Invoke-GRRRequest {} -ModuleName PowerGRR
        Mock Get-GRRSession {} -ModuleName PowerGRR

        $path = "TestDrive:\test.txt"
        Set-Content $path -value "artifact"

        It 'no web response' {
            $ret = Add-GRRArtifact -Credential $PesterTestCredentials -ArtifactFile $path
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }

        It 'file not found' {
             { Add-GRRArtifact -Credential $PesterTestCredentials -ArtifactFile C:\non-existing-path\test.yaml } | should throw "Artifact file not found."
        }
    }

    Context 'with valid response' {
        Mock Get-GRRSession {
            $Headers = @{test="test"}
            $Websession = new-object -type Microsoft.PowerShell.Commands.WebRequestSession
            $Headers, $Websession
        } -ModuleName PowerGRR

        Mock Invoke-GRRRequest {
            $StatusOK.Substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'upload ok' {
            $ret = Add-GRRArtifact -Credential $PesterTestCredentials -ArtifactFile $path
            $ret | should not BeNullOrEmpty
            $ret.status | should be "OK"
        }
    }
}

Describe 'Get-ValidatedGRRArtifact' {
    InModuleScope PowerGRR {
        Context 'when there are errors' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR
            It 'no web response' {
                { Get-ValidatedGRRArtifact -Credential $PesterTestCredentials -Artifacts TestArtifact } | should throw "No artifacts found in GRR"
            }
        }

        Context 'with valid response' {
            Mock Get-GRRSession {
                $Headers = @{test="test"}
                $Websession = new-object -type Microsoft.PowerShell.Commands.WebRequestSession
                $Headers, $Websession
            } -ModuleName PowerGRR

            Mock Get-GRRArtifact {
                $properties = @{'Name'="TestArtifact";
                                'Description'="Test"}
                New-Object -TypeName PSObject -Prop $properties
            } -ModuleName PowerGRR

            It 'when one artifact found' {
                $ret = Get-ValidatedGRRArtifact -Credential $PesterTestCredentials -Artifact TestArtifact
                $ret | should be "TestArtifact"
            }

            Mock Get-GRRArtifact {
                $ret = @()
                $info = @{
                    Name="TestArtifact"
                    Description="Test"
                }
                $ret += New-Object PSObject -Prop $info
                $ret += New-Object PSObject -Prop $info
                $ret
            } -ModuleName PowerGRR

            It 'when multiple artifact with same name found' {
                $ret = Get-ValidatedGRRArtifact -Credential $PesterTestCredentials -Artifact TestArtifact
                $ret | should be "TestArtifact"
            }

            Mock Get-GRRArtifact {
                $object = @()
                $properties = @{'Name'="TestArtifact";
                                'Description'="Test"}
                $object += New-Object -TypeName PSObject -Prop $properties
                $properties = @{'Name'="TestArtifact2";
                                'Description'="Test"}
                $object += New-Object -TypeName PSObject -Prop $properties
                $object
            } -ModuleName PowerGRR

            It 'when multiple artifact with different names found and searching for one' {
                $ret = Get-ValidatedGRRArtifact -Credential $PesterTestCredentials -Artifact TestArtifact
                $ret | should be "TestArtifact"
            }

            It 'when multiple artifact with different names found and searching for two' {
                $ret = Get-ValidatedGRRArtifact -Credential $PesterTestCredentials -Artifact TestArtifact, TestArtifact2
                $ret | should be @("TestArtifact","TestArtifact2")
            }
        }
    }
}

Describe 'Remove-GRRArtifact' {
    Context 'when there are errors' {
        Mock Invoke-GRRRequest {} -ModuleName PowerGRR
        Mock Get-GRRSession {} -ModuleName PowerGRR

        It 'no web response' {
            $ret = Remove-GRRArtifact -Credential $PesterTestCredentials -Artifact TestArtifact
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'with valid response' {
        Mock Get-GRRSession {
            $Headers = @{test="test"}
            $Websession = new-object -type Microsoft.PowerShell.Commands.WebRequestSession
            $Headers, $Websession
        } -ModuleName PowerGRR

        Mock Get-ValidatedGRRArtifact {
            "TestArtifact"
        } -ModuleName PowerGRR

        Mock Invoke-GRRRequest {
            $StatusOK.Substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'artifact removal ok' {
            $ret = Remove-GRRArtifact -Credential $PesterTestCredentials -Artifact TestArtifact
            $ret | should not BeNullOrEmpty
            $ret.status | should be "OK"
        }
    }
}

Describe 'Get-GRRArtifact' {
    Context 'when there are errors' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRArtifact -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'with valid response' {
        It 'when empty items' {
            Mock Invoke-GRRRequest {
                $EmptyItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRArtifact -Credential $PesterTestCredentials
            $ret | Should BeNullOrEmpty
            { $ret.items } | Should Throw
        }

        It 'when no items' {
            Mock Invoke-GRRRequest {
                $NoItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRArtifact -Credential $PesterTestCredentials
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
        }

        It 'when valid items' {
            Mock Invoke-GRRRequest {
                $ValidArtifacts.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRArtifact -Credential $PesterTestCredentials
            $ret | Should Not BeNullOrEmpty
            $ret | measure | select -expandproperty count | should be 2
            $ret | select -expandproperty name -first 1 | should be "APTSources"
            $ret | select -expandproperty name -skip 1 | should be "APTTrustKeys"
        }
    }
}

Describe 'Get-GRRHuntApproval' {
    Context 'when there are errors' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRHuntApproval -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }
    Context 'with valid response' {
        It 'when empty items' {
            Mock Invoke-GRRRequest {
                $EmptyItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntApproval -Credential $PesterTestCredentials
            $ret | Should BeNullOrEmpty
            { $ret.items } | Should Throw
        }

        It 'when no items' {
            Mock Invoke-GRRRequest {
                $NoItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntApproval -Credential $PesterTestCredentials
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
        }

        It 'when valid hunt approval is given' {
            Mock Invoke-GRRRequest {
                $HuntApprovalValid.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntApproval -Credential $PesterTestCredentials
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $ret.id | Should Be "approval:AAAAAAAA"
            $ret.is_valid | Should be "True"
        }

        It 'when invalid hunt approval is given' {
            Mock Invoke-GRRRequest {
                $HuntApprovalInvalid.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntApproval -Credential $PesterTestCredentials
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $ret.id | Should Be "approval:AAAAAAAA"
            $ret.is_valid | Should be "False"
        }

        It 'when valid hunt approval is given and flag -OnlyState is used.' {
            Mock Invoke-GRRRequest {
                $HuntApprovalValid.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntApproval -Credential $PesterTestCredentials -HuntId H:AAAAAAAA -OnlyState -ApprovalId approval:BBBBBBBB
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should throw
            $ret | Should Be "True"
        }

        It 'when invalid hunt approval is given and flag -OnlyState is used.' {
            Mock Invoke-GRRRequest {
                $HuntApprovalInvalid.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntApproval -Credential $PesterTestCredentials -HuntId H:AAAAAAAA -OnlyState -ApprovalId approval:BBBBBBBB
            $ret | Should not BeNullOrEmpty
            $ret | Should Be "False"
        }
    }
}

Describe 'Get-GRRClientApproval' {
    Context 'when there are errors' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRClientApproval -Credential $PesterTestCredentials
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }
    Context 'with valid response' {
        It 'when empty items' {
            Mock Invoke-GRRRequest {
                $EmptyItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRClientApproval -Credential $PesterTestCredentials
            $ret | Should BeNullOrEmpty
            { $ret.items } | Should Throw
        }

        It 'when no items' {
            Mock Invoke-GRRRequest {
                $NoItem.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRClientApproval -Credential $PesterTestCredentials
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
        }

        It 'when valid client approval is given' {
            Mock Invoke-GRRRequest {
                $ClientApprovalValid.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRClientApproval -Credential $PesterTestCredentials
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $ret.id | Should Be "approval:AAAAAAAA"
            $ret.is_valid | Should be "True"
        }

        It 'when invalid client approval is given' {
            Mock Invoke-GRRRequest {
                $ClientApprovalInvalid.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRClientApproval -Credential $PesterTestCredentials
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $ret.id | Should Be "approval:AAAAAAAA"
            $ret.is_valid | Should be "False"
        }
    }
}

Describe 'Wait-GRRHuntApproval' {
    Context 'with valid response' {
        It 'when GRR API requests returns nothing and using a 1 minute timeout' {
            Mock Get-GRRHuntApproval {} -ModuleName PowerGRR

            $start = get-date
            $ret = Wait-GRRHuntApproval -Credential $PesterTestCredentials -HuntId "A:00000" -ApprovalId "approval:AAAAAAAA" -TimeoutInMinutes 1
            $end = get-date
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $diff = New-TimeSpan -Start $start -End $end
            $diff.Minutes | Should Be 1
        }

        It 'when GRR API requests returns nothing and using a 5 minute timeout' {
            Mock Get-GRRHuntApproval {} -ModuleName PowerGRR

            $start = get-date
            $ret = Wait-GRRHuntApproval -Credential $PesterTestCredentials -HuntId "A:00000" -ApprovalId "approval:AAAAAAAA" -TimeoutInMinutes 5
            $end = get-date
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $diff = New-TimeSpan -Start $start -End $end
            $diff.Minutes | Should Be 5
        }

        It 'when GRR API requests returns true and using a 2 minute timeout' {
            Mock Get-GRRHuntApproval {$true} -ModuleName PowerGRR

            $start = get-date
            $ret = Wait-GRRHuntApproval -Credential $PesterTestCredentials -HuntId "A:00000" -ApprovalId "approval:AAAAAAAA" -TimeoutInMinutes 2
            $end = get-date
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $ret | should be $true
            $diff = New-TimeSpan -Start $start -End $end
        }
    }
}

Describe 'Wait-GRRClientApproval' {
    Context 'with valid response' {
        It 'when GRR API requests returns nothing and using a 1 minute timeout' {
            Mock Get-GRRClientApproval {} -ModuleName PowerGRR

            $start = get-date
            $ret = Wait-GRRClientApproval -Credential $PesterTestCredentials -ComputerName "host1" -ApprovalId "approval:AAAAAAAA" -TimeoutInMinutes 1
            $end = get-date
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $diff = New-TimeSpan -Start $start -End $end
            $diff.Minutes | Should Be 1
        }

        It 'when GRR API requests returns nothing and using a 5 minute timeout' {
            Mock Get-GRRClientApproval {} -ModuleName PowerGRR

            $start = get-date
            $ret = Wait-GRRClientApproval -Credential $PesterTestCredentials -ComputerName "host1" -ApprovalId "approval:AAAAAAAA" -TimeoutInMinutes 5
            $end = get-date
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $diff = New-TimeSpan -Start $start -End $end
            $diff.Minutes | Should Be 5
        }

        It 'when GRR API requests returns true and using a 2 minute timeout' {
            Mock Get-GRRClientApproval {$true} -ModuleName PowerGRR

            $start = get-date
            $ret = Wait-GRRClientApproval -Credential $PesterTestCredentials -ComputerName "host1" -ApprovalId "approval:AAAAAAAA" -TimeoutInMinutes 2
            $end = get-date
            $ret | Should not BeNullOrEmpty
            { $ret.items } | Should Throw
            $ret | should be $true
            $diff = New-TimeSpan -Start $start -End $end
        }
    }
}

Describe "internal functions" {
    InModuleScope PowerGRR {
        Context 'Testing Get-ClientCertificate' {
            It 'no client cert' {
                $GRRClientCertIssuer = "not existing"
                Mock Get-ChildItem {} -ModuleName PowerGRR
                Mock Get-PfxCertificate {} -ModuleName PowerGRR
                { Get-ClientCertificate } | should throw
            }
        }

        Context 'Testing Get-EpocTimeFromUtc' {
            It 'convert unix timestamp to utc' {
                $ret = Get-EpocTimeFromUtc 1496907016
                $ret | should be "06/08/2017 07:30:16"
            }
        }

        Context 'Testing ConvertFrom-Base64' {
            It 'convert base64 encoded string' {
                $ret = "UGVzdGVyVGVzdA==" | ConvertFrom-Base64
                $ret | should be "PesterTest"
            }
        }
    }
}

# Cleanup after all tests

Remove-Variable -Scope global -name NoItem
Remove-Variable -Scope global -name EmptyItem
Remove-Variable -Scope global -name StatusOK
Remove-Variable -Scope global -name EmptyReturnObject
Remove-Variable -Scope global -name ValidLabels
Remove-Variable -Scope global -name ValidClientItem
Remove-Variable -Scope global -name ValidSingleClientItem
Remove-Variable -Scope global -name ValidHuntInfo
Remove-Variable -Scope global -name ValidHuntResults
Remove-Variable -Scope global -name ValidStartFlowReturnObject
Remove-Variable -Scope global -name ValidFlowDescriptor
Remove-Variable -Scope global -name ValidArtifacts
Remove-Variable -Scope global -name ValidExecutePythonHackFlowRequest
Remove-Variable -Scope global -name HuntApprovalInvalid
Remove-Variable -Scope global -name HuntApprovalValid
Remove-Variable -Scope global -name ClientApprovalInvalid
Remove-Variable -Scope global -name ClientApprovalValid
Remove-Variable -Scope global -name PesterTestCredentials
