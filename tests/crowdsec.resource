*** Settings ***
Library    SSHLibrary
Library    BuiltIn

*** Variables ***
${ADMIN_USER}    admin
${ADMIN_PASSWORD}    Nethesis,1234
${SYSLOG_PREFIX}    Oct 16 10:00:00 node
${SCENARIO}    install
# get-configuration turns an empty list into [""], read both as empty
${CONFIG_NORM}    .whitelists |= map(select(. != "")) | .receiver_emails |= map(select(. != ""))

*** Keywords ***
CrowdSec Is Ready
    ${rc}=    Execute Command    systemctl is-active ${module_id}.service    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${rc}=    Execute Command    runagent -m ${module_id} cscli lapi status    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0

Run Module Action
    # always feed stdin: several actions do `input=$(cat)` and fail on empty input
    [Arguments]    ${action}    ${json}={}
    ${output}    ${rc}=    Execute Command    echo '${json}' | api-cli run ${action} --agent module/${module_id} --data -    return_rc=True
    RETURN    ${output}    ${rc}

Configure Module With
    # apply a jq filter to the current configuration, send it back, then read it again
    [Arguments]    ${filter}
    ${expected}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | jq -c '${filter}'
    ${rc}=    Execute Command    echo '${expected}' | api-cli run configure-module --agent module/${module_id} --data -    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${want}=    Execute Command    echo '${expected}' | jq -S -c '${CONFIG_NORM}'
    ${got}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | jq -S -c '${CONFIG_NORM}'
    Should Be Equal    ${got}    ${want}    get-configuration does not return what configure-module received

Restore Saved Configuration
    # an accepted bad value would leave crowdsec misconfigured for the next suites
    Execute Command    api-cli run get-configuration --agent module/${module_id} | cmp -s - /tmp/crowdsec-config.json || api-cli run configure-module --agent module/${module_id} --data - < /tmp/crowdsec-config.json
    Execute Command    rm -f /tmp/crowdsec-config.json

Read Config File
    [Arguments]    ${path}
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cat crowdsec_config/${path}    return_rc=True
    RETURN    ${output}    ${rc}

Explain Log Line
    # verbose output lists the parsed fields, so the tests can check which IP would be banned
    [Arguments]    ${line}
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli explain -v --type syslog --log '${line}'    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    RETURN    ${output}

Hub Collection Status
    # cscli inspect only reports whether the item is installed
    [Arguments]    ${name}
    ${status}=    Execute Command    runagent -m ${module_id} cscli collections inspect ${name} -o json | jq -r 'if .installed then "enabled" else "disabled" end'
    RETURN    ${status}

Remove Hub Collection
    [Arguments]    ${name}
    Wait Until Keyword Succeeds    24x    5s    CrowdSec Is Ready
    ${status}=    Hub Collection Status    ${name}
    Return From Keyword If    '${status}' != 'enabled'
    Sleep    15s
    Run Module Action    toggle-collection    {"name": "${name}", "action": "remove"}

Collection Status
    [Arguments]    ${name}
    ${status}=    Execute Command    api-cli run list-collections --agent module/${module_id} | jq -r '.[] | select(.name=="${name}").status'
    RETURN    ${status}

Decision Count
    [Arguments]    ${ip}
    ${count}=    Execute Command    runagent -m ${module_id} cscli decisions list -i ${ip} -o json | jq '[.[]?.decisions[]?] | length'
    RETURN    ${count}

Ban Has Scenario
    [Arguments]    ${ip}    ${scenario}
    ${output}=    Execute Command    runagent -m ${module_id} cscli decisions list -i ${ip} -o json | jq -r '[.[]?.decisions[]?.scenario] | join(",")'
    Should Contain    ${output}    ${scenario}

Send Kamailio Auth Failures
    # kamailio-bf overflows past 20 events leaking at 1/s
    [Arguments]    ${ip}
    ${rc}=    Execute Command    for i in $(seq 1 40); do logger -t kamailio "[SECURITY-AUTHFAIL] c$i REGISTER-$i - event=auth_failure method=REGISTER status=401 src_ip=${ip} user=200 callid=c$i"; done    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0

Send SSH Auth Failures
    [Arguments]    ${ip}
    ${rc}=    Execute Command    for i in $(seq 1 10); do logger -t sshd -i "Failed password for invalid user admin$i from ${ip} port 5000$i ssh2"; done    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0

Brute Force Is Banned
    # call it under a retry: lines logged while crowdsec restarts are never read (journalctl -n 0), so each try sends again
    [Arguments]    ${sender}    ${ip}    ${scenario}
    Run Keyword    ${sender}    ${ip}
    Wait Until Keyword Succeeds    6x    2s    Ban Has Scenario    ${ip}    ${scenario}

Controls Are Banned After A Batch
    # the allowed IPs go first in the same batch, so a banned control proves their lines were read too
    [Arguments]    ${allowed}    ${controls}
    FOR    ${ip}    IN    @{allowed}    @{controls}
        Send SSH Auth Failures    ${ip}
    END
    FOR    ${ip}    IN    @{controls}
        Wait Until Keyword Succeeds    6x    2s    Ban Has Scenario    ${ip}    crowdsecurity/ssh-
    END

Reset Allowlist Test
    [Arguments]    @{controls}
    FOR    ${ip}    IN    @{controls}
        Execute Command    runagent -m ${module_id} cscli decisions delete -i ${ip}
    END
    Configure Module With    .whitelists=[]

Enable NethVoice Collection
    # a toggle sent while the previous reload still runs crashes crowdsec, so wait on both sides
    Wait Until Keyword Succeeds    24x    5s    CrowdSec Is Ready
    ${status}=    Collection Status    nethesis/nethvoice
    Return From Keyword If    '${status}' == 'enabled'
    Sleep    15s
    Run Module Action    toggle-collection    {"name": "nethesis/nethvoice", "action": "install"}
    Wait Until Keyword Succeeds    24x    5s    CrowdSec Is Ready

Reset Update Seed
    Return From Keyword If    '${SCENARIO}' != 'update'
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 192.0.2.200
    Configure Module With    .whitelists=[] | .dyn_bantime=true | .bantime="1"

Reset Local Network Test
    FOR    ${ip}    IN    192.168.250.10    198.51.100.150
        Execute Command    runagent -m ${module_id} cscli decisions delete -i ${ip}
    END
    ${value}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | jq -r .ban_local_network
    Run Keyword If    '${value}' != 'false'    Configure Module With    .ban_local_network=false

Remove FQDN Test Host
    Execute Command    sed -i '/fqdn-test.example.org/d' /etc/hosts
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 198.51.100.141
    Configure Module With    .whitelists=[]

Metrics Endpoint Answers
    [Arguments]    ${target}
    ${output}    ${rc}=    Execute Command    curl -sf http://${target}/metrics | grep -c '^cs_info'    return_rc=True
    Should Be Equal As Integers    ${rc}    0

Add Long Decision
    [Arguments]    ${ip}
    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions add -i ${ip} -d 4h    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0

Allowlist Contains
    [Arguments]    ${ip}
    ${output}=    Execute Command    runagent -m ${module_id} cscli allowlists inspect nethserver_whitelist
    Should Contain    ${output}    ${ip}

Login to cluster-admin
    New Page    https://${NODE_ADDR}/cluster-admin/
    Fill Text    text="Username"    ${ADMIN_USER}
    Click    button >> text="Continue"
    Fill Text    text="Password"    ${ADMIN_PASSWORD}
    Click    button >> text="Log in"
    Wait For Elements State    css=#main-content    visible    timeout=10s

IP Not In Ruleset
    [Arguments]    ${ip}
    ${rc}=    Execute Command    nft list ruleset | grep -wF ${ip}    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    1

Check IP In Ruleset
    # fixed-string whole-word match: the CAPI blocklist fills nft with addresses that a loose regex would match
    [Arguments]    ${ip}
    ${output}    ${rc}=    Execute Command    nft list ruleset | grep -wF ${ip}    return_rc=True
    Should Be Equal As Integers    ${rc}    0
