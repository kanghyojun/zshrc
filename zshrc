[[ -o interactive ]] || return

set -o vi

if command -v nvim >/dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

PS1="%~
 %> "

zstyle ':completion:*' menu select

# { ================== dvcs info
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'
# ================== dvcs info }

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history

if [[ -f ~/.zinit/bin/zinit.zsh ]]; then
    source ~/.zinit/bin/zinit.zsh

    zinit ice wait as'completion' id-as'git-completion'
    zinit snippet https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh

    zinit ice wait blockf atpull'zinit creinstall -q .'
    zinit light zsh-users/zsh-completions
    zinit ice wait atload'_zsh_autosuggest_start'
    zinit light zsh-users/zsh-autosuggestions
    zinit ice wait
    zinit light zsh-users/zsh-history-substring-search
    zinit ice wait atinit'zpcompinit; zpcdreplay'
    zinit light zsh-users/zsh-syntax-highlighting

    zinit ice wait pick".kubectl_aliases"
    zinit light ahmetb/kubectl-aliases
    zinit light-mode wait has"helm" for \
        id-as"helm-completion" \
        as"completion" \
        atclone"helm completion zsh > _helm" \
        atpull"%atclone" \
        run-atpull \
            zdharma/null
fi
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi

if command -v pyenv >/dev/null; then
    eval "$(pyenv init -)"
fi

if command -v nodenv >/dev/null; then
    eval "$(nodenv init -)"
fi

zmodload -i zsh/complist
# keybinding
export KEYTIMEOUT=1
bindkey \^U backward-kill-line
bindkey "^?" backward-delete-char
bindkey -M menuselect '^[[Z' reverse-menu-complete

# local settings
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
