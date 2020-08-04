function symlink {
    if [[ ! -f "$3" ]]; then
        echo "Installing $1..."
        ln -s "$2" "$3"
    fi
}

symlink "zshrc" "$PWD/zshrc" "$HOME/.zshrc"
symlink "p10k" "$PWD/p10k.zsh" "$HOME/.p10k.zsh"
symlink "zshrc_path" "$PWD/zshrc_path" "$HOME/.zshrc_path"
symlink "zshrc_alias" "$PWD/zshrc_alias" "$HOME/.zshrc_alias"
symlink "zshrc_util" "$PWD/zshrc_util" "$HOME/.zshrc_util"

if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
    echo "Installing zinit"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi
