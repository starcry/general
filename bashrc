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
alias tgo="tmux -vv new -s aidan"

alias ssm="aws ssm start-session --target $i"

alias lsd="ls -d */ | xargs du -chs | grep -v total"

alias gr="cd $(git rev-parse --show-toplevel)"

alias ocp="xclip -i -sel c"

alias choco="echo \"scripts/windows/iis/setup.ps1:Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))\""

function gg() {
  git grep -n $1 -- `git rev-parse --show-toplevel`
}

function insid() {
	aws ec2 describe-instances --instance-id $1 --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,State.Name]' --output text
}

function instag() {
	local TAG="${2:-Name}"
	aws ec2 describe-instances --filter "Name=tag:$TAG,Values=$1" --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' --output text
}

function testytest() {
  echo "hello world" > /tmp/testytest
  cat /tmp/testytest
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

PS1="[\$(date +%k:%M)] $PS1"

#neovim magics
# now you can copy to clipboard with '+y'
#set clipboard+=unnamedplus


