# Text editor
export EDITOR=nvim
export VISUAL="$EDITOR"
# Yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
alias yazi="yy"
# Git
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gwip="git add . && git commit -m wip && git push"
alias gdb="git checkout master && git branch --no-color | grep -v master | xargs git branch -d"
alias gc="git restore . && git clean -df && git reset --hard && git clean -f && git checkout --"
alias gch="git reset --soft master"
alias gi="git update-index --skip-worktree $1"
alias gir="git update-index --no-skip-worktree $1"
alias gundo="git reset --soft 'HEAD^'"
function gcom () git add . && git commit -m $1 && git push
function grebase () git rebase -i HEAD~$1
parse_git_branch() {  
 local branch=""
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  local git_status=$(git status --porcelain 2>/dev/null)
  if [[ -n "$branch" ]]; then
    REMOTE_BRANCH=$(git branch -r | grep -n origin/${branch})
    UNSTAGED_FILES=$(git status -s | wc -l | xargs) 
    if [[ "$REMOTE_BRANCH" == "" ]]; then
      UNPUSHED_COMMITS=0
    else
      UNPUSHED_COMMITS=$(git rev-list --count ${branch}...origin/${branch} | xargs)
    fi
    if [[ "$UNSTAGED_FILES" -eq 0 ]]; then
      UNSTAGED_FILES_STATUS=""
    else
      UNSTAGED_FILES_STATUS=±${UNSTAGED_FILES}
    fi
    if [[ "$UNPUSHED_COMMITS" -eq 0 ]]; then
      UNPUSHED_COMMITS_STATUS=""
    else
      UNPUSHED_COMMITS_STATUS=↑${UNPUSHED_COMMITS}
    fi
    branch="%F{blue}git(${branch})${UNSTAGED_FILES_STATUS}${UNPUSHED_COMMITS_STATUS}%F{reset}"
  fi
  echo "$branch"
}
update_prompt() {
    line_old='/home/oliver'
    line_new='~'
    LOCATION=$(pwd)
    LOCATION="${LOCATION/$line_old/$line_new}"
    PS1="%F{magenta}${LOCATION}%F{reset} $(parse_git_branch) "
}
precmd_functions+=(update_prompt)
update_prompt

# Python
alias python="python3"

# Misc
alias obsidian="/usr/local/bin/Obsidian.AppImage &"
alias rc="nvim ~/.zshrc"
alias rrc="source ~/.zshrc"
alias ls="ls -FGha"

# Shell cursor movement
bindkey ";9C" forward-word
bindkey ";9D" backward-word

# Autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Syntax highlighting
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

