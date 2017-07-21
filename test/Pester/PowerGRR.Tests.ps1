Set-StrictMode -Version latest

$BasePath = "$PSScriptRoot\..\..\"

Import-Module -Force $BasePath\PowerGRR.psm1

# Setup before all tests

$password = "bad"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList "user", $secureStringPwd


$global:EmptyItem = @"
)]}`'
{`"items`": []}
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

# Pester tests

Describe 'Get-GRRHuntResult' {
    Context 'when there are errors.' {
        It 'has no hunt id' {
            { Get-GRRHuntResult -Credential $creds } | should Throw "Provide a hunt id with -HuntId"
        }

        It 'has no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR

            $ret = Get-GRRHuntResult -HuntId "H:aaaaaaaa" -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }

        #It 'Read hunt results when with exception in web request' {
        #    Mock Invoke-GRRRequest {throw "pester test"} -ModuleName PowerGRR

        #    $ret = Get-GRRHuntResult -HuntId "H:CA0E68E9" -Credential $creds
        #    $ret | should BeNullOrEmpty
        #    {$ret.total_count} | should throw
        #}
    }

    Context 'when there is a valid response' {
        It 'read valid empty hunt results' {

            Mock Invoke-GRRRequest {
                ($EmptyReturnObject).Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntResult -HuntId "H:aaaaaaaa" -Credential $creds
            $ret | should not BeNullOrEmpty
            $ret.total_count | should be 0
        }

        It 'read valid hunt results' {

            Mock Invoke-GRRRequest {
                $ValidHuntResults.substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntResult -HuntId "H:aaaaaaaa" -Credential $creds
            $ret | should not BeNullOrEmpty
            $ret.total_count | should be 1
        }
    }
}

Describe 'Get-GRRHuntInfo' {
    Context 'when there are errors.' {
        It 'has no hunt id' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            { Get-GRRHuntInfo -Credential $creds } | should Throw "Provide a hunt id with -HuntId"
        }

        It 'has no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR

            $ret = Get-GRRHuntInfo -HuntId "H:11111111" -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'when there is a valid response' {

        It 'read valid hunt info' {
            Mock Invoke-GRRRequest {
                $ValidHuntInfo.substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $ret = Get-GRRHuntInfo -HuntId "H:11111111" -Credential $creds
            $ret | should not BeNullOrEmpty
            $ret.description | should be "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        }

        It 'read valid hunt info with option showjson-option' {
            Mock Invoke-GRRRequest {
                $ValidHuntInfo
            } -ModuleName PowerGRR

            Mock Get-GRRHuntResult {
                $ValidHuntResults.substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR

            $json = Get-GRRHuntInfo -HuntId "H:11111111" -Credential $creds -ShowJSON
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

            $ret = Get-GRRComputerNameFromClientId -clientid "C.1111222233334444" -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'when there is a valid response' {
        Mock Invoke-GRRRequest {
            $ValidClientItem.substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'convert clientid to hostname' {
            $ret = Get-GRRComputerNameFromClientId -clientid "C.1111222233334444" -Credential $creds
            $ret | should be "AABBCCDD"
        }

        It 'Convert clientid with aff4 prefix to hostname' {
            $ret = Get-GRRComputerNameFromClientId -clientid "aff4:/C.1111222233334444" -Credential $creds
            $ret | should be "AABBCCDD"
        }
    }
}

Describe 'Get-GRRClientIdFromComputerName' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR

            $ret = Get-GRRClientIdFromComputerName -computername "hostname-aabbcc" -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'when there is a valid response' {
        Mock Invoke-GRRRequest {
            $ValidClientItem.substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'Get clientid from computername' {
            $ret = Get-GRRClientIdFromComputerName -computername "hostname-aabbcc" -Credential $creds
            $ret | select -expandproperty clientid | should be "C.1234567890123456"
            ($ret | measure).count | Should Be 2
        }

        It 'Get clientid from computername and show only last seen' {
            $ret = Get-GRRClientIdFromComputerName -computername "hostname-aabbcc" -Credential $creds -OnlyLastSeen
            $ret | select -expandproperty clientid |  should be "C.1234567890123456"
            ($ret | measure).count | Should Be 1
        }
    }
}

Describe 'Find-GRRClient' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR

            $ret = Find-GRRClient -SearchString "hostname-aabbcc" -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }
    }

    Context 'when there is a valid response' {
        Mock Invoke-GRRRequest {
            $ValidClientItem.substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'find specific client and show only hostname' {
            $ret = Find-GRRClient -SearchString "hostname-aabbcc" -Credential $creds -OnlyComputerName
            $ret | should be "AABBCCDD"
            ($ret | measure).count | Should Be 2
        }

        It 'find specific client' {
            $ret = Find-GRRClient -SearchString "hostname-aabbcc" -Credential $creds
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
            $ret = Find-GRRClientByLabel -SearchString "LabelX" -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw

            { Find-GRRClientByLabel -Credential $creds } | should throw
        }
    }

    Context 'when there is a valid response' {
        Mock Invoke-GRRRequest {
            $ValidClientItem.substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'use valid client search' {
            $ret = Find-GRRClientByLabel -SearchString "LabelX" -Credential $creds -OnlyComputerName
            $ret | should be "AABBCCDD"
        }
    }
}

Describe 'Set-GRRLabel' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR
            $ret = Set-GRRLabel -ComputerName XY -Label "LabelX" -Credential $creds
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

            $ret = Set-GRRLabel -ComputerName XY -Label "LabelX" -Credential $creds
            $ret | Should BeNullOrEmpty
        }
    }
}

Describe 'Remove-GRRLabel' {
    Context 'when there are errors.' {
        It 'No web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR
            $ret = Remove-GRRLabel -ComputerName XY -Label "LabelX" -Credential $creds
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

            $ret = Remove-GRRLabel -ComputerName XY -Label "LabelX" -Credential $creds
            $ret | Should BeNullOrEmpty
        }
    }
}

Describe 'Invoke-GRRFlow' {
    Context 'when there are errors.' {
        Mock Invoke-GRRRequest {} -ModuleName PowerGRR

        It 'no web response' {
            Mock Get-GRRSession {} -ModuleName PowerGRR

            $ret = Invoke-GRRFlow -ComputerName XY -Flow "RegistryFinder" -Key "HKCM" -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw

            $ret = Invoke-GRRFlow -ComputerName XY -Flow "FileFinder" -Path "C:\dummy" -Action Hash -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw

            $ret = Invoke-GRRFlow -ComputerName XY -Flow "ExecutePythonHack" -HackName "powershell" -PyArgsName cmd -PyArgsValue "get-process" -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw

            $ret = Invoke-GRRFlow -ComputerName XY -Flow "ListProcesses" -FileNameRegex ".*shell.*" -Credential $creds
            $ret | should BeNullOrEmpty
            {$ret.total_count} | should throw
        }

        It 'has invalid flow name' {
            { Invoke-GRRFlow -Flow "InvalidFlow" -Key "HKCM" -Credential $creds } | Should Throw
        }
    }

    Context 'when there is a valid response' {
        Mock Get-GRRSession {
            $Headers = @{test="test"}
            $Websession = new-object -type Microsoft.PowerShell.Commands.WebRequestSession
            $Headers, $Websession
        } -ModuleName PowerGRR

        Mock Invoke-GRRRequest {
            $ValidStartFlowReturnObject.Substring(5) | ConvertFrom-Json
        } -ModuleName PowerGRR

        Mock Get-GRRClientIdFromComputerName {
            $json = '{"clientid":"C.1111111111111111"}'
            $json | ConvertFrom-Json
        } -ModuleName PowerGRR

        It 'invoke a valid flow' {
            $ret = Invoke-GRRFlow -ComputerName XY -Flow "ExecutePythonHack" -HackName "powershell" -PyArgsName cmd -PyArgsValue "get-process" -Credential $creds
            $ret.flowid | Should Be F:22222222
        }
    }
}

Describe 'Get-GRRFlowResult' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRFlowResult -ComputerName XY -FlowId "F:111111" -Credential $creds
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

            $ret = Get-GRRFlowResult -ComputerName XY -FlowId "F:111111" -Credential $creds
            $ret | Should BeNullOrEmpty
        }
    }
}

Describe 'Get-GRRLabel' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRLabel -Credential $creds
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

            $ret = Get-GRRLabel -Credential $creds
            $ret | Should BeNullOrEmpty
        }

        It 'valid items' {
            Mock Invoke-GRRRequest {
                $ValidLabels.Substring(5) | ConvertFrom-Json
            } -ModuleName PowerGRR
            Mock Get-GRRSession {} -ModuleName PowerGRR

            $ret = Get-GRRLabel -Credential $creds
            $ret | Should Not BeNullOrEmpty
            $ret[0] | should be "label1"
        }
    }
}

Describe 'Get-GRRHunt' {
    Context 'when there are errors.' {
        It 'no web response' {
            Mock Invoke-GRRRequest {} -ModuleName PowerGRR
            $ret = Get-GRRHunt -Credential $creds
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

            $ret = Get-GRRHunt -Credential $creds
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
            $ret = Invoke-GRRRequest -Url "/hunts/myurl" -Credential $creds -ShowJSON
            $ret | should BeNullOrEmpty
            { $ret.substring(5) } | should throw
        }

        $Body = '{"flow":{"runner_args":{"flow_name":"ListProcesses","output_plugins":[]},"args":{}}}'
        $Headers = @{test="test"}
        $Websession = new-object -type Microsoft.PowerShell.Commands.WebRequestSession

        $params = @{
            'Url' = "/clients/C.1111111111111111/flows";
            'Credential' = $creds;
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
            $ret = Invoke-GRRRequest -Url "/hunts/myurl" -Credential $creds -ShowJSON
            $ret | should not BeNullOrEmpty
            $ret | should be $EmptyReturnObject
        }

        It 'returning converted JSON object' {
            $ret = Invoke-GRRRequest -Url "hunts/myurl" -Credential $creds
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
            'Credential' = $creds;
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

Describe "internal functions" {
    InModuleScope PowerGRR {
        Context 'Testing Get-ClientCertificate' {
            It 'no client cert' {
                Mock Get-ChildItem {} -ModuleName PowerGRR
                $ret = Get-ClientCertificate
                $ret | should BeNullOrEmpty
                {$ret.total_count} | should throw
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

Remove-Variable -Scope global -name EmptyItem
Remove-Variable -Scope global -name EmptyReturnObject
Remove-Variable -Scope global -name ValidClientItem
Remove-Variable -Scope global -name ValidHuntResults
Remove-Variable -Scope global -name ValidHuntInfo
Remove-Variable -Scope global -name ValidStartFlowReturnObject
