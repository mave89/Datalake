#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Give the name of the file with all the IPs and the path of the local pem file used to ssh to the servers."
    echo "For example: ./setup_ssh.bash hosts.txt /Users/faiz/git/Datalake/faiz-openlab.pem"
    exit 1
fi

# Input file provided by the user
INPUT_FILE=$1
LOCAL_PEM_FILE=$2

# Store all the ips in an array
# REF: https://goo.gl/SWfyGr
IFS=$'\r\n' GLOBIGNORE='*' command eval 'IP_ADDRESSES=($(cat "$INPUT_FILE"))'

# Commands to run on the remote servers
USER="ubuntu"
PUB_FILE="/home/$USER/.ssh/id_rsa.pub"
CMD1="ssh-keygen -t rsa"
CMD2="cat <(echo) /home/$USER/.ssh/id_rsa.pub"
CMD3="ssh -o StrictHostKeyChecking=no -i /home/$USER/.ssh/faiz-openlab.pem"
CMD4="cat >> /home/$USER/.ssh/authorized_keys"

# Iterate through all ips
for i in "${IP_ADDRESSES[@]}"; do
    # Copy the pem file to the server
    if scp -i "$LOCAL_PEM_FILE" "$LOCAL_PEM_FILE" "$USER"@"$i":~/.ssh ; then
        echo "Successfully copied the pem file to server $i."
    else
        echo "Not able to copy the pem file to server $i."
    fi
    # ssh to the server using the pem file
    ssh -i "$LOCAL_PEM_FILE" "$USER"@"$i" bash << HERE
    # Create keys if not exists
    if [ ! -f $PUB_FILE ]; then
        if echo -ne '\n' | eval "$CMD1"; then
            echo "Successfully created ssh keys."
        else
            echo "Something went wrong with server $i."
        fi
    fi
    # Copy the public key to authorized_keys file on all the servers
    # REF: https://goo.gl/a8ddCm
    # Use a backtick to expand local variable values
    for j in ${IP_ADDRESSES[@]}; do
        if $CMD2 | $CMD3 $USER@\$j "$CMD4"; then
            echo "Successfully added pubilc key of $i to \$j."
        else
            echo "Keys exchange not successful between $i and \$j."
        fi
    done
HERE
done
echo "All servers are now setup to use passwordless ssh."
