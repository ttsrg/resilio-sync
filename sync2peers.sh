#!/bin/bash
clear

export ANSIBLE_STDOUT_CALLBACK=debug
export ANSIBLE_GATHERING=smart

INVENTORY_FILE=ansible/inventory/stage
UFW_VARS=ansible/roles/ufw/vars/main.yml
V_PEER1=202.197.255.25  #<..ip_or_name..>
V_PEER2=104.256.76.232    #<..ip_or_name..>
V_DIR=/srv/sync/       #<share_dir>
#V_SECRET=$(cat ~/.ssh/resilio-sync/secret | head -1) #AES 128 may redefine uncommenting , creates   rslsync --generate-secret
V_USERSYNCPASS=$(cat ~/.ssh/resilio-sync/usersyncpass | head -1)

echo -e "[peer]\n$V_PEER1"  >  inventory/stage
echo "yes" | ansible-playbook -i inventory/stage  playbook.yml  \
-e v_peer1=$V_PEER1 -e v_peer2=$V_PEER2 -e v_dir=$V_DIR -e v_usersyncpass=$V_USERSYNCPASS \
--tags=common --tags=peer --tags=secret_fetch --tags=ufw

#-e v_secret=$V_SECRET
#--tags=ufw



echo -e "[peer]\n$V_PEER2"  >  inventory/stage
echo "yes" | ansible-playbook -i inventory/stage  playbook.yml  \
-e v_peer1=$V_PEER2 -e v_peer2=$V_PEER1 -e v_dir=$V_DIR \
--tags=common --tags=peer  -t copy_fetch --tags=ufw \
-e v_secret=$(cat /tmp/secret.txt | head -1)

#--tags=common 
#--tags=ufw



# -vvvv
