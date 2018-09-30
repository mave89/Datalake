'''
1. Make this file define a function to show its usage - DONE
2. This script assumes that all keys and secrets are set in the environment - DONE
3. It will use the tweepy library - https://github.com/tweepy/tweepy
4. Get tweets from Twitter and store in a HIVE table on HDFS.
5. Things that can be done with this data include
a) #tweets by day
b) Think more
'''

import sys
import argparse 
import os
import tweepy
import json

__author__ = 'Faiz Abidi'

# Print some information on how to use this script and take in arguments
def inputArguments():
    parser = argparse.ArgumentParser(description=
        '\
        This script is used to pull in tweets since 2018-09-01 using some \
        hashtag. If you do not provide any of the 5 arguments needed, this \
        script will assume that the hashtag to search is #huricaneflorence \
        and will look for 4 environment variables:  CONSUMER_KEY, \
        CONSUMER_SECRET, ACCESS_TOKEN, and ACCESS_TOKEN_SECRET. Make sure you \
        have them in your .bashrc file or something equivalent.'
        )
    parser.add_argument('--hashtag', type=str, help='the hashtag to search')
    parser.add_argument('--consumerKey', type=str, help='your Twitter account\'s consumer key.')
    parser.add_argument('--consumerSecret', type=str, help='your Twitter account\'s consumer secret.')
    parser.add_argument('--accessToken', type=str, help='your Twitter account\'s access token.')
    parser.add_argument('--accessSecret', type=str, help='your Twitter account\'s access token secret.')
    args = parser.parse_args()

    return args

# Check the arguments passed to the script. If keys and access tokens are not
# passed, check the environment variables
def inspectArguments():
    args = inputArguments()

    hashtag = args.hashtag
    consumerKey = args.consumerKey
    consumerSecret = args.consumerSecret
    accessToken = args.accessToken
    accessSecret = args.accessSecret

    if hashtag is None:
        hashtag = "#huricaneflorence"
    else:
        hashtag = "#" + hashtag

    if consumerKey is None:
        consumerKey = os.environ.get('CONSUMER_KEY')

    if consumerSecret is None:
        consumerSecret = os.environ.get('CONSUMER_SECRET')

    if accessToken is None:
        accessToken = os.environ.get('ACCESS_TOKEN')

    if accessSecret is None:
        accessSecret = os.environ.get('ACCESS_TOKEN_SECRET')

    if (consumerKey is None) or (consumerSecret is None) or (accessToken is None)\
        or (accessSecret is None):
        print('You have not provided one or more of the arguments needed to run this script.\
            \nPlease run this script with the --help flag to see your options.')
        sys.exit(1)
   
    arguments_list = [hashtag, consumerKey, consumerSecret, accessToken, accessSecret]

    return arguments_list

def searchTweets(arguments_list):
    HASHTAG = arguments_list[0]
    CONSUMER_KEY = arguments_list[1]
    CONSUMER_SECRET = arguments_list[2]
    ACCESS_TOKEN = arguments_list[3]
    ACCESS_TOKEN_SECRET = arguments_list[4]

    print HASHTAG

    auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
    auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
    api = tweepy.API(auth,wait_on_rate_limit=True)

    for tweet in tweepy.Cursor(api.search, 
                    q=HASHTAG, 
                    count=100, 
                    since="2018-09-01").items():
        
        # Get the json part
        tweet = json.dumps(tweet._json)
        tweet = json.loads(tweet)
        
        # We only need selected parts of the json
        tweet_date = tweet['created_at']
        tweet_id = tweet['id']
        tweet_text = tweet['text'].encode('UTF-8')
        tweet_url = tweet['entities']['media'][0]['url']
        tweet_result_type = tweet['metadata']['result_type']
        tweet_language = tweet['metadata']['iso_language_code']
        tweet_user_id = tweet['user']['id']
        tweet_user_screen_name = tweet['user']['screen_name']
        tweet_user_location = tweet['user']['location']
        
        break
        #print "\n*****************\n"'''

def main():
    args = inputArguments()
    arguments_list = inspectArguments()
    searchTweets(arguments_list)
    
if __name__ == "__main__":
    main()
