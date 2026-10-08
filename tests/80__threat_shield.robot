*** Settings ***
Resource    crowdsec.resource

*** Test Cases ***
List the Threat Shield catalog
    ${output}    ${rc}=    Run Module Action    list-threat-shield
    Should Be Equal As Integers    ${rc}    0
    ${keys}=    Execute Command    echo '${output}' | jq -r '[.feeds[].key] | sort | join(",")'
    Should Be Equal    ${keys}    nethesis-insights,nethesislvl3,yoroimallvl1,yoroimallvl2,yoroisusplvl1,yoroisusplvl2
    # CI has no subscription, so no feed is rated (-1)
    ${rated}=    Execute Command    echo '${output}' | jq '[.feeds[] | select(.confidence == -1)] | length'
    Should Be Equal As Integers    ${rated}    6

The insights consensus list is selectable like any other feed
    ${output}    ${rc}=    Run Module Action    set-threat-shield    {"feeds": ["nethesis-insights"]}
    Should Be Equal As Integers    ${rc}    0
    ${enabled}=    Execute Command    api-cli run list-threat-shield --agent module/${module_id} | jq -r '[.feeds[] | select(.enabled) | .key] | join(",")'
    Should Be Equal    ${enabled}    nethesis-insights
    # leave the instance with the feature off
    ${output}    ${rc}=    Run Module Action    set-threat-shield    {"feeds": []}
    Should Be Equal As Integers    ${rc}    0

The configuration no longer carries an insights block
    # get-configuration carries no Threat Shield data
    ${insights}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | jq -r 'has("insights")'
    Should Be Equal    ${insights}    false

Disabling every Threat Shield feed is a clean no-op
    ${output}    ${rc}=    Run Module Action    set-threat-shield    {"feeds": []}
    Should Be Equal As Integers    ${rc}    0
    ${enabled}=    Execute Command    api-cli run list-threat-shield --agent module/${module_id} | jq '[.feeds[] | select(.enabled)] | length'
    Should Be Equal As Integers    ${enabled}    0

Enabling a Threat Shield feed without a subscription creates no decisions
    # CI has no subscription: the import must fail softly, not error out
    ${output}    ${rc}=    Run Module Action    set-threat-shield    {"feeds": ["nethesislvl3"]}
    Should Be Equal As Integers    ${rc}    0
    ${count}=    Execute Command    api-cli run list-threat-shield --agent module/${module_id} | jq '[.feeds[].count] | add'
    Should Be Equal As Integers    ${count}    0
    ${found}=    Execute Command    echo '{"ip": "185.220.101.5"}' | api-cli run search-threat-shield-decision --agent module/${module_id} --data - | jq -r '.found'
    Should Be Equal    ${found}    false
    # leave the instance with the feature off
    ${output}    ${rc}=    Run Module Action    set-threat-shield    {"feeds": []}
    Should Be Equal As Integers    ${rc}    0

An unknown Threat Shield feed is rejected
    ${output}    ${rc}=    Run Module Action    set-threat-shield    {"feeds": ["nosuchfeed"]}
    Should Not Be Equal As Integers    ${rc}    0
