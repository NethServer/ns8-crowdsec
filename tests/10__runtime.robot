*** Settings ***
Resource    crowdsec.resource

*** Test Cases ***
Take screenshots
    [Tags]    ui
    Import Library    Browser
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
    Go To    https://${NODE_ADDR}/cluster-admin/#/apps/${module_id}?page=detections
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
    Go To    https://${NODE_ADDR}/cluster-admin/#/apps/${module_id}?page=threat-shield
    Wait For Elements State    iframe >>> h2 >> text="Threat Shield"    visible    timeout=10s
    Sleep    5s
    Take Screenshot    filename=${OUTPUT DIR}/browser/screenshot/8._Threat_Shield.png
    Go To    https://${NODE_ADDR}/cluster-admin/#/apps/${module_id}?page=about
    Wait For Elements State    iframe >>> h2 >> text="About"    visible    timeout=10s
    Sleep    5s
    Take Screenshot    filename=${OUTPUT DIR}/browser/screenshot/9._About.png
    Close Browser

Check if bouncer is installed correctly
    ${output}    ${rc}=    Execute Command    runagent -m ${module_id} cscli bouncers inspect localhost    return_rc=True
    Should Be Equal As Integers    ${rc}    0
    Should Contain    ${output}    Revoked?      false

Check the systemd units
    FOR    ${unit}    IN    ${module_id}.service    ${module_id}-firewall-bouncer.service    ${module_id}-upgrade-hub.timer
        ${rc}=    Execute Command    systemctl is-active ${unit}    return_rc=True    return_stdout=False
        Should Be Equal As Integers    ${rc}    0    ${unit} is not active
    END
    # no subscription in CI, so sync-threat-shield-timer keeps it off
    ${rc}=    Execute Command    systemctl is-active ${module_id}-threat-shield.timer    return_rc=True    return_stdout=False
    Should Not Be Equal As Integers    ${rc}    0

Check the metrics target and dashboards
    ${target}=    Execute Command    redis-cli hget module/${module_id}/metrics_targets crowdsec | grep -oE '[0-9.]+:[0-9]+'
    Should Not Be Empty    ${target}
    ${dashboards}=    Execute Command    redis-cli hkeys module/${module_id}/metrics_dashboards | sort | paste -sd,
    Should Be Equal    ${dashboards}    crowdsec_bans,crowdsec_metrics,crowdsec_overview
    # the metrics listener can lag behind the LAPI after the create-module reload or the update restart
    Wait Until Keyword Succeeds    12x    5s    Metrics Endpoint Answers    ${target}
