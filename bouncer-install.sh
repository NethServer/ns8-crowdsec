#!/bin/bash

#
# Copyright (C) 2022 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# to install : curl https://raw.githubusercontent.com/stephdl/ns8-crowdsec/initialWork/bouncer-install.sh | bash
set -e
source /etc/os-release

echo "Install the bouncer:"
if [[ "${PLATFORM_ID}" == "platform:el9" ]] ; then
    if dnf list --installed crowdsec-firewall-bouncer-iptables; then
        echo "crowdsec-firewall-bouncer-iptables is already installed"
        exit 0
    fi
    curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.rpm.sh | sudo bash
    dnf install -y crowdsec-firewall-bouncer-iptables
elif [[ "${ID}" == "debian"]]; then
    if dpkg -l crowdsec-firewall-bouncer-iptables; then
        echo "crowdsec-firewall-bouncer-iptables already installed"
        exit 0
    fi
    curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
    apt-get update
    apt-get -y install crowdsec-firewall-bouncer-iptables
else
    echo "The platform is not compatible, we exit"
    exit 0
fi

echo "Create IPSET (ipv4/ipv6) in Firewalld"
firewall-cmd --permanent --new-ipset=crowdsec6-blacklists --type=hash:net --option="timeout=0" --option="maxelem=150000"
firewall-cmd --permanent --new-ipset=crowdsec-blacklists --type=hash:net --option="timeout=0" --option="maxelem=150000"
firewall-cmd --permanent --zone=drop --add-source=ipset:crowdsec-blacklists
firewall-cmd --permanent --zone=drop --add-source=ipset:crowdsec6-blacklists

echo "Restart firewalld"
systemctl restart firewalld



echo ""
echo "register the bouncer to crowdsec container and retrieve the api_key : "
echo "    podman exec -ti crowdsec1 cscli bouncers add <bouncer_name>"
echo ""
echo "update bouncer configuration with mode,URL,key (/etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml)"
echo "    mode: ipset"
echo "    api_url: http://127.0.0.1:8080/"
echo "    api_key: c14a204e5a602d1f53567d299ad14a0a"
echo ""
echo "start the bouncer: "
echo "    systemctl enable --now crowdsec-firewall-bouncer"
