#
# ~/.bash_profile
#

if ip a | grep -q ' 10\.135\.155'
then
    export SSMM_LOC=vc
else
    export SSMM_LOC=unknown
fi

eval $(ssh-agent)

export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass.txt

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -d $HOME/.asdf ]]
then
    . $HOME/.asdf/asdf.sh
    . $HOME/.asdf/completions/asdf.bash
fi
