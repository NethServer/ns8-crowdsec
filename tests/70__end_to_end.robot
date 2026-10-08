*** Settings ***
Resource    crowdsec.resource

*** Test Cases ***
A kamailio brute force gets banned
    # real end to end path: journald acquisition, tainted parser and scenario, profile
    Wait Until Keyword Succeeds    4x    1s    Brute Force Is Banned    Send Kamailio Auth Failures    198.51.100.23    nethserver/kamailio-bf
    Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    198.51.100.23
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 198.51.100.23

An SSH brute force gets banned
    # hub sshd collection through the same journald acquisition
    Wait Until Keyword Succeeds    4x    1s    Brute Force Is Banned    Send SSH Auth Failures    198.51.100.30    crowdsecurity/ssh-
    Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    198.51.100.30
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 198.51.100.30

An IPv6 SSH brute force gets banned
    Wait Until Keyword Succeeds    4x    1s    Brute Force Is Banned    Send SSH Auth Failures    2001:db8::88    crowdsecurity/ssh-
    Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    2001:db8::88
    Execute Command    runagent -m ${module_id} cscli decisions delete -i 2001:db8::88

Allowlisted IPv4 and IPv6 addresses and networks are never banned
    Configure Module With    .whitelists=["198.51.100.24","198.51.100.128/25","2001:db8::99","2001:db8:1::/64"]
    Wait Until Keyword Succeeds    10x    3s    Allowlist Contains    198.51.100.24
    Wait Until Keyword Succeeds    10x    3s    Allowlist Contains    2001:db8::99
    @{allowed}=    Create List    198.51.100.24    198.51.100.130    2001:db8::99    2001:db8:1::5
    @{controls}=    Create List    198.51.100.25    2001:db8::98
    Wait Until Keyword Succeeds    4x    1s    Controls Are Banned After A Batch    ${allowed}    ${controls}
    FOR    ${ip}    IN    @{allowed}
        ${count}=    Decision Count    ${ip}
        Should Be Equal As Integers    ${count}    0    ${ip} was banned
        IP Not In Ruleset    ${ip}
    END
    [Teardown]    Reset Allowlist Test    198.51.100.25    2001:db8::98

An IP behind an allowlisted FQDN is never banned
    # LookupHost runs in the container, which copies the host /etc/hosts at start
    Execute Command    echo '198.51.100.140 fqdn-test.example.org' >> /etc/hosts
    Configure Module With    .whitelists=["fqdn-test.example.org"]
    ${since}=    Execute Command    date '+%Y-%m-%d %H:%M:%S'
    @{allowed}=    Create List    198.51.100.140
    @{controls}=    Create List    198.51.100.141
    Wait Until Keyword Succeeds    4x    1s    Controls Are Banned After A Batch    ${allowed}    ${controls}
    ${count}=    Decision Count    198.51.100.140
    Should Be Equal As Integers    ${count}    0
    IP Not In Ruleset    198.51.100.140
    ${output}=    Execute Command    journalctl -u ${module_id} --since '${since}' --no-pager | grep -c 'Ban for 198.51.100.140 whitelisted'
    Should Not Be Equal As Integers    ${output}    0
    [Teardown]    Remove FQDN Test Host

A private IP is banned only when banning the local network is on
    Configure Module With    .ban_local_network=true
    Wait Until Keyword Succeeds    4x    1s    Brute Force Is Banned    Send SSH Auth Failures    192.168.250.10    crowdsecurity/ssh-
    Wait Until Keyword Succeeds    20x    5s    Check IP In Ruleset    192.168.250.10
    Configure Module With    .ban_local_network=false
    # back to the default, the private range is whitelisted again
    @{allowed}=    Create List    192.168.250.11
    @{controls}=    Create List    198.51.100.150
    Wait Until Keyword Succeeds    4x    1s    Controls Are Banned After A Batch    ${allowed}    ${controls}
    ${count}=    Decision Count    192.168.250.11
    Should Be Equal As Integers    ${count}    0
    IP Not In Ruleset    192.168.250.11
    [Teardown]    Reset Local Network Test
