#!/bin/bash

# This script adds the hostnames and IPs of all the servers in the clusters to each other's /etc/hosts file.

set -e

if [ $# -ne 2 ]; then
    echo "Give the name of the file with all the IPs of the servers in your cliuster and the pem file to ssh into them."
    echo "For example: ./appendHostnames_etcHosts.bash hosts.txt faiz-openlab.pem"
    exit 1
fi

# Input file provided by the user
HOSTS=$1
PEM_FILE=$2
USER="ubuntu"

CMD="\$(hostname -I)\$(hostname)"

echo $CMD

# Store all the ips in an array
IFS=$'\r\n' GLOBIGNORE='*' command eval 'IP_ADDRESSES=($(cat "$HOSTS"))'

# Iterate through all ips
for i in "${IP_ADDRESSES[@]}"; do
    VALUE+=$(ssh -i "$PEM_FILE" "$USER"@"$i" "echo $CMD")"\n";
    echo -e "$VALUE"
done

#echo -e $VALUE

# We need to append this VALUE to all the /etc/hosts file on all the servers
for i in "${IP_ADDRESSES[@]}"; do
    ssh -i "$PEM_FILE" "$USER"@"$i" << HERE
    if echo -e "$VALUE" | sudo tee --append /etc/hosts; then
        echo "Successfully added to /etc/hosts file."
    else
        echo "Something went wrong. Couldn't add entries to /etc/hosts file. Please check the logs."
    fi
HERE
done
