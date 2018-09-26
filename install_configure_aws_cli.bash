#!/bin/bash

set -xe

# Dependencies
# 1. Pip should be installed.
# 2. Should have AWS access key and secret key ready.
# 3. Linux OS type is ubuntu.

# Helper function to show the usage of this script.
display_usage() {
	echo "This script assumes that you have pip installed. Also, please have your AWS access key and secret key ready."
	echo "We will use AWS region us-east-1 and output format type as json."
	echo "Sample usage: ./install_configure_aws_cli.bash ACCESS_KEY_ID ACCESS_KEY_VALUE"
	}

ACCESS_KEY_ID=$1
ACCESS_KEY_VALUE=$2 
REGION="us-east-1"
FORMAT="json"
CMD="echo -e \"$ACCESS_KEY_ID\n$ACCESS_KEY_VALUE\n$REGION\n$FORMAT\n\" | aws configure"

if [ $# -ne 2 ]; then
	display_usage
	exit 1
fi

# Assuming pip is already installed  
pip install awscli --upgrade --user

# Add AWS cli location to bashrc file if doesn't exists
if ! grep -q .local ~/.bashrc; then 
	echo "export PATH=~/.local/bin:\$PATH" >> ~/.bashrc
fi

# Source the bashrc file for the changes to take effect immediately
source ~/.bashrc


#echo $ACCESS_KEY_ID
#echo $ACCESS_KEY_VALUE

# Let's configure AWS
# Use eval to expand variables before executing
if eval $CMD; then
	echo "Successfully installed and configured aws cli."
else
	echo "Something went wrong. Please check the logs."
fi

