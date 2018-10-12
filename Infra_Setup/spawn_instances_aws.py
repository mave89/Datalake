import sys
import argparse 
from argparse import RawTextHelpFormatter
import os
import json
import subprocess
from subprocess import check_output

__author__ = 'Faiz Abidi'

# Print some information on how to use this script and 
# take in arguments from the user
def inputArguments():
    parser = argparse.ArgumentParser(description=
        'This script is used to launch EC2 instances on AWS. By default, if you do not provide arguments, we\'ll use the below defult properties to spin up the instances.\n\n --image-id ami-04169656fea786776 \n\n --count 3 \n\n --instance-type t2.2xlarge \n\n --key-name faiz-openlab \n\n --security-group-ids sg-03417d82bd9571425 \n\n --subnet-id subnet-f45772af \n\n --block-device-mappings "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":100,\"DeleteOnTermination\":false}}]"', formatter_class=RawTextHelpFormatter
        )
    parser.add_argument('--image-id', type=str, help='image type to use', default='ami-04169656fea786776')
    parser.add_argument('--count', type=int, help='number of instances needed', default=3)
    parser.add_argument('--instance-type', type=str, help='type of EC2 instance to launch', default='t2.2xlarge')
    parser.add_argument('--key-name', type=str, help='your aws key', default='faiz-openlab')
    parser.add_argument('--security-group-ids', type=str, help='security group to use', default='sg-03417d82bd9571425')
    parser.add_argument('--subnet-id', type=str, help='subnet to use', default='subnet-f45772af')
    parser.add_argument('--block-device-mappings', type=int, help='size of EBS volume to attach', default=100)
    args = parser.parse_args()

    return args

# Spawn the AWS instances with the input given by the user
def spawnInstances():
    args = inputArguments()
    IMAGE_ID = args.image_id
    COUNT = args.count
    INSTANCE_TYPE = args.instance_type
    KEY_NAME = args.key_name
    SECURITY_GROUP_ID = args.security_group_ids
    SUBNET_ID = args.subnet_id
    BLOCK_DEVICE_MAPPINGS = "\"[{\\\"DeviceName\\\":\\\"/dev/sdf\\\",\\\"Ebs\\\":{\\\"VolumeSize\\\":%d,\\\"DeleteOnTermination\\\":true}}]\"" %args.block_device_mappings
    TAG_SPECIFICATIONS = "\'ResourceType=instance,Tags=[{Key=Name,Value=Datalake}]\'"

    # Command to spawn the AWS instances
    CMD1 = "aws ec2 run-instances \
    --image-id %s\
    --count %s\
    --instance-type %s\
    --key-name %s\
    --security-group-ids %s\
    --subnet-id %s\
    --block-device-mappings %s\
    --tag-specifications %s" %(IMAGE_ID, COUNT, INSTANCE_TYPE, KEY_NAME, SECURITY_GROUP_ID, \
        SUBNET_ID, BLOCK_DEVICE_MAPPINGS, TAG_SPECIFICATIONS)

    # Command to check the public IPs of the AWS instances
    CMD2 = "aws ec2 describe-instances \
        --filters \"Name=tag:Name,Values=Datalake\" \
        | grep PublicIpAddress"
    
    try:
        retcode = subprocess.call(CMD1, shell=True)
        if retcode == 0:
            print "Sucessfully spawned %d AWS instances. Use the below IPs and user \"ubuntu\" or the right user for the instance type you have spawned using your AWS key to ssh into these instances." %COUNT
            IPs = subprocess.check_output(['bash', '-c', CMD2])
            print IPs
    except:
        print "Couldn't spawn the AWS instances. Something went wrong. Please check the logs."
        sys.exit(1)

def main():
    args = inputArguments()
    spawnInstances()

if __name__ == "__main__":
    main()
