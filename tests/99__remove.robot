*** Settings ***
Resource    crowdsec.resource

*** Test Cases ***
Check if crowdsec is removed correctly
    ${rc}=    Execute Command    remove-module --no-preserve ${module_id}    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${units}=    Execute Command    ls /etc/systemd/system | grep -c '^${module_id}\[.-]'
    Should Be Equal As Integers    ${units}    0    systemd units left behind
    ${rc}=    Execute Command    podman container exists ${module_id}    return_rc=True    return_stdout=False
    Should Not Be Equal As Integers    ${rc}    0    container left behind
    # the bouncer tables hold every ban, they must not outlive the module
    ${tables}=    Execute Command    nft list tables | grep -cE 'crowdsec6?$'
    Should Be Equal As Integers    ${tables}    0    nft tables left behind
