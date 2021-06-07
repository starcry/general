#!/bin/bash

HOST_HEALTH=$1

for i in $(aws elbv2 describe-target-groups --query TargetGroups[*].TargetGroupArn | cut -d '"' -f2 | grep -v "\[\|\]"); do
  INSTANCES=$(aws elbv2 describe-target-health --target-group-arn $i --query TargetHealthDescriptions[*].[Target.Id,TargetHealth.State] --output text | grep "$HOST_HEALTH" | cut -f1 | grep -v "\[\|\]")
  #if [ $(echo $INSTANCES | tr -dc '[:print:]') -eq 00000000]
  if [[ ! -z $INSTANCES ]]
    then echo $i $INSTANCES # | tr -dc '[:print:]' #| od -c
  fi
done
