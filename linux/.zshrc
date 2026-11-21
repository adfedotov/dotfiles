# User binaries
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""   # prompt is handled by starship

plugins=(git sudo extract colored-man-pages)
source $ZSH/oh-my-zsh.sh

# History
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY

# Colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -lah'


# Plugins (from pacman)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4c566a'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Tools
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

# nvm (pacman install), lazy-loaded on first use
_load_nvm() {
  unset -f nvm node npm npx _load_nvm 2>/dev/null
  source /usr/share/nvm/init-nvm.sh
}
for _cmd in nvm node npm npx; do
  eval "$_cmd() { _load_nvm; $_cmd \"\$@\"; }"
done
unset _cmd
