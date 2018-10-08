# Datalake
The idea of this project is to emulate a datalake kind of an architecture. 
We'll be using Twitter APIs to pull in some data, store it in Hive tables, and use Tableau on top of it to draw some insights.

## Getting started

1. AWS - https://aws.amazon.com
2. Hadoop Distributed File System (HDFS) - https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html
3. Ambari - https://ambari.apache.org/
4. Hive - https://hive.apache.org/
5. Tableau - https://tableau.com
6. Hortonworks HDP - https://docs.hortonworks.com/HDPDocuments/HDP3/HDP-3.0.1/index.html

An AWS accont is needed to spin up a Hadoop cluster. We'll be using this to store all our tweets on HDFS. We'll also be using Hive tables to build our database. Finally, we'll connect Tableau and our Hive database to draw some visualizations.

 
## Screenshots
WORK IN PROGRESS.

## Installation
Make sure you have the AWS access key and secret key ready with you. The first step is to install the AWS cli on your machine. 

```
sudo ./install_configure_aws_cli.bash
```

Next, let's spawn a few instances on AWS. We'll use the ```spawn_instances_aws.py``` script to do this step. The "--help" flag of this script gives your more information on how to use it.

```
python spawn_instances_aws.py --help
```
Once you have your instances up and running, the next step is to create a Hadoop cluster on these. We'll be using Ambari to setup our Hadoop cluster making the life of the Hadoop admin relatively easy. But the first step in doing that is to make sure that all our servers can ssh into each other without using any password.

```
./setup_ssh.sh hosts.txt /Users/faiz/Desktop/faiz-openlab.pem 
```

File hosts.txt should contain all the ip addresses of your servers that you intend to use to build a hadoop cluster.

You also need to add the (hostname, private IP) of all your servers in /etc/hosts on all your servers.

```
./appendHostnames_etcHosts.bash hosts.txt faiz-openlab.pem
```

We are good with our cluster now. The next step is to install Hadoop and for that, we'll be using open-source HDP provided by Hortonworks. 

WORK IN PROGRESS

## Contribute
WORK IN PROGRESS

## License
WORK IN PROGRESS
