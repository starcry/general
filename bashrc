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
alias tfp="tf plan"
alias rb=". ~/.bashrc"
alias tgo="tmux -vv new -s aidan"

alias ssm="aws ssm start-session --target $i"

alias lsd="du -chs $(ls -d */)"

alias gr="cd $(git rev-parse --show-toplevel)"

alias ocp="xclip -i -sel c"

function gg() {
  echo $1
  git grep $1 $(pwd | cut -d '/' -f1,2,3,4,5)
}

function insid() {
	aws ec2 describe-instances --instance-id $1 --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,State.Name]' --output text
}

function instag() {
	local TAG="${2:-Name}"
  echo $TAG
  echo $1
	echo "aws ec2 describe-instances --filter 'Name=tag:$TAG,Values=$1' --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,State.Name,Tags[?Key==\`Name\`]| [0].Value]' --output text"
	TAGID=$(aws ec2 describe-instances --filter 'Name=tag:$TAG,Values=$1' --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text)
	echo $TAGID
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

#doing this in tmux breaks things for some reason
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

PS1="[\$(date +%k:%M)] $PS1"

#neovim magics
# now you can copy to clipboard with '+y'
#set clipboard+=unnamedplus


