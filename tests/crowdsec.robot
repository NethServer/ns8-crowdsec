*** Settings ***
Library    SSHLibrary

*** Test Cases ***
Check if crowdsec is installed correctly
    ${output}  ${rc} =    Execute Command    add-module ${IMAGE_URL} 1
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    &{output} =    Evaluate    ${output}
    Set Suite Variable    ${module_id}    ${output.module_id}

Check if crowdsec can be configured
    ${rc} =    Execute Command    api-cli run module/${module_id}/configure-module --data '{"ban_local_network": true,"bantime": "1","dyn_bantime": true,"enable_online_api": true,"enroll_instance": "","helo_host": "","receiver_emails": [""],"whitelists": [""]}'
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0

Check if crowdsec is removed correctly
    ${rc} =    Execute Command    remove-module --no-preserve ${module_id}
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0
