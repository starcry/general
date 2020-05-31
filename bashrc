export VISUAL=vim
export EDITOR="$VISUAL"

#alias ms="minikube start --extra-config=controller-manager.HorizontalPodAutoscalerUseRESTClients=true; minikube addons enable ingress"
alias ms="minikube start; minikube addons enable ingress"

alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gdm="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit master.."
alias gs="git status"
alias gaa="git add -A"
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
alias rb=". ~/.bashrc"

function tgf() {
	for i in $(find -name "terragrunt*" | grep -v terragrunt-cache)
		do TEMP=$(echo $i | sed 's/hcl/tf/g')
		mv $i $TEMP
		terraform fmt $TEMP
		mv $TEMP $i
	done
}

#neovim magics
# now you can copy to clipboard with '+y'
set clipboard+=unnamedplus
