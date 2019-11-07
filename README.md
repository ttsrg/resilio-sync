# Resilio-sync / rslsync
> Resilio-sync uses bittorent protocol and necessary use minimum 2 hosts(peers) for working synchronization

## Sync without 2 peers



### Usage: 

- 1 Have to write variables V_PEER1 and V_PEER2 in the following script
- 2 Run script
```bash
/bin/bash sync2peers.sh
```





## Tested with:
![Ansible](https://img.shields.io/badge/ansible-2.8.6.0-green.svg)
![Resilio-sync](https://img.shields.io/badge/rslsync-2.6.3%20(1340)-green.svg)
![Ubuntu](https://img.shields.io/badge/ubuntu-16.04.6%20LTS%20(Xenial%20Xerus)-green.svg)

 ### P.S.
 - may be necessary rewrite ufw rules
 - may connect via webgui - ip_server:8888/usersync/<usersyncpass> if commented block "shared_folders" in /etc/resilio-sync/config.json
 - tail -f /var/lib/resilio-sync/sync.log
 - common variables are in playbook.yml
 - known SECRET may from webgui and storages in /etc/resilio-sync/secret.txt, when it autocreates
 - for regenerate SECRET may use same variable in "sync2peers.sh" or have to delete secret file: 
```bash
       sudo rm /etc/resilio-sync/secret.txt
```

### service works using user rslsync:

```bash

# cat /lib/systemd/system/resilio-sync.service 
[Unit]
Description=Resilio Sync service
Documentation=https://help.resilio.com
After=network.target network-online.target

[Service]
Type=forking
UMask=0002
Restart=on-failure
PermissionsStartOnly=true

User=rslsync
Group=rslsync
Environment="SYNC_USER=rslsync"
Environment="SYNC_GROUP=rslsync"

Environment="SYNC_RUN_DIR=/var/run/resilio-sync"
Environment="SYNC_LIB_DIR=/var/lib/resilio-sync"
Environment="SYNC_CONF_DIR=/etc/resilio-sync"

PIDFile=/var/run/resilio-sync/sync.pid

ExecStartPre=/bin/mkdir -p ${SYNC_RUN_DIR} ${SYNC_LIB_DIR}
ExecStartPre=/bin/chown -R ${SYNC_USER}:${SYNC_GROUP} ${SYNC_RUN_DIR} ${SYNC_LIB_DIR}
ExecStart=/usr/bin/rslsync --config ${SYNC_CONF_DIR}/config.json
ExecStartPost=/bin/sleep 1

[Install]
WantedBy=multi-user.target


```