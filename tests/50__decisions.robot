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

The banned IP list hides Threat Shield imports
    # same import call as import-threat-shield: the scenario is the only marker
    ${rc}=    Execute Command    echo 192.0.2.77 | runagent -m ${module_id} cscli decisions import -i - --format values -d 10m -R threat-shield/nethesislvl3    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions add -i 192.0.2.78 -d 10m    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    # manual decisions have single quotes in their scenario, so pipe api-cli straight into jq
    ${ips}=    Execute Command    api-cli run list-banned-ip --agent module/${module_id} | jq -r '[.[].decisions[].value] | join(",")'
    Should Contain    ${ips}    192.0.2.78
    Should Not Contain    ${ips}    192.0.2.77
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 192.0.2.77
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 192.0.2.78
