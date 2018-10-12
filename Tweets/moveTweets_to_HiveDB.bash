#!/bin/bash

set -e

display_usage() {
    echo "
        Dependencies:

        1. Need to have pyhive installed - https://pypi.org/project/PyHive/
        2. An up-and-running Hadoop cluster with Hive installed

        Description:

        This script is used to create a Hive database. It assumes that the HIVE_USER 
        and HIVE_PASSOWRD is setup in the .bashrc file.

        It also takes an argument to the CSV file containing the tweets to bulk load 
        our Hive DB with its data. Please make sure that the csv file is located
        on the node running hiveserver2.

        Usage: ./moveTweets_to_HiveDB.bash /Data/donaldtrump-tweets.csv
        "
    }

CSV_FILE=$1
echo $CSV_FILE

if [ $# -ne 1 ]; then
    display_usage
    exit 1
fi

HIVE_USER=$HIVE_USER
HIVE_PASSWORD=$HIVE_PASSWORD

# Create a database and load tweets into it
if echo -e "$HIVE_USER\n$HIVE_PASSWORD\n" | \
    hive -e "
            DROP DATABASE IF EXISTS Datalake CASCADE;
            CREATE DATABASE Datalake;
            CREATE TABLE Datalake.Tweets (
                    tweet_date STRING,
                    tweet_id BIGINT,
                    tweet_text STRING,
                    tweet_meta_result_type STRING,
                    tweet_language STRING,
                    tweet_user_id BIGINT,
                    tweet_url STRING,
                    tweet_user_name STRING,
                    tweet_user_screen_name STRING,
                    tweet_user_location STRING,
                    tweet_user_friends_count BIGINT,
                    tweet_retweet STRING,
                    tweet_retweet_count BIGINT,
                    tweet_followers_count BIGINT)
            COMMENT 'Data from CSV file.' 
            ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
            STORED AS TEXTFILE;
            "; then
    echo "Successfully created a Hive database."
else
    echo "Database creation failed. Please check the logs."
    exit 1
fi
  
# Bulk load the tweets into this database
if echo -e "$HIVE_USER\n$HIVE_PASSWORD\n" | \
    hive -e "
            USE Datalake;
            LOAD DATA LOCAL INPATH '$CSV_FILE' INTO TABLE Tweets;
            "; then
    echo "Successfully loaded all the tweets into a Hive database called Datalake and table called Tweets."
else
    echo "Not able to load tweets into the Hive database. Please check the logs."
fi

echo "All done! It's time to draw some analytics on top of this data."
