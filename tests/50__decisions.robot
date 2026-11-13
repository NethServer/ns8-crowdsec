*** Settings ***
Resource    crowdsec.resource

*** Test Cases ***
Check if crowdsec can ban 10.10.10.10
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions add -i 10.10.10.10    return_rc=True
    Should Be Equal As Integers    ${rc}    0

Check if crowdsec can list decisions
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions list    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    Should Contain    ${output}    Ip:10.10.10.10

Check if 10.10.10.10 is listed in ruleset (20 attempts with 5 sec)
    Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    10.10.10.10

Check if crowdsec can unban 10.10.10.10
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions delete -i 10.10.10.10    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    Wait Until Keyword Succeeds    20x    5s    IP Not In Ruleset    10.10.10.10

List alerts and inspect the manual alert
    # the manual ban above created an alert; deleting its decision leaves the
    # alert, so list-detections still returns it here (run after the ruleset check
    # because flushing alerts cascades to their decisions)
    # manual alerts have single quotes in their scenario, so pipe api-cli straight into jq
    ${id}    ${rc}=    Execute Command    echo '{}' | api-cli run list-detections --agent module/${module_id} --data - | jq -er '[.[] | select(.source.value=="10.10.10.10")][0].id'    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    ${ip}    ${rc}=    Execute Command    echo '{"id": ${id}}' | api-cli run inspect-detection --agent module/${module_id} --data - | jq -er '.source.value'    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    Should Be Equal    ${ip}    10.10.10.10

Flush alerts
    ${out}    ${rc}=    Run Module Action    delete-detections
    Should Be Equal As Integers    ${rc}    0
    ${count}=    Execute Command    echo '{}' | api-cli run list-detections --agent module/${module_id} --data - | jq 'length'
    Should Be Equal As Integers    ${count}    0

Unban an IP through the module action
    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions add -i 1.2.3.4    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    # confirm the ban reached nft before unbanning
    Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    1.2.3.4
    ${out}    ${rc}=    Run Module Action    unban-ip    {"action": "unban", "ip": "1.2.3.4"}
    Should Be Equal As Integers    ${rc}    0
    ${output}=    Execute Command    runagent -m ${module_id} cscli decisions list
    Should Not Contain    ${output}    Ip:1.2.3.4
    Wait Until Keyword Succeeds    20x    5s    IP Not In Ruleset    1.2.3.4

The banned IP list shows permanent bans only
    # same import call as import-threat-shield: the scenario is the only marker
    ${rc}=    Execute Command    echo 192.0.2.77 | runagent -m ${module_id} cscli decisions import -i - --format values -d 10m -R threat-shield/nethesislvl3    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions add -i 192.0.2.78 -d 10m    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    # manual decisions have single quotes in their scenario, so pipe api-cli straight into jq
    ${ips}=    Execute Command    api-cli run list-banned-ip --agent module/${module_id} | jq -r '[.[].decisions[].value] | join(",")'
    Should Not Contain    ${ips}    192.0.2.78
    Should Not Contain    ${ips}    192.0.2.77
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 192.0.2.77
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 192.0.2.78

The local blocklist bans its addresses permanently
    ${out}    ${rc}=    Run Module Action    set-local-blocklist    {"local_blocklist": ["198.51.100.77"]}
    Should Be Equal As Integers    ${rc}    0
    Ban Has Scenario    198.51.100.77    permanent: local blocklist
    Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    198.51.100.77
    ${list}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | jq -c '.local_blocklist'
    Should Be Equal    ${list}    ["198.51.100.77"]
    FOR    ${bad}    IN    198.51.100.0/24    not-an-ip
        ${out}    ${rc}=    Run Module Action    set-local-blocklist    {"local_blocklist": ["${bad}"]}
        Should Not Be Equal As Integers    ${rc}    0
    END

Unban all keeps permanent bans
    ${out}    ${rc}=    Run Module Action    unban-ip    {"action": "unban_all", "ip": "0.0.0.0"}
    Should Be Equal As Integers    ${rc}    0
    ${ips}=    Execute Command    api-cli run list-banned-ip --agent module/${module_id} | jq -r '[.[].decisions[].value] | join(",")'
    Should Contain    ${ips}    198.51.100.77
    ${count}=    Execute Command    echo '{}' | api-cli run list-detections --agent module/${module_id} --data - | jq '[.[] | select(.scenario | startswith("permanent:"))] | length'
    Should Be Equal As Integers    ${count}    0

Unban removes only the temporary bans
    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions add -i 198.51.100.77 -d 10m -R robot-temporary    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${rc}=    Execute Command    echo 198.51.100.77 | runagent -m ${module_id} cscli decisions import -i - --format values -d 10m -R threat-shield/robot    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${out}    ${rc}=    Run Module Action    unban-ip    {"action": "unban", "ip": "198.51.100.77"}
    Should Be Equal As Integers    ${rc}    0
    ${scenarios}=    Active Scenarios    198.51.100.77
    Should Not Contain    ${scenarios}    robot-temporary
    Should Contain    ${scenarios}    permanent: local blocklist
    Should Contain    ${scenarios}    threat-shield/robot

Deleting all detections keeps the local blocklist
    ${out}    ${rc}=    Run Module Action    delete-detections
    Should Be Equal As Integers    ${rc}    0
    Ban Has Scenario    198.51.100.77    permanent: local blocklist

Removing an address from the local blocklist unbans it
    ${out}    ${rc}=    Run Module Action    set-local-blocklist    {"local_blocklist": []}
    Should Be Equal As Integers    ${rc}    0
    ${scenarios}=    Active Scenarios    198.51.100.77
    Should Not Contain    ${scenarios}    permanent:
    ${ips}=    Execute Command    api-cli run list-banned-ip --agent module/${module_id} | jq -r '[.[].decisions[].value] | join(",")'
    Should Not Contain    ${ips}    198.51.100.77
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 198.51.100.77
    Wait Until Keyword Succeeds    20x    5s    IP Not In Ruleset    198.51.100.77

An allowlisted IP cannot be banned permanently
    Execute Command    runagent -m ${module_id} cscli allowlists create robot_permanent -d robot
    Execute Command    runagent -m ${module_id} cscli allowlists add robot_permanent 198.51.100.78
    ${out}    ${rc}=    Run Module Action    set-local-blocklist    {"local_blocklist": ["198.51.100.78"]}
    Should Not Be Equal As Integers    ${rc}    0
    ${count}=    Decision Count    198.51.100.78
    Should Be Equal As Integers    ${count}    0
    Execute Command    runagent -m ${module_id} cscli allowlists delete robot_permanent
