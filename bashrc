#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export VISUAL="vim"
set -o vi

# Make fzf use ripgrep
export FZF_DEFAULT_COMMAND='rg --files'

export GOPATH=~/go
export PATH=$HOME/.local/bin:${PATH}
export PATH=$HOME/.npm-packages/bin:${PATH}

export LIBVIRT_DEFAULT_URI="qemu:///system"
export TILLER_NAMESPACE=gitlab-ci

source ~/.local/bin/virtualenvwrapper_lazy.sh

source <(kubectl completion bash)
source <(helm completion bash)
#source <(minikube completion bash)
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

alias mkvirtualenv2='mkvirtualenv -p python2'
alias mkvirtualenv37='mkvirtualenv -p python3.7'
alias mktmpenv2='mktmpenv -p python2'


alias vpn_up='sudo ipsec up bluevpn'
alias vpn_down='sudo ipsec down bluevpn'
alias vpn_reup='sudo ipsec down bluevpn && sudo ipsec up bluevpn'

alias main_tmux='tmux -f ~/.tmux/app.conf attach'
alias eks_login='aws-adfs login --profile BCS-PROD-READONLY --adfs-host sts.blue-solutions.com'


#export PGHOST=localhost
#export PGUSER=$USER
export PGHOST=integration.local
export PGUSER=postgres
export PAGER=less


work () {
    workon ${PWD##*/}
}

complete -C /home/xfernandez/.local/bin/vault vault

complete -C /usr/bin/terraform terraform
