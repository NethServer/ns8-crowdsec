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

Check if crowdsec is removed correctly
    ${rc}=    Execute Command    remove-module --no-preserve ${module_id}    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0



*** Keywords ***
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
