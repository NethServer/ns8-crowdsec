*** Settings ***
Library    SSHLibrary
Library    BuiltIn
Library    Browser

*** Variables ***
${ADMIN_USER}    admin
${ADMIN_PASSWORD}    Nethesis,1234

*** Test Cases ***
Check if crowdsec is installed correctly
    ${output}    ${rc}=    Execute Command    add-module ${IMAGE_URL} 1    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    &{output}=    Evaluate    ${output}
    Set Suite Variable    ${module_id}    ${output.module_id}

Take screenshots
    [Tags]    ui
    New Browser    chromium    headless=True
    New Context    ignoreHTTPSErrors=True
    Login to cluster-admin
    Go To    https://${NODE_ADDR}/cluster-admin/#/apps/${module_id}
    Wait For Elements State    iframe >>> h2 >> text="Status"    visible    timeout=10s
    Sleep    5s
    Take Screenshot    filename=${OUTPUT DIR}/browser/screenshot/1._Status.png
    Go To    https://${NODE_ADDR}/cluster-admin/#/apps/${module_id}?page=settings
    Wait For Elements State    iframe >>> h2 >> text="Settings"    visible    timeout=10s
    Sleep    5s
    Take Screenshot    filename=${OUTPUT DIR}/browser/screenshot/2._Settings.png
    Go To    https://${NODE_ADDR}/cluster-admin/#/apps/${module_id}?page=alerts
    Wait For Elements State    iframe >>> h2 >> text="Detections"    visible    timeout=10s
    Sleep    5s
    Take Screenshot    filename=${OUTPUT DIR}/browser/screenshot/3._Detections.png
    Go To    https://${NODE_ADDR}/cluster-admin/#/apps/${module_id}?page=collections
    Wait For Elements State    iframe >>> h2 >> text="Collections"    visible    timeout=10s
    Sleep    5s
    Take Screenshot    filename=${OUTPUT DIR}/browser/screenshot/4._Collections.png
    Go To    https://${NODE_ADDR}/cluster-admin/#/apps/${module_id}?page=blocklists
    Wait For Elements State    iframe >>> h2 >> text="Blocklists"    visible    timeout=10s
    Sleep    5s
    Take Screenshot    filename=${OUTPUT DIR}/browser/screenshot/5._Blocklists_Local.png
    Click    iframe >>> role=tab[name="Community blocklist"]
    Wait For Elements State    iframe >>> h4 >> text="Configuration"    visible    timeout=10s
    Sleep    3s
    Take Screenshot    filename=${OUTPUT DIR}/browser/screenshot/6._Blocklists_Community.png
    Click    iframe >>> role=tab[name="Allowlist"]
    Wait For Elements State    iframe >>> text="Allowlist entries"    visible    timeout=10s
    Sleep    3s
    Take Screenshot    filename=${OUTPUT DIR}/browser/screenshot/7._Blocklists_Allowlist.png
    Close Browser

Check if bouncer is installed correctly
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli bouncers inspect localhost    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    Should Contain    ${output}    Revoked?      false

Display cscli collections list
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli collections list    return_rc=True
    Log    ${output}
    Should Be Equal As Integers    ${rc}    0

Display cscli scenarios list
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli scenarios list    return_rc=True
    Log    ${output}
    Should Be Equal As Integers    ${rc}    0

Display cscli parsers list
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli parsers list    return_rc=True
    Log    ${output}
    Should Be Equal As Integers    ${rc}    0

List collections and re-enable one
    # non-destructive: reinstall an already-enabled collection (no-op) to
    # exercise toggle-collection without breaking crowdsec dependencies
    ${output}    ${rc}=    Run Module Action    list-collections
    Should Be Equal As Integers    ${rc}    0
    ${name}=    Execute Command    echo '${output}' | jq -r '[.[] | select(.status=="enabled")][0].name'
    Should Not Be Empty    ${name}
    Should Not Be Equal    ${name}    null
    ${out}    ${rc}=    Run Module Action    toggle-collection    {"name": "${name}", "action": "install"}
    Should Be Equal As Integers    ${rc}    0

Check CAPI status action
    ${output}    ${rc}=    Run Module Action    get-capi-status
    Should Be Equal As Integers    ${rc}    0
    ${connected}=    Execute Command    echo '${output}' | jq 'has("connected")'
    Should Be Equal    ${connected}    true

Check CAPI count action
    # get-capi-count is slow and may report 0 decisions early; only assert it succeeds
    Wait Until Keyword Succeeds    5x    10s    CAPI Count Succeeds

Search a CAPI decision
    ${output}    ${rc}=    Run Module Action    search-capi-decision    {"ip": "185.220.101.1"}
    Should Be Equal As Integers    ${rc}    0
    ${has_found}=    Execute Command    echo '${output}' | jq 'has("found")'
    Should Be Equal    ${has_found}    true

Check if crowdsec can ban 10.10.10.10
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions add -i 10.10.10.10    return_rc=True
    Should Be Equal As Integers    ${rc}    0

Check if crowdsec can list decisions
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions list    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    Should Contain    ${output}    Ip:10.10.10.10

Check if 10.10.10.10 is listed in ruleset (20 attempts with 5 sec)
    ${os_release}=    Execute Command    cat /etc/os-release
    IF    'ID=debian' in $os_release
        Skip    Skipping ruleset check: nft not available on Debian
    ELSE
        Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    10.10.10.10
    END

Check if crowdsec can unban 10.10.10.10
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions delete -i 10.10.10.10    return_rc=True
    Should Be Equal As Integers    ${rc}    0

List alerts and inspect the manual alert
    # the manual ban above created an alert; deleting its decision leaves the
    # alert, so list-alerts still returns it here (run after the ruleset check
    # because flushing alerts cascades to their decisions)
    ${output}    ${rc}=    Run Module Action    list-alerts
    Should Be Equal As Integers    ${rc}    0
    ${id}=    Execute Command    echo '${output}' | jq -r '.[0].id'
    Should Not Be Empty    ${id}
    Should Not Be Equal    ${id}    null
    ${out}    ${rc}=    Run Module Action    inspect-alert    {"id": ${id}}
    Should Be Equal As Integers    ${rc}    0
    ${has_scenario}=    Execute Command    echo '${out}' | jq 'has("scenario")'
    Should Be Equal    ${has_scenario}    true

Flush alerts
    ${out}    ${rc}=    Run Module Action    delete-alerts
    Should Be Equal As Integers    ${rc}    0

Unban an IP through the module action
    ${rc}=    Execute Command    runagent -m ${module_id} cscli decisions add -i 1.2.3.4    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${os_release}=    Execute Command    cat /etc/os-release
    # confirm the ban reached nft before unbanning (nft not available on Debian)
    IF    'ID=debian' not in $os_release
        Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    1.2.3.4
    END
    ${out}    ${rc}=    Run Module Action    unban-ip    {"action": "unban", "ip": "1.2.3.4"}
    Should Be Equal As Integers    ${rc}    0
    ${output}=    Execute Command    runagent -m ${module_id} cscli decisions list
    Should Not Contain    ${output}    Ip:1.2.3.4

Configure and verify the allowlist
    # runs after the ban/ruleset flow: configure-module restarts the firewall
    # bouncer, so keep it away from the nft ruleset assertions above
    ${rc}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | jq -c '.whitelists=["10.20.30.40"]' | api-cli run configure-module --agent module/${module_id} --data -    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    Wait Until Keyword Succeeds    10x    3s    Allowlist Contains    10.20.30.40

Round-trip the configuration
    ${rc}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | jq -c '.bantime="2" | .enable_online_api=true' | api-cli run configure-module --agent module/${module_id} --data -    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${bantime}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | jq -r '.bantime'
    Should Be Equal    ${bantime}    2

Check if crowdsec is removed correctly
    ${rc}=    Execute Command    remove-module --no-preserve ${module_id}    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0



*** Keywords ***
Run Module Action
    # always feed stdin: several actions do `input=$(cat)` and fail on empty input
    [Arguments]    ${action}    ${json}={}
    ${output}    ${rc}=    Execute Command    echo '${json}' | api-cli run ${action} --agent module/${module_id} --data -    return_rc=True
    RETURN    ${output}    ${rc}

Allowlist Contains
    [Arguments]    ${ip}
    ${output}=    Execute Command    runagent -m ${module_id} cscli allowlists inspect nethserver_whitelist
    Should Contain    ${output}    ${ip}

CAPI Count Succeeds
    ${output}    ${rc}=    Execute Command    api-cli run get-capi-count --agent module/${module_id}    return_rc=True
    Should Be Equal As Integers    ${rc}    0

Login to cluster-admin
    New Page    https://${NODE_ADDR}/cluster-admin/
    Fill Text    text="Username"    ${ADMIN_USER}
    Click    button >> text="Continue"
    Fill Text    text="Password"    ${ADMIN_PASSWORD}
    Click    button >> text="Log in"
    Wait For Elements State    css=#main-content    visible    timeout=10s

Check IP In Ruleset
    [Arguments]    ${ip}
    ${output}    ${rc}=    Execute Command    nft list ruleset | grep ${ip}    return_rc=True
    Run Keyword If    ${rc} != 0    Sleep With Backoff
    Should Be Equal As Integers    ${rc}    0

Sleep With Backoff
    ${attempt}=    Get Variable Value    ${RETRY_INDEX}    1
    ${delay}=    Evaluate    min(${attempt} * 2, 10)
    Log    Retry #${attempt} — waiting ${delay}s before next attempt
    Sleep    ${delay}s
