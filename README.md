# Datalake
The idea of this project is to emulate a datalake kind of an architecture. 
We'll be using Twitter APIs to pull in some data, store it in Hive tables, and use Tableau on top of it to draw some insights.

## Getting started

1. AWS - https://aws.amazon.com
2. Hadoop Distributed File System (HDFS) - https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html
3. Hive - https://hive.apache.org/
4. Tableau - https://tableau.com

An AWS accont is needed to spin up a Hadoop cluster. We'll be using this to store all our tweets on HDFS. We'll also be using Hive tables to build our database. Finally, we'll connect Tableau and our Hive database to draw some visualizations.

 
## Screenshots
WORK IN PROGRESS.

## Installation
Make sure you have the AWS access key and secret key ready with you. The first step is to install the AWS cli on your machine. 

```
sudo ./install_configure_aws_cli.bash
```

Next, let's spawn a few instances on AWS. We'll use the '''spawn_instances_aws.py' script to do this step. The "--help" flag of this script gives your more information on how to use it.

'''
python spawn_instances_aws.py --help
'''

WORK IN PROGRESS

## Contribute
WORK IN PROGRESS

## License
WORK IN PROGRESS
