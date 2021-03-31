#!/bin/bash

IFS=$'\n'
#aws ec2 describe-images --owners self  --output text --query 'Images[*].[ImageId,Name]' | cut -d '"' -f2 | grep "-"
#cat /tmp/AMI_DATA
for i in $(aws ec2 describe-images --owners self  --output text --query 'Images[*].[ImageId,Name]'); do
  AMI_ID=$(echo $i | cut -f1)
  if [[ $(aws ec2 describe-instances --filters "Name=image-id,Values=$AMI_ID" --query 'Reservations[*].Instances[*].[ImageId]' --output text) ]]; then
  print
  else
    echo $i >> amis
  fi
done
