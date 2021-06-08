#!/bin/bash

HOST_HEALTH=$1

for i in $(aws elbv2 describe-target-groups --query TargetGroups[*].TargetGroupArn | cut -d '"' -f2 | grep -v "\[\|\]"); do
  case $HOST_HEALTH in
    healthy) INSTANCES=$(aws elbv2 describe-target-health --target-group-arn $i --query TargetHealthDescriptions[*].[Target.Id,TargetHealth.State] --output text | grep -v unhealthy | cut -f1 | grep -v "\[\|\]") ;;
    unhealthy) INSTANCES=$(aws elbv2 describe-target-health --target-group-arn $i --query TargetHealthDescriptions[*].[Target.Id,TargetHealth.State] --output text | grep unhealthy | cut -f1 | grep -v "\[\|\]") ;;
    *) INSTANCES=$(aws elbv2 describe-target-health --target-group-arn $i --query TargetHealthDescriptions[*].[Target.Id,TargetHealth.State] --output text | cut -f1 | grep -v "\[\|\]") ;;
  esac
  if [[ ! -z $INSTANCES ]]
    then echo $i $INSTANCES
  fi
done
