## Description

This repository contains configuration for webhook service to controll bhyve virtual machines via vm-bhyve.
For more informations please refer to documentation of these services:
https://github.com/adnanh/webhook
https://github.com/churchers/vm-bhyve 

Note: It requires forked version of vm-bhyve until this PR is merged: https://github.com/churchers/vm-bhyve/pull/262

## Installation
```
pkg install webhook gotty jo jq bash dnsmasq gnu-ipcalc
mkdir -p /opt/runhyve
git clone https://github.com/runhyve/vm-bhyve.git /opt/runhyve/vm-bhyve
git clone https://gitlab.com/runhyve/vm-webhooks.git /opt/runhyve/vm-webhooks
chmod +x /opt/runhyve/vm-bhyve/vm
cd /opt/runhyve/vm-webhooks
ln -s /opt/runhyve/vm-webhooks/vm-webhooks.json /usr/local/etc/vm-webhooks.json
echo 'webhook_enable="YES"' >> /etc/rc.conf
echo 'webhook_conf="/usr/local/etc/vm-webhooks.json"' >> /etc/rc.conf
echo 'webhook_options="-urlprefix vm -ip 127.0.0.1 -port 9090"' >> /etc/rc.conf
echo 'webhook_user="root"' >> /etc/rc.conf
echo 'dnsmasq_enable="YES"' >> /etc/rc.conf
echo 'conf-dir=/vms/.config/dnsmasq/,*.conf' > /usr/local/etc/rc.d/dnsmasq.conf
echo 'include "/zroot/vm/.config/pf-nat.conf"' > /etc/pf.conf
touch /zroot/vm/.config/pf-nat.conf
echo 'pf_enable="YES"' >> /etc/rc.conf
service pf start
service webhook start
```

Note: Before exposing webhook service to the world please secure it properly.

## Usage

### Create Virtual Machine
```
$ jo -p system=freebsd plan=1C-1GB-50HDD name=webhook-vm image=FreeBSD-11.2-RELEASE-amd64.raw | \
curl -s -X POST http://localhost:9090/vm/create -H 'Content-Type: application/json' -d @-
{"status": "creating"}
```

### Start Virtual Machine
```
$ jo -p name=webhook-vm | curl -s -X POST http://localhost:9090/vm/start -H 'Content-Type: application/json' -d @-
{"status": "starting"}
```

### Connect to serial console 

Random port and credentials will be generated on hypervisor and gotty instance will be started. It will wait for connection for 120 seconds.

```
$ jo -p name=webhook-vm | curl -s -X POST http://localhost:9090/vm/console -H 'Content-Type: application/json' -d @- | jq '.'
{
  "port": "1021",
  "user": "y99sf1cjKNHn",
  "password": "7M83IPmXeGyo0Fbx7FmMstepfdAvwvCD"
}
```

This will allow you to connect to serial console with web browser: http://localhost:1021/

Note: by default gotty works without TLS.

### Cloud-init metadata server

Install dependencies:
`pkg install python3 py36-pip py36-virtualenv libvirt`
Clone project:
`git clone https://github.com/sjjf/md_server /opt/runhyve/md_server`
Install it:
```
virtualenvi-3.6 /opt/runhve/md_server_virtualenv
source /opt/runhyve/md_server_virtualenv/bin/activate
pip install bottle libvirt-python
cd /opt/runhyve/md_server
python setup.py install
ifconfig igb0 inet 169.254.169.254/32 add
mdserver &
```

If you want to use md_server within your home network then additional route should be pushed with DHCP.
It can be done with dnsmasq:
`
dhcp-option=121,169.254.169.254,<IP of host with md_server>
`
