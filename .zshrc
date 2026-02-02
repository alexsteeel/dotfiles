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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Paths
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias "j=just"
alias "c=xclip"
alias "v=xclip -o"

# Set time format as in bash
TIMEFMT=$'\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

# Ghostty shell integration
if [[ -n "${GHOSTTY_RESOURCES_DIR}" ]]; then
    source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# Disable oh-my-zsh title management (for tmux pane titles)
add-zsh-hook -d precmd omz_termsupport_precmd
add-zsh-hook -d preexec omz_termsupport_preexec
add-zsh-hook -d chpwd omz_termsupport_cwd
