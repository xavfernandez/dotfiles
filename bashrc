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

export PATH=$HOME/.local/bin:${PATH}
export PATH=$HOME/.npm-packages/bin:${PATH}

export LIBVIRT_DEFAULT_URI="qemu:///system"

source /usr/bin/virtualenvwrapper_lazy.sh

#source <(kubectl completion bash)
#source <(helm completion bash)
#source <(minikube completion bash)
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

alias mkvirtualenv37='mkvirtualenv -p python3.7'


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

#complete -C /home/xfernandez/.local/bin/vault vault
#complete -C /usr/bin/terraform terraform
