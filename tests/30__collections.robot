*** Settings ***
Resource    crowdsec.resource

*** Test Cases ***
Install and remove a hub collection
    # crowdsecurity/iptables is not in the default set and nothing depends on it
    ${out}    ${rc}=    Run Module Action    toggle-collection    {"name": "crowdsecurity/iptables", "action": "install"}
    Should Be Equal As Integers    ${rc}    0
    ${status}=    Hub Collection Status    crowdsecurity/iptables
    Should Be Equal    ${status}    enabled
    ${status}=    Collection Status    crowdsecurity/iptables
    Should Contain    ${status}    enabled
    Sleep    15s
    ${out}    ${rc}=    Run Module Action    toggle-collection    {"name": "crowdsecurity/iptables", "action": "remove"}
    Should Be Equal As Integers    ${rc}    0
    ${status}=    Hub Collection Status    crowdsecurity/iptables
    Should Be Equal    ${status}    disabled
    [Teardown]    Remove Hub Collection    crowdsecurity/iptables

Toggle the nethesis/nethvoice collection
    # fake collection: it flips an env flag and copies the tainted files
    # toggle-collection returns before the HUP reload ends, a second toggle too soon crashes crowdsec
    Sleep    15s
    ${out}    ${rc}=    Run Module Action    toggle-collection    {"name": "nethesis/nethvoice", "action": "remove"}
    Should Be Equal As Integers    ${rc}    0
    ${status}=    Collection Status    nethesis/nethvoice
    Should Be Equal    ${status}    disabled
    ${rc}=    Execute Command    runagent -m ${module_id} test -e crowdsec_config/scenarios/kamailio-bf.yaml    return_rc=True    return_stdout=False
    Should Not Be Equal As Integers    ${rc}    0
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} kamailio[123]: [SECURITY-AUTHFAIL] abc REGISTER-1 - event=auth_failure method=REGISTER status=401 src_ip=203.0.113.7 user=200 callid=abc
    Should Not Contain    ${output}    nethserver/kamailio-logs
    # files that stay on whatever the flag says
    ${rc}=    Execute Command    runagent -m ${module_id} test -e crowdsec_config/parsers/s02-enrich/mattermost-whitelist.yaml    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    Sleep    15s
    ${out}    ${rc}=    Run Module Action    toggle-collection    {"name": "nethesis/nethvoice", "action": "install"}
    Should Be Equal As Integers    ${rc}    0
    ${status}=    Collection Status    nethesis/nethvoice
    Should Be Equal    ${status}    enabled
    ${count}=    Execute Command    runagent -m ${module_id} ls crowdsec_config/scenarios crowdsec_config/parsers/s01-parse crowdsec_config/parsers/s02-enrich | grep -cE 'kamailio|nethvoice'
    Should Be Equal As Integers    ${count}    9
    # the end to end suite needs the kamailio rules back even if a check above failed
    [Teardown]    Enable NethVoice Collection
