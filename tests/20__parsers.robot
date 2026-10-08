*** Settings ***
Resource    crowdsec.resource

*** Test Cases ***
The kamailio parser and scenario match a SIP auth failure
    # real line from nethesis/ns8-nethvoice-proxy#193, only the source IP is changed
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} kamailio[189607]: 35(43) WARNING: <script>: [SECURITY-AUTHFAIL] b5p1i2a78g8daty1@127.0.0.1 REGISTER-1 - event=auth_failure method=REGISTER status=403 src_ip=203.0.113.7 user=testuser callid=b5p1i2a78g8daty1@127.0.0.1
    Should Contain    ${output}    🟢 nethserver/kamailio-logs
    Should Contain    ${output}    evt.Meta.source_ip : 203.0.113.7
    Should Contain    ${output}    🟢 nethserver/kamailio-bf

The NethVoice middleware parser and scenario match a failed login
    # Gin default logger layout, padded columns included
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} nethvoice-cti-middleware[123]: [GIN] 2026/10/06 - 10:00:00 | 401 |${SPACE * 9}1.2ms |${SPACE * 5}203.0.113.8 | POST${SPACE * 5}"/login"
    Should Contain    ${output}    🟢 nethserver/nethvoice-middleware-logs
    Should Contain    ${output}    evt.Meta.source_ip : 203.0.113.8
    Should Contain    ${output}    🟢 nethserver/nethvoice-middleware-bf

The NethVoice reports parser and scenario match a failed login
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} reports-api[123]: [GIN] 2026/10/06 - 10:00:00 | 401 |${SPACE * 9}1.2ms |${SPACE * 5}203.0.113.9 | POST${SPACE * 5}"/api/login"
    Should Contain    ${output}    🟢 nethserver/nethvoice-reports-logs
    Should Contain    ${output}    evt.Meta.source_ip : 203.0.113.9
    Should Contain    ${output}    🟢 nethserver/nethvoice-reports-bf

The NethVoice admin and exploit scenarios match traefik lines
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} traefik[123]: 203.0.113.13 - - [06/Oct/2026:07:29:27 +0000] "POST /freepbx/rest/login HTTP/1.1" 401 10 "-" "-" 1 "nethvoice1-https@file" "http://127.0.0.1:3000" 3ms
    Should Contain    ${output}    🟢 nethserver/nethvoice-admin-login-bf
    Should Contain    ${output}    evt.Meta.source_ip : 203.0.113.13
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} traefik[123]: 203.0.113.14 - - [06/Oct/2026:07:29:27 +0000] "POST /admin/config.php HTTP/1.1" 404 10 "-" "-" 1 "nethvoice1-https@file" "http://127.0.0.1:3000" 3ms
    Should Contain    ${output}    🟢 nethserver/nethvoice-http-exploit-scan
    Should Contain    ${output}    evt.Meta.source_ip : 203.0.113.14

The Nextcloud parser matches a failed login
    # real web login failure logged by Nextcloud 33, only the source IP is changed
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} nextcloud-app[123]: NOTICE: PHP message: [nextcloud][no app in context][2] {"reqId":"mjZICDx3FXiZV19T94Zn","level":2,"time":"2026-10-08T07:33:47+00:00","remoteAddr":"203.0.113.10","user":"--","app":"no app in context","method":"POST","url":"/login","scriptName":"/index.php","message":"Login failed: bob (Remote IP: 203.0.113.10)","userAgent":"Mozilla/5.0","version":"33.0.9.1","data":[]}
    Should Contain    ${output}    🟢 crowdsecurity/nextcloud-logs
    Should Contain    ${output}    evt.Meta.source_ip : 203.0.113.10
    Should Contain    ${output}    🟢 crowdsecurity/nextcloud-bf

The Nextcloud parser matches a brute force warning
    # real line logged by Nextcloud 33 once its own throttling kicks in, only the IP is changed
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} nextcloud-app[123]: NOTICE: PHP message: [nextcloud][core][1] {"reqId":"mjZICDx3FXiZV19T94Zn","level":1,"time":"2026-10-08T07:33:47+00:00","remoteAddr":"203.0.113.15","user":"--","app":"core","method":"POST","url":"/login","scriptName":"/index.php","message":"Bruteforce attempt from \\"203.0.113.15\\" detected for action \\"login\\".","userAgent":"Mozilla/5.0","version":"33.0.9.1","data":{"app":"core"}}
    Should Contain    ${output}    🟢 crowdsecurity/nextcloud-logs
    Should Contain    ${output}    evt.Meta.source_ip : 203.0.113.15
    Should Contain    ${output}    🟢 crowdsecurity/nextcloud-bf

The dovecot parser and scenario match an IMAP login failure
    # real line from the NS8 mail module, only the remote IP is changed
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} dovecot[3457027]: imap-login: Disconnected: Aborted login by logging out (auth failed, 1 attempts in 2 secs): user=<robot-test-user>, method=PLAIN, rip=203.0.113.20, lip=127.0.0.1, TLS, session=<10//zk9d/KZ/AAAB>
    Should Contain    ${output}    🟢 crowdsecurity/dovecot-logs
    Should Contain    ${output}    evt.Meta.source_ip : 203.0.113.20
    Should Contain    ${output}    🟢 crowdsecurity/dovecot-spam

The postfix parser and scenario match an SMTP AUTH failure
    # real line from the NS8 mail module, client shown as unknown[IP] when it has no reverse DNS
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} postfix/smtpd[3918713]: warning: unknown[203.0.113.21]: SASL PLAIN authentication failed: (reason unavailable), sasl_username=robot-test-user
    Should Contain    ${output}    🟢 crowdsecurity/postfix-logs
    Should Contain    ${output}    evt.Meta.source_ip : 203.0.113.21
    Should Contain    ${output}    🟢 crowdsecurity/postfix-spam

The Mattermost whitelist skips ID-ending API calls only
    # real line from a Mattermost node, route name included, only the client IP is changed
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} traefik[123]: 203.0.113.11 - - [08/Oct/2026:07:41:41 +0000] "GET /api/v4/channels/abcdefghijklmnopqrstuvwxyz HTTP/2.0" 401 186 "-" "-" 9163 "mattermost1-https@file" "http://127.0.0.1:20023" 0ms
    Should Contain    ${output}    🟢 nethserver/mattermost-whitelist
    Should Contain    ${output}    [whitelisted]
    # a path traversal on the same route must still reach the scenarios
    ${output}=    Explain Log Line    ${SYSLOG_PREFIX} traefik[123]: 203.0.113.12 - - [06/Oct/2026:07:29:27 +0000] "GET /api/v4/../channels/abcdefghijklmnopqrstuvwxyz HTTP/2.0" 401 186 "-" "-" 9164 "mattermost1-https@file" "http://127.0.0.1:20023" 0ms
    Should Not Contain    ${output}    [whitelisted]
    Should Contain    ${output}    🟢 crowdsecurity/http-path-traversal-probing
