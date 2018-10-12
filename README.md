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
sudo ./Infra_Setup/install_configure_aws_cli.bash 
```

Next, let's spawn a few instances on AWS. We'll use the ```spawn_instances_aws.py``` script to do this step. The "--help" flag of this script gives your more information on how to use it.

```
python Infra_Setup/spawn_instances_aws.py --help
```
Once you have your instances up and running, the next step is to create a Hadoop cluster on these. We'll be using Ambari to setup our Hadoop cluster making the life of the Hadoop admin relatively easy. But the first step in doing that is to make sure that all our servers can ssh into each other without using any password.

```
./Infra_Setup/setup_ssh.sh /Users/faiz/Desktop/faiz-openlab.pem 
```

File hosts.txt should contain all the IP addresses of your servers that you intend to use to build a Hadoop cluster.

You also need to add the (hostname, private IP) of all your servers in /etc/hosts file on all your servers.

```
./Infra_Setup/appendHostnames.bash Infra_Setup/hosts.txt faiz-openlab.pem
```

We are good with our cluster now. The next step is to install Hadoop and for that, we'll be using open-source HDP provided by Hortonworks. 

ssh to any one of the servers that you want to assign as the master node and install Ambari server on it.gggg

```
./Infra_Setup/installAmbari.bash
```

The above script is interactive and you'll be asked several questions during the installation. Once the installation is finshed, point your broweser to this server's IP like SERVER_PUBLIC_IP:8080 and you'll be presented with a GUI that you can use to setup your Hadoop cluster. In my setup, I installed datanode and nodemanagers on two servers while keeping all the master services on my master node. I installed only the bare minimum things needed for my Datalake project that include HDFS, YARN, MapReduce2, ZooKeeper, Tez, and Hive in my cluster. 

1. Ambari server - http://204.236.207.193:8080
2. NameNode - http://204.236.207.193:50070
3. Resource manager - http://204.236.207.193:8088/cluster
4. Job history server - http://52.91.33.10:19888/jobhistory

It's time to download some tweets now. The python script ```downloadTweets.py``` has a ```--help``` tag that you can use to see your options. But if you don't provide any, it will use the hashtag "#donaldtrump" and download tweets containing that hashtag.

```
python Tweets/downloadTweets.py --help
```

In our case, we downloaded any many free tweets as possible containing ```#donaldtrump```. CSV file ```donaldtrump-tweets.csv``` has all the data we collected.

Next step is to put this data into a Hive table. The advantage of doing this is that Hive ultimately stores data onto HDFS that provides scalability, fault tolerance, high availability, etc..

```
./Tweets/moveTweets_to_HiveDB.bash /home/ubuntu/git/Datalake/Data/donaldtrump-tweets.csv 
``` 

WORK IN PROGRESS

## Contribute
WORK IN PROGRESS

## License
WORK IN PROGRESS
