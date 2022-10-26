# ns8-crowdsec

CrowdSec is an open-source and lightweight software that allows you to detect peers with malevolent behaviors and block them from accessing your systems at various levels (infrastructural, system, applicative).
To achieve this, CrowdSec reads logs from different sources (files, streams ...) to parse, normalize and enrich them before matching them to threats patterns called scenarios.

ns8-crowdsec installs the LAPI (local api) on the node, composed of agent (to read logs) and a list of collections to parse them (scenarios, parsers...), the notifications can be done by email.
When crowdsec detects an IP which is abusing it triggers an alert and then a decision (ban) to block the IP with a bouncer (iptable with IPSET). The bouncer is installed on the node however it could be installed to another firewall (other linux or openwrt).

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

Firstable you need to set the smarthost credential in the settings/smarthost panel of the user interface of https://<host>/cluster-admin

then trigger the action

- `receiver_emails`: all emails account you want to notice when decisions or alert come
- `helo_host`: set a fully qualified domain name to use the relevant helo with postfix. 

```
api-cli run configure-email-notification --agent module/crowdsec1 --data - <<EOF
{
    "receiver_emails":"foo@domain.com,contact@domain.com"
    "helo_host":"myfqdn.domain.com"
}
EOF
```

## Configure

Let's assume that the crowdsec instance is named `crowdsec1`. Once installed the container is up, nothing is needed, customisation can be done :

- by editing a file inside /var/lib/nethserver/crowdsec1/state/crowdsec_config where all config files are stored
- by editing a file inside the container use the wrapper with the name of the container : `crowdsec1 bash`

then restart the container : `systemctl restart crowdsec1`

### cscli

crowdsec come with a cli, do `crowdsec1 cscli --help`, if yopu want to know on a specific command  `crowdsec1 cscli <command> --help`

- get a glance : `crowdsec1 cscli metrics`
- see the state of installed bouncers : `crowdsec1 cscli bouncers list`
- see the active decisions(ban): `crowdsec1 cscli decisions list`
- see the alerts (discovered IP): `crowdsec1 cscli alerts list`
- see installed collections : `crowdsec1 cscli collections list` or `crowdsec1 cscli collections list --all`

## Uninstall

To uninstall the instance:

    remove-module --no-preserve crowdsec1

## Testing

Test the module using the `test-module.sh` script:


    ./test-module.sh <NODE_ADDR> ghcr.io/nethserver/crowdsec:latest

The tests are made using [Robot Framework](https://robotframework.org/)
