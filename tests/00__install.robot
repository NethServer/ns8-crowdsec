*** Settings ***
Resource    crowdsec.resource

*** Test Cases ***
Check if crowdsec is installed correctly
    # a fresh cloud image leaves the initrd journal under another machine-id in /run/log/journal,
    # create-module would then mount it instead of /var/log/journal and read no line
    Execute Command    mid=$(cat /etc/machine-id); echo "$mid" | grep -qE '^[0-9a-f]{32}$' && find /run/log/journal -mindepth 1 -maxdepth 1 ! -name "$mid" -exec rm -rf {} +
    # the update scenario starts from the NS8 stable release, then upgrades it below
    ${image}=    Set Variable If    '${SCENARIO}' == 'update'    crowdsec    ${IMAGE_URL}
    ${output}    ${rc}=    Execute Command    add-module ${image} 1    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    &{output}=    Evaluate    ${output}
    Set Global Variable    ${module_id}    ${output.module_id}
    # create-module ends with a reload that can kill crowdsec while its entrypoint still installs the hub, systemd then restarts it
    Wait Until Keyword Succeeds    24x    5s    CrowdSec Is Ready

Seed the stable release before the update
    Skip If    '${SCENARIO}' != 'update'    scenario is ${SCENARIO}, nothing to update
    Configure Module With    .whitelists=["10.20.30.42","example.org"] | .dyn_bantime=false | .bantime="3"
    Wait Until Keyword Succeeds    10x    3s    Allowlist Contains    10.20.30.42
    Wait Until Keyword Succeeds    10x    3s    Add Long Decision    192.0.2.200

Update crowdsec to the image under test
    Skip If    '${SCENARIO}' != 'update'    scenario is ${SCENARIO}, nothing to update
    ${rc}=    Execute Command
    ...    api-cli run update-module --data '{"force":true,"module_url":"${IMAGE_URL}","instances":["${module_id}"]}'
    ...    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${image}=    Execute Command    redis-cli hget module/${module_id}/environment IMAGE_URL
    Should Be Equal    ${image}    ${IMAGE_URL}
    Wait Until Keyword Succeeds    24x    5s    CrowdSec Is Ready

Check the configuration survives the update
    Skip If    '${SCENARIO}' != 'update'    scenario is ${SCENARIO}, nothing to update
    ${config}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | jq -c '[.whitelists, .dyn_bantime, .bantime]'
    Should Be Equal    ${config}    [["10.20.30.42","example.org"],false,"3"]
    Wait Until Keyword Succeeds    10x    3s    Allowlist Contains    10.20.30.42
    # templates are rendered again by the new image at start
    ${output}    ${rc}=    Read Config File    postoverflows/s01-whitelist/nethserver-postoverflows-whitelists.yaml
    Should Contain    ${output}    LookupHost("example.org")
    ${output}    ${rc}=    Read Config File    profiles.yaml.local
    Should Contain    ${output}    duration: 3m
    # a stable install already had the NethVoice rules on, the update must keep them
    ${value}=    Execute Command    runagent -m ${module_id} printenv NETHVOICE_COLLECTION_ENABLED
    Should Be Equal    ${value}    True
    ${rc}=    Execute Command    runagent -m ${module_id} test -e crowdsec_config/parsers/s02-enrich/mattermost-whitelist.yaml    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0

Check the decisions and the bouncer survive the update
    Skip If    '${SCENARIO}' != 'update'    scenario is ${SCENARIO}, nothing to update
    ${count}=    Decision Count    192.0.2.200
    Should Be Equal As Integers    ${count}    1
    # the old bouncer key must still pull from the LAPI and push the ban to nft
    Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    192.0.2.200
    [Teardown]    Reset Update Seed
