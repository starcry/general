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
	BRANCH=$(gb)
	FUNCTION=$1
	COMMENT="${@:2}"
	git commit -m "$FUNCTION: $BRANCH: $COMMENT"
}

alias tf="terraform"
alias tg="terragrunt"
alias tgp="tg plan"
alias tfp="tf plan -out=tf.plan"
alias tfa="tf apply tf.plan"
alias rb=". ~/.bashrc"
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
  git grep -i -n $1 -- `git rev-parse --show-toplevel`
}

function insid() {
	aws ec2 describe-instances --instance-id $1 --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,PublicIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text
}

function instag() {
	local TAG="${2:-Name}"
	local VALUE="${1:-*}"
	aws ec2 describe-instances --filter "Name=tag:$TAG,Values=$VALUE"  --query 'Reservations[*].Instances[*].[InstanceId,Placement.AvailabilityZone,InstanceType,Platform,LaunchTime,PrivateIpAddress,PublicIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text
}

function inssec() {
  local INSID=$1
  local SUMMARY=$2
  SGIDS=$(aws ec2 describe-instances --instance-ids $INSID --query 'Reservations[*].Instances[*].NetworkInterfaces[*].Groups[*].GroupId' --output text)
  echo "instance $INSID has security groups\n$SGIDS"
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
  NAME="'*$1*'"
  instag $NAME | grep running
  INSID=$(instag $NAME | grep running | cut -f1)
  for i in $(instag $NAME | grep running); do
    echo "logging you into $i"
    ssm $(echo $i | cut -f1)
   done
}

function lins() {
  aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,PublicIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text | column -t
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

alias tcp="tmux show-buffer | xclip -sel clip -i"

function awsp() {
	export AWS_PROFILE=$1
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


#neovim magics
# now you can copy to clipboard with '+y'
#set clipboard+=unnamedplus


