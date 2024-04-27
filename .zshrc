WHITE=255
BLUE=31
GREEN=40
RESET="normalcol"

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%b'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

# Set current directory
update_path () {
  if [ $1 ]; then
    echo "$PWD"
  else
    if [[ "$PWD" == "$HOME" ]]; then
      echo "~"
    else
      PATH=$(echo "$PWD" | sed -e 's|'"$HOME"'||g')
      # TODO: Add special characters to match the path correct ([-+_.]+ === /my-project/test).
      REGEX='^(\/[-+_.a-zA-Z0-9]+\/[-+_.a-zA-Z0-9]+)(.*)(\/[-+_.a-zA-Z0-9]+\/[-+_.a-zA-Z0-9]+)$'

      if [[ $PATH =~ $REGEX ]]; then
        if [ ${#match[2]} -ge 1 ]; then
          echo "$match[1]/...$match[3]"
        else
          echo "$PATH"
        fi
      else
        echo "$PATH"
      fi
    fi
  fi
}

# Shortcut to return full project path [alt + p]
show_path () {
  update_path "full" && zle reset-prompt
}
zle -N show_path
bindkey 'π' show_path

# Set branch name
# If no branch exists, return empty string
set_branch () {
  BRANCH="${vcs_info_msg_0_}"
  if [ ${#BRANCH} -ge 1 ]; then
    echo "$(echo -e "%K{${BLUE}}%F{${WHITE}} /${BRANCH} %K{${RESET}}") "
  else
    echo ""
  fi
}

# PROMPT for user, path and branch
PROMPT='%F{${WHITE}}%n@%m%F{${BLUE}}[ $(update_path) $(set_branch)%F{${GREEN}}$%F{${RESET}} '