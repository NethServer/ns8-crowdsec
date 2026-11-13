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

An address on two Threat Shield feeds is found in both
    FOR    ${feed}    IN    nethesislvl3    nethesis-insights
        ${rc}=    Execute Command    echo 192.0.2.80 | runagent -m ${module_id} cscli decisions import -i - --format values -d 10m -R threat-shield/${feed}    return_rc=True    return_stdout=False
        Should Be Equal As Integers    ${rc}    0
    END
    ${feeds}=    Execute Command    echo '{"ip": "192.0.2.80"}' | api-cli run search-threat-shield-decision --agent module/${module_id} --data - | jq -r '[.decisions[].scenario] | sort | join(",")'
    Should Be Equal    ${feeds}    threat-shield/nethesis-insights,threat-shield/nethesislvl3
    # deleted decisions stay in the alerts as expired rows: they must not be found
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 192.0.2.80
    ${found}=    Execute Command    echo '{"ip": "192.0.2.80"}' | api-cli run search-threat-shield-decision --agent module/${module_id} --data - | jq -r '.found'
    Should Be Equal    ${found}    false
    [Teardown]    Execute Command    runagent -m ${module_id} cscli decisions delete -i 192.0.2.80

Custom lists are listed and enable the timer without a subscription
    # port 9 refuses at once, so the import run by the action ends quickly
    ${output}    ${rc}=    Run Module Action    set-threat-shield    {"feeds": ["custom-mylist"], "custom_allowlists": [{"name": "office", "url": "http://user:pass@127.0.0.1:9/allow.txt", "description": "Office", "enabled": true}], "custom_blocklists": [{"name": "mylist", "url": "http://127.0.0.1:9/block.txt", "description": "My list"}]}
    Should Be Equal As Integers    ${rc}    0
    ${output}=    Execute Command    api-cli run list-threat-shield --agent module/${module_id}
    ${feed}=    Execute Command    echo '${output}' | jq -c '.feeds[] | select(.key == "custom-mylist") | [.custom, .enabled, .confidence, .description]'
    Should Be Equal    ${feed}    [true,true,-1,"My list"]
    # CI has no subscription: the built-in Nethesis row is listed as disabled
    ${rows}=    Execute Command    echo '${output}' | jq -c '[.allowlists[] | [.name, .builtin, .enabled]]'
    Should Be Equal    ${rows}    [["nethesis",true,false],["office",false,true]]
    ${rc}=    Execute Command    systemctl is-active ${module_id}-threat-shield.timer    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    # removing the lists drops the custom feed and turns the timer off again
    ${output}    ${rc}=    Run Module Action    set-threat-shield    {"feeds": [], "custom_allowlists": [], "custom_blocklists": []}
    Should Be Equal As Integers    ${rc}    0
    ${left}=    Execute Command    api-cli run list-threat-shield --agent module/${module_id} | jq -c '[.feeds[] | select(.custom)] + [.allowlists[] | select(.builtin | not)]'
    Should Be Equal    ${left}    []
    ${rc}=    Execute Command    systemctl is-active ${module_id}-threat-shield.timer    return_rc=True    return_stdout=False
    Should Not Be Equal As Integers    ${rc}    0

Invalid, duplicated or reserved custom list names are rejected
    FOR    ${lists}    IN
    ...    {"feeds": [], "custom_blocklists": [{"name": "Bad_Name", "url": "https://example.org/a.txt"}]}
    ...    {"feeds": [], "custom_blocklists": [{"name": "ab", "url": "https://example.org/a.txt"}]}
    ...    {"feeds": [], "custom_blocklists": [{"name": "my-list", "url": "https://example.org/a.txt"}]}
    ...    {"feeds": [], "custom_blocklists": [{"name": "dup", "url": "https://example.org/a.txt"}, {"name": "dup", "url": "https://example.org/b.txt"}]}
    ...    {"feeds": [], "custom_allowlists": [{"name": "nethesis", "url": "https://example.org/a.txt"}]}
    ...    {"feeds": [], "custom_blocklists": [{"name": "yoroiextra", "url": "https://example.org/a.txt"}]}
    ...    {"feeds": [], "custom_allowlists": [{"name": "office", "url": "https://u@p@example.org/a.txt"}]}
        ${output}    ${rc}=    Run Module Action    set-threat-shield    ${lists}
        Should Not Be Equal As Integers    ${rc}    0
    END
