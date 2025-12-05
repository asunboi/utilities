# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

#aliases
alias sqme='squeue --format="%.18i %.9P %.30j %.8u %.8T %.10M %.9l %.6D %R" --me'
alias link2307="ssh asun@login00-adm -X -N -f -R 2307:localhost:2307"

function start_ijob() {
local part=${1:-shared}  # Default to 'shared' if no argument is given
srun --nodes=1 --ntasks-per-node=1 --partition="$part" --cpus-per-task=16 --time=72:00:00 --mem=72000 --pty bash
}
export -f start_ijob

function cproj() {
cp -r /gpfs/home/asun/programs/utilities/template ./${1}
}
export -f cproj

#functions
function mklj(){
cat ~/programs/utilities/basefilel > ${2}.sbatch
echo "#SBATCH --output=${1}%x_%j.out" >> ${2}.sbatch
}
export -f mklj

function mksj(){
cat ~/programs/utilities/basefiles > ${1}.sbatch
}
export -f mksj

function getReadLength(){
cat $1 | awk '$0 ~ ">" {print c; c=0; printf substr($0,2,100) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; }' | cut -f 2 > $2
}
export -f getReadLength

# Jump to project root if PROJECT_ROOT is set by direnv
root() {
  if [ -n "${PROJECT_ROOT:-}" ]; then
    cd "$PROJECT_ROOT"
  else
    echo "root: PROJECT_ROOT is not set (are you inside a direnv project?)" >&2
    return 1
  fi
}
export -f root

# Print current git commit hash (short) or a friendly message if not in a repo
ghash() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git rev-parse --short HEAD
  else
    echo "not a git repository"
  fi
}
export -f ghash

#PATHS
export PATH="$HOME/programs/UCSC:$PATH"
export PATH="$HOME/programs/utilities:$PATH"
#export PATH="$HOME/scripts/nanopore:$PATH"
#export PYTHONPATH="${PYTHONPATH}:/gpfs/home/asun/.local/lib/python3.8/site-packages/nanoplot/"
export PATH=$PATH:/gpfs/home/asun/google-cloud-sdk
export PATH="$HOME/bin:$PATH"
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
LS_COLORS=$LS_COLORS:'*.ipynb=38;5;214:' ; export LS_COLORS
#VARIABLES
export TERM=xterm-256color
export BASILISK_EXTERNAL_CONDA="/gpfs/home/asun/miniforge3"
export BASILISK_USE_SYSTEM_DIR="1"


#module load homer
#module load gcc/6.3.0
#module load seqtk
#module load seqkit
#module load mmseqs2
#module load blast

# >>> GIT >>>
#parse_git_branch() {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
#}
#export PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "
# >>> GIT >>>

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/gpfs/home/asun/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/gpfs/home/asun/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/gpfs/home/asun/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/gpfs/home/asun/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/gpfs/home/asun/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/gpfs/home/asun/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/gpfs/home/asun/google-cloud-sdk/path.bash.inc' ]; then . '/gpfs/home/asun/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/gpfs/home/asun/google-cloud-sdk/completion.bash.inc' ]; then . '/gpfs/home/asun/google-cloud-sdk/completion.bash.inc'; fi

. "$HOME/.local/bin/env"

### begin: modification to PS1 so that direnv updates conda package in project dirs
# export PS1_BASE=${PS1_BASE:-$PS1}
# # show env name if active; empty otherwise
# PS1='${CONDA_PROMPT_MODIFIER}'"$PS1_BASE"
# ### end: modification to PS1 

# --- Show active conda env once via CONDA_PROMPT_MODIFIER ---
# Save a clean baseline (strip any current conda prefix if there is one)
# : "${PS1_BASE:=${PS1#"$CONDA_PROMPT_MODIFIER"}}"

# __conda_prompt() {
#   local mod="${CONDA_PROMPT_MODIFIER-}"   # "(env) " or ""
#   PS1="${mod}${PS1_BASE}"
# }

# # Append once, without clobbering existing PROMPT_COMMAND from /etc/bashrc
# case ":$PROMPT_COMMAND:" in
#   *":__conda_prompt:"*) ;;
#   *) PROMPT_COMMAND="__conda_prompt${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
# esac

## 
#PS1='${VIRTUAL_ENV_PROMPT:+($VIRTUAL_ENV_PROMPT)}[\u@\h \W]\\$ '

export CONDA_CHANGEPS1=false

PS1='${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV)}[\u@\h \W]\\$ '


# For DirEnv
eval "$(direnv hook bash)"

