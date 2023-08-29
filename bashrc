export VISUAL=vim
export EDITOR="$VISUAL"

#alias ms="minikube start --extra-config=controller-manager.HorizontalPodAutoscalerUseRESTClients=true; minikube addons enable ingress"
alias ms="minikube start; minikube addons enable ingress"

alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gdm="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit master.."
alias gs="git status"
alias gat="git ls-files --modified | xargs git add"
alias gaa="git add -u"
alias gb="git branch | grep \"*\" | cut -d ' ' -f2"
function gco() {
  local BRANCH=$(gb)
  local FUNCTION=$1
  local COMMENT="${@:2}"
  git commit -m "$FUNCTION: $BRANCH: $COMMENT"
}

alias tf="terraform"
alias tg="terragrunt"
alias tgp="tg plan"
alias tfp="tf plan -out=tf.plan"
alias tfa="tf apply tf.plan"
alias rb=". ~/.bashrc; . .bash_profile"
alias tgo="tmux new -s aidan"

alias fn="find -name $1"

alias lsd="ls -d */ | xargs du -chs | grep -v total"

alias gr="cd $(git rev-parse --show-toplevel)"
#alias gr="echo $(git rev-parse --show-toplevel)"

alias ocp="xclip -i -sel c"

alias choco="echo \"scripts/windows/iis/setup.ps1:Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))\""

alias rts="find . -not -path '*/\\.*' | xargs -I {} sed -i 's/[[:space:]]*$//' {}"

alias ppc="column -t -s, $1"

function lsak() {
  for i in $(aws iam list-users --query 'Users[*].UserName' --output text)
    do aws iam list-access-keys --user-name $i --query 'AccessKeyMetadata[*].[UserName, AccessKeyId]' --output text
  done
}

function hc() {
  COMMAND=$(history | tail -n $1 | head -n1 | awk '{$1="";print substr($0,2)}')
}

function gg() {
  local TEXT="${@:1}"
  git grep -i -n "$TEXT" -- `git rev-parse --show-toplevel`
}

function insid() {
  aws ec2 describe-instances --instance-id $1 --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,PublicIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text
}

#aws ec2 describe-instances  --query 'Reservations[*].Instances[*].[InstanceId,Placement.AvailabilityZone,InstanceType,Platform,LaunchTime,PrivateIpAddress,PublicIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text --filters 'Name=hibernation-options.configured,Values=true'

function instag() {
  if [ -z $1 ]
    then aws ec2 describe-instances  --query 'Reservations[*].Instances[*].[InstanceId,Placement.AvailabilityZone,InstanceType,Platform,LaunchTime,PrivateIpAddress,PublicIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text
  elif [ -z $2 ]
    then aws ec2 describe-instances  --query 'Reservations[*].Instances[*].[InstanceId,Placement.AvailabilityZone,InstanceType,Platform,LaunchTime,PrivateIpAddress,PublicIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text | grep -i $1
  else
    local TAG="${2:-Name}"
    local VALUE="${1:-*}"
    aws ec2 describe-instances --filter "Name=tag:$TAG,Values=$VALUE"  --query 'Reservations[*].Instances[*].[InstanceId,Placement.AvailabilityZone,InstanceType,Platform,LaunchTime,PrivateIpAddress,PublicIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text
  fi
}

function inssec() {
  local INSID=$1
  local SUMMARY=$2
  SGIDS=$(aws ec2 describe-instances --instance-ids $INSID --query 'Reservations[*].Instances[*].NetworkInterfaces[*].Groups[*].GroupId' --output text)
  printf "instance $INSID has security groups\n$SGIDS"; echo
  for i in $SGIDS; do
    echo "rules for $i"
    aws ec2 describe-security-group-rules --filters "Name=group-id,Values=$i" --query 'SecurityGroupRules[*].[IsEgress,FromPort,ToPort,CidrIpv4,Description]' --output text | \
      awk '$1 == "False"' | \
      cut -f2- | \
      sed '1i FromPort ToPort CidrIpv4 Description' | \
      column --table
    # inssec i-0cbffe08369061686 | grep -v "rules for sg-\|FromPort.*ToPort.*CidrIpv4\|instance.*i-" | grep . | awk '{print $1, $2, $3}' | sort -u | column --table
    echo
  done | grep -v "rules for sg-\|FromPort.*ToPort.*CidrIpv4\|instance.*i-" | grep . | awk '{print $1, $2, $3}' | sort -u | column --table
}


alias ssm="aws ssm start-session --target $i"

function sst() {
  IFS=$'\n'
  echo "logging you into these instances"
  NAME=$1
  instag $NAME | grep running
  INSID=$(instag $NAME | grep running | cut -f1)
  for i in $(instag $NAME | grep running); do
    echo "logging you into $i"
    ssm $(echo $i | cut -f1)
   done
}

function lssec() {
  aws secretsmanager list-secrets --query 'SecretList[].[Name,ARN]' --output text | column -t
}

function getsec() {
  for i in $(aws secretsmanager list-secrets --query 'SecretList[].[Name,ARN]' --output text | column -t | grep $1 | awk '{print $2}'); do
    echo Secret: $(echo $i | sed 's/.*://g')
    aws secretsmanager get-secret-value --secret-id $i --query 'SecretString' --output text | sed 's/\\//g' | jq | grep -v '{\|}' | sed 's/"//g;s/://g;s/,//g;s/  //g' | column -t -s ' '
    echo
  done
}

function tgf() {
  for i in $(find -name "terragrunt*" | grep -v terragrunt-cache)
    do TEMP=$(echo $i | sed 's/hcl/tf/g')
    mv $i $TEMP
    terraform fmt $TEMP
    mv $TEMP $i
  done
}

function tff() {
  for i in $(find -name "*.tf" | grep -v terragrunt-cache)
    do terraform fmt $i
  done
}

function () {
  if [ "$(uname -s)" = "Linux" ]; then
    tmux show-buffer | xclip -sel clip -i
  else
    tmux show-buffer | pbcopy
  fi
}

alias wp="kubectl get po --watch | grep $1"

alias ep="kubectl exec -it $1 /bin/sh"
alias gwr="for i in \$(git ls-files | grep \"tf$\|hcl$\|py$\|json$\|groovy$\|ts$\"); do sed -i 's/[[:space:]]\+$//' \$i; done"
alias t2s="for i in \$(git ls-files | grep \"tf$\|hcl$\"); do sed -i 's/\\t/  /g' \$i; done"
alias gba="git log | grep Author | sort | uniq -c"

function fixb() {
  gwr
  gaa
  gco fix removing trailing spaces
  t2s
  gaa
  gco fix converting tabs to spaces
  terraform fmt --recursive
  terragrunt hclfmt --recursive
  gaa
  gco fix aligning terragrunt and teraform files
}

function awsp() {
  ENV="${1:-default}"
  export AWS_PROFILE="${1:-default}"
}

function fmtbranch() {
  for i in $(find -name "*.hcl" | sed 's/\.hcl//'); do
    mv $i.hcl $i.tf
    terraform fmt $i.tf
    mv $i.tf
    $i.hcl
  done
}

function taws() {
  if [ !  -z "$1" ]
  then
    export AWS_ACCESS_KEY_ID=$1
    export AWS_SECRET_ACCESS_KEY=$2
  else
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
  fi
}

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/:(\1)/'
}

function cdr() {
  PLEVEL=$(git grep . -- `git rev-parse --show-toplevel` | sed 's/:.*//g' | head -n1 | grep -o '../' | wc -l)
  for (( i=1; i<$PLEVEL; i++ )); do cd ../; done
 }

PS1="[\$(date +%k:%M)] $(echo $PS1 | sed 's/..$//')\$(parse_git_branch)\[\033[00m\]$ "

function tflog() {
  export TF_LOG=DEBUG
  export TF_LOG_PATH=$(pwd)/log.log
}

function reni() {
  IP=$(dig +short $1 | tail -n1)
  aws ec2 describe-network-interfaces --query 'NetworkInterfaces[*].[NetworkInterfaceId,PrivateIpAddresses[*].PrivateIpAddress]' --output text | grep -B1 $IP | grep eni
}

function inspw() {
  ID=$1
  KEYPAIR=$2
  aws ec2 get-password-data --instance-id $ID --priv-launch-key $KEYPAIR
}

function sga () {
  aws ec2 describe-network-interfaces --filter Name=group-id,Values="${1:-*}" --query 'NetworkInterfaces[*].Attachment'
}

alias l53="aws route53 list-hosted-zones --query 'HostedZones[*].[Id,Name]' --output text | sed 's_.*/__g'"

#alias shzone="aws route53 list-resource-record-sets --hosted-zone-id $1 --query 'ResourceRecordSets[*].[Type,Name,AliasTarget.DNSName]' --output text | grep -v \"NS\|SOA\" | sort -u | column --table"
alias shzone="aws route53 list-resource-record-sets --hosted-zone-id $1 --query 'ResourceRecordSets[*].[Type,Name,AliasTarget.DNSName]' --output text | column --table"
#alias shzone="echo $1"

function s53() {
  local ZONES=$(l53 | grep $1 | cut -f1)
  for i in $(echo $ZONES)
  do l53 | grep $i
    aws route53 list-resource-record-sets --hosted-zone-id $i --query 'ResourceRecordSets[*].[Type,Name,AliasTarget.DNSName]' --output text | grep -v "NS\|SOA" | sort -u | column --table
  done
}

function r53() {
for i in $(l53 | cut -f1)
  do echo "Hosted Zone: $(aws route53 get-hosted-zone --id $i --query 'HostedZone.[Id,Name]' --output text | sed 's_.*/__g')"
#  aws route53 list-resource-record-sets --hosted-zone-id $i --query 'ResourceRecordSets[*].[Type,AliasTarget.DNSName]' --output text | grep -v "NS\|SOA"
  s53 $i
done | grep "Hosted Zone\|$1" | grep -B1 "$1"
}

function gc() {
  #meant for gopro mp4 footage, this should shrink it to a smaller size
  mkdir converted
  for i in $(ls *.MP4); do NAME=$(echo $i | cut -d '.' -f1); ffmpeg -i $i -vcodec libx265 -crf 28 converted/$NAME-converted.mp4; done
}

function aaws() {
  local COMMAND="$1"
  echo $COMMAND
  for i in $(grep "\[" $HOME/.aws/credentials | sed 's/\[//g;s/\]//g' | grep -v 'assume-')
    do echo "account $i"
    awsp $i
    $COMMAND
  done
}

#neovim magics
# now you can copy to clipboard with '+y'
#set clipboard+=unnamedplus
source <(kubectl completion bash)
complete -C aws_completer aws
