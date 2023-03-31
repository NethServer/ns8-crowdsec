# ns8-crowdsec

CrowdSec is an open-source and lightweight software that allows you to detect peers with malevolent behaviors and block them from accessing your systems at various levels (infrastructural, system, applicative).
To achieve this, CrowdSec reads logs from different sources (files, streams ...) to parse, normalize and enrich them before matching them to threats patterns called scenarios.

ns8-crowdsec installs the LAPI (local api) on the node, composed of agent (to read logs) and a list of collections to parse them (scenarios, parsers...), the notifications can be sent by email.
When crowdsec detects an IP which is abusing it triggers an alert and then a decision (ban) to block the IP with a bouncer (iptable with IPSET). The bouncer is installed on the node however it could be installed to another Linux machine.

## Documentation

https://docs.crowdsec.net/docs/intro

## Install

**You can install only one crowdsec instance on the node**, other crowdsec instance will conflict with crowdsec1 and fail to start

Instantiate the module with:

    add-module ghcr.io/nethserver/crowdsec:latest 1

The output of the command will return the instance name.
Output example:

    {"module_id": "crowdsec1", "image_name": "crowdsec", "image_url": "ghcr.io/nethserver/crowdsec:latest"}

## Configure email notification

ns8-crowdsec detects changes in the event smarthost-changed and adapt to the new settings to send email when the alerts or decisions come.

First of all, you need to set the smarthost credentials in the `Settings > Smarthost` panel of the cluster-admin UI

then trigger the action configure-module (see below)

## Configure

Let's assume that the crowdsec instance is named `crowdsec1`. Once installed the container is up, nothing is needed, customisation can be done :

- by editing a file inside /var/lib/nethserver/crowdsec1/state/crowdsec_config where all config files are stored
- by editing a file inside the container use the wrapper with the name of the container : `podman exec -ti crowdsec1 bash`

then restart the container : `systemctl restart crowdsec1`

You can also modify settings with the configure-module action

    api-cli run configure-module --agent module/crowdsec1 --data - <<EOF
    {
        "helo_host": "foo.domain.com",
        "receiver_emails": "user@domain.com,user@domain.org",
        "bantime": "1m",
        "dyn_bantime": true
    }
    EOF

`bantime`: set the ban time `m` for minute, `h` for hours
`dyn_bantime`: enable a dynamic ban_time ((number of ban +1) *4) (same unit as ban_time)
`receiver_emails`: all emails account you want to notice when decisions or alert come
`helo_host`: set a fully qualified domain name to use the relevant helo with postfix.(could be empty `""`)

## disable whitelist

by default whitelist is enabled to never ban IP on the local network, for test purpose you could disable it

    cscli parsers remove  crowdsecurity/whitelists
    systemctl restart crowdsec1

### cscli

crowdsec come with a cli, do `cscli --help`, if you want to know on a specific command  `cscli <command> --help`

- get a glance : `cscli metrics`
- see the state of installed bouncers : `cscli bouncers list`
- see the active decisions(ban): `cscli decisions list`
- see the alerts (discovered IP): `cscli alerts list`
- see the details of an alert: `cscli alerts inspect <alert_ID> -d`
- see installed collections : `cscli collections list` or `cscli collections list --all`
- upgrade collections (a systemd timer does upgrade the collection every 15 days): `cscli hub update && cscli hub upgrade`

- ban manually an IP: `cscli decision add -i 1.2.3.4`
- unban an IP `cscli decision remove -i 1.2.3.4`

- inspect a collection: `cscli collections inspect crowdsecurity/sshd`
- inspect a scenario: `cscli scenarios inspect crowdsecurity/ssh-bf`
- inspect a parser: `cscli parsers inspect crowdsecurity/sshd-logs`
  
## Uninstall

To uninstall the instance:

    remove-module --no-preserve crowdsec1

## Testing

Test the module using the `test-module.sh` script:


    ./test-module.sh <NODE_ADDR> ghcr.io/nethserver/crowdsec:latest

The tests are made using [Robot Framework](https://robotframework.org/)
