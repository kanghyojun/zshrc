# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

    zinit light-mode wait has"helm" for \
        id-as"helm-completion" \
        as"completion" \
        atclone"helm completion zsh > _helm" \
        atpull"%atclone" \
        run-atpull \
            zdharma/null
    zinit light-mode wait has"kubectl" for \
        id-as"kubectl-completion" \
        as"completion" \
        atclone"kubectl completion zsh > _kubectl" \
        atpull"%atclone" \
        run-atpull \
            zdharma/null

    zinit ice depth=1; zinit light romkatv/powerlevel10k
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

if command -v direnv >/dev/null; then
    eval "$(direnv hook zsh)"
fi

zmodload -i zsh/complist
# keybinding
export KEYTIMEOUT=1
bindkey \^U backward-kill-line
bindkey "^?" backward-delete-char
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey \^y autosuggest-accept
bindkey '^R' history-incremental-search-backward

# local settings
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export FZF_DEFAULT_COMMAND="rg -l \"\""
