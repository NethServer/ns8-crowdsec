*** Settings ***
Resource    crowdsec.resource

*** Test Cases ***
Configure and verify the allowlist
    # runs after the ban/ruleset flow: configure-module restarts the firewall
    # bouncer, so keep it away from the nft ruleset assertions above
    Configure Module With    .whitelists=["10.20.30.40"]
    Wait Until Keyword Succeeds    10x    3s    Allowlist Contains    10.20.30.40

Whitelist entries are split between the allowlist and the FQDN postoverflow
    Configure Module With    .whitelists=["10.20.30.41","example.com","10.0.0.0/24","2001:db8::77","2001:db8:1::/64"]
    ${output}=    Execute Command    runagent -m ${module_id} cscli allowlists inspect nethserver_whitelist -o json | jq -r '[.items[].value] | sort | join(",")'
    Should Be Equal    ${output}    10.0.0.0/24,10.20.30.41,2001:db8:1::/64,2001:db8::77
    ${output}    ${rc}=    Read Config File    postoverflows/s01-whitelist/nethserver-postoverflows-whitelists.yaml
    Should Be Equal As Integers    ${rc}    0
    Should Contain    ${output}    LookupHost("example.com")
    Should Not Contain    ${output}    10.20.30.41
    Should Not Contain    ${output}    2001:db8

An empty whitelist removes the allowlist entries and the FQDN postoverflow
    Configure Module With    .whitelists=[]
    ${output}=    Execute Command    runagent -m ${module_id} cscli allowlists inspect nethserver_whitelist -o json | jq '[.items[]?] | length'
    Should Be Equal As Integers    ${output}    0
    ${output}    ${rc}=    Read Config File    postoverflows/s01-whitelist/nethserver-postoverflows-whitelists.yaml
    Should Not Be Equal As Integers    ${rc}    0

A fixed ban time renders a plain duration
    Configure Module With    .dyn_bantime=false | .bantime="2"
    ${output}    ${rc}=    Read Config File    profiles.yaml.local
    Should Contain    ${output}    duration: 2m
    Should Not Contain    ${output}    duration_expr

A dynamic ban time renders a duration expression
    Configure Module With    .dyn_bantime=true | .dynamic_bantime_duration="7"
    ${output}    ${rc}=    Read Config File    profiles.yaml.local
    Should Contain    ${output}    duration: 7m
    Should Contain    ${output}    duration_expr: Sprintf('%dm', (GetDecisionsCount(Alert.GetValue()) + 1) * 7)

No notification is rendered without smarthost or subscription
    ${output}    ${rc}=    Read Config File    profiles.yaml.local
    Should Be Equal As Integers    ${rc}    0
    Should Not Contain    ${output}    notifications:
    FOR    ${file}    IN    email.yaml    nethesis-insights.yaml
        ${output}    ${rc}=    Read Config File    notifications/${file}
        Should Not Be Equal As Integers    ${rc}    0    ${file} should not exist
    END

Banning the local network removes the private IP whitelist parser
    Configure Module With    .ban_local_network=true
    ${count}=    Execute Command    runagent -m ${module_id} cscli parsers list -o json | jq '[.parsers[] | select(.name=="crowdsecurity/whitelists")] | length'
    Should Be Equal As Integers    ${count}    0
    Configure Module With    .ban_local_network=false
    ${count}=    Execute Command    runagent -m ${module_id} cscli parsers list -o json | jq '[.parsers[] | select(.name=="crowdsecurity/whitelists")] | length'
    Should Be Equal As Integers    ${count}    1

Disabling the online API turns the Central API off
    Configure Module With    .enable_online_api=false
    ${value}=    Execute Command    runagent -m ${module_id} printenv DISABLE_ONLINE_API
    Should Be Equal    ${value}    True
    ${output}    ${rc}=    Run Module Action    get-capi-status
    Should Be Equal As Integers    ${rc}    0
    ${status}=    Execute Command    echo '${output}' | jq -c '[.config_disabled, .connected]'
    Should Be Equal    ${status}    [true,false]
    Configure Module With    .enable_online_api=true
    ${value}=    Execute Command    runagent -m ${module_id} printenv DISABLE_ONLINE_API
    Should Be Equal    ${value}    False

Invalid configuration values are rejected
    Execute Command    api-cli run get-configuration --agent module/${module_id} > /tmp/crowdsec-config.json
    FOR    ${filter}    IN    .group_threshold\=0    .receiver_emails=["not-an-email"]    .whitelists=["not a host"]
        ${rc}=    Execute Command    jq -c '${filter}' /tmp/crowdsec-config.json | api-cli run configure-module --agent module/${module_id} --data -    return_rc=True    return_stdout=False
        Should Not Be Equal As Integers    ${rc}    0    ${filter} was accepted
    END
    ${rc}=    Execute Command    api-cli run get-configuration --agent module/${module_id} | cmp -s - /tmp/crowdsec-config.json    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0    a rejected call changed the configuration
    [Teardown]    Restore Saved Configuration
