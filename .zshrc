# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Disable auto-setting terminal title (for tmux pane titles)
DISABLE_AUTO_TITLE="true"

# Disable marking untracked files under VCS as dirty (faster for large repos)
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins
plugins=(
  aliases
  colorize
  docker
  docker-compose
  dotnet
  git
  history
  helm
  kubectl
  vscode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# SSH agent socket (gcr-ssh-agent) — без этого SSH-сессии не наследуют
# сокет агента из графической сессии, и autossh запрашивает passphrase
# при каждом переподключении. Современный GNOME использует gcr-ssh-agent
# (socket-activated), а не gnome-keyring-daemon для SSH.
_GCR_SSH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/gcr/ssh"

# Inside tmux: sync with global env (updated on attach for mosh/ssh reconnect)
if [ -n "$TMUX" ]; then
  eval "$(tmux show-environment -s SSH_AUTH_SOCK 2>/dev/null)"
fi

# Fallback to gcr-ssh-agent if current socket is missing/invalid
if [ ! -S "$SSH_AUTH_SOCK" ] && [ -S "$_GCR_SSH_SOCK" ]; then
  export SSH_AUTH_SOCK="$_GCR_SSH_SOCK"
  [ -n "$TMUX" ] && tmux set-environment -g SSH_AUTH_SOCK "$_GCR_SSH_SOCK" 2>/dev/null
fi
unset _GCR_SSH_SOCK

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Paths
typeset -U path
export PATH="$HOME/.local/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Aliases
alias "j=just"
alias "c=xclip"
alias "v=xclip -o"

# Set time format as in bash
TIMEFMT=$'\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'
