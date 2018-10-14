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


## Downloading tweets

It's time to download some tweets now. The python script ```downloadTweets.py``` has a ```--help``` tag that you can use to see your options. But if you don't provide any, it will use the hashtag "#donaldtrump" and download tweets containing that hashtag.

```
python Tweets/downloadTweets.py --help
```

In our case, we downloaded any many free tweets as possible containing ```#donaldtrump```. CSV file ```donaldtrump-tweets.csv``` has all the data we collected.

Next step is to put this data into a Hive table. The advantage of doing this is that Hive ultimately stores data onto HDFS that provides scalability, fault tolerance, high availability, etc..

```
./Tweets/moveTweets_to_HiveDB.bash /home/ubuntu/git/Datalake/Data/donaldtrump-tweets.csv 
``` 
The screenshot below shows table tweets holding our data. It has 14 columns eaching saving a part of tweet data that we pulled using the Twitter API. 

![alt text](https://github.com/faizabidi/Datalake/blob/master/Screenshots/Hive_DB.png)

Next step is to connect our Hiveserver2 with Tableau. You need to have Tableau installed and also have the corresponding ODBC drivers from Hortonworks. In my case, I downloaded the OSX drivers from Hortonwork's website - https://hortonworks.com/downloads/#data-platform. Once you have the driver, you can connect using user ```ubuntu``` or whatever user you created and your ```pem``` file. Then extract the schema and the table in Tableau and you'll get all your data loaded as shown below.

![alt text](https://github.com/faizabidi/Datalake/blob/master/Screenshots/Tableau_Data_Load.png)

## Visualizations

Finally, we did some basic analysis on top of this data using Tableau. Below are 4 links to the visualizations we drew. Note that all this data is only for the period between Oct 4 to Oct 13, 2018 since I was using the free version of Twitter API that limits how much data you can scrape for free. 

1. Number of tweets posted each day having the hashtag donaldtrump - https://goo.gl/C5Cb7a

2. Number of tweets posted in different languages - https://goo.gl/Wm8D9v

3. Users who posted >= 15 tweets with the hashtag donaldtrump - https://goo.gl/449VT6

4. List of popular users having >= 100k followers - https://goo.gl/CqvxMB 


## License
MIT License

Copyright (c) [2018] [Faiz Abidi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.