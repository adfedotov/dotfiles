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

# nvm (pacman install)
# Put the default node on PATH eagerly (cheap glob, no nvm.sh), so node/npm/npx
# are real binaries — works in non-interactive shells and Claude Code's shell
# snapshots. Only `nvm` itself is lazy-loaded, via a self-contained stub
# (no helper function: snapshots drop _-prefixed functions → infinite recursion).
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
if [[ -r $NVM_DIR/alias/default ]]; then
  _nvm_bin=( $NVM_DIR/versions/node/v${$(<$NVM_DIR/alias/default)#v}*/bin(N/nOn[1]) )
  (( $#_nvm_bin )) && export PATH="$_nvm_bin[1]:$PATH"
  unset _nvm_bin
fi
nvm() {
  unset -f nvm
  source /usr/share/nvm/init-nvm.sh
  nvm "$@"
}

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  ":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
