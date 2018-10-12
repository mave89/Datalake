#!/bin/bash

set -xe

# Prerequisites
# 1. JDK8
# 2. mvn
# 3. Add JAVA_HOME path in bashrc file
# 4. Install python setup tools
# 5. Install rpm

# cd to the Downloads directory
mkdir -p Downloads && cd Downloads

# Install JDK8
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update -y
sudo apt-get install oracle-java8-installer -y

# Setup JAVA_HOME path
sudo cat >> ~/.bashrc << EOL
JAVA_HOME=/usr/lib/jvm/java-8-oracle
EOL

# Source the bashrc file to make the changes take effect
source ~/.bashrc

# Install mvn
sudo apt-get install maven -y

# Install python setup tools
wget https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg#md5=fe1f997bc722265116870bc7919059ea
sudo sh setuptools-0.6c11-py2.7.egg

# Install rpm
sudo apt-get install rpm -y

# Download and setup Ambari 2.7.1
sudo wget -O /etc/apt/sources.list.d/ambari.list http://public-repo-1.hortonworks.com/ambari/ubuntu16/2.x/updates/2.7.1.0/ambari.list
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com B9733A7A07513CAD
sudo apt-get update -y
# Install the serevr
sudo apt-get install ambari-server -y

# Setup Ambari
sudo ambari-server setup

# Start the Ambari server
sudo ambari-server start

echo "That is it. Ambari server is installed and started."
echo "Go to SERVER_PUBLIC_IP:8080 in a web broweser and finish the rest of the installation steps."
