https://direnv.net/
https://direnv.net/docs/installation.html

figuring how to set up direnv
`curl -sfL https://direnv.net/install.sh | bash`

Add the following line at the end of the ~/.bashrc file:

eval "$(direnv hook bash)"
Make sure it appears even after rvm, git-prompt and other shell extensions that manipulate the prompt.

Set up direnv for configs, added a section in utilities called best practices to port over all my stuff from problems & solutions. 

I want to have a function that installs the above, then 

imports in ~/.bashrc by doing
```
export CONDA_CHANGEPS1=false
PS1='${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV)}[\u@\h \W]\\$ '
```

I want to have a function that automatically adds this to a directory, specifying which conda env. 

PATH_add bin
# # optional: auto-activate venv/conda here
# # layout python       # (direnv’s venv)
# # or: source .venv/bin/activate

eval "$("$HOME/miniforge3/bin/conda" shell.bash hook)" 
conda activate "$HOME/miniforge3/envs/perturbench"

# Set project root to the directory where this .envrc lives
export PROJECT_ROOT="$(pwd)"

# Update PS1 to include the active conda environment
if [ -z "${VIRTUAL_ENV_PROMPT:-}" ] && [ -n "${CONDA_DEFAULT_ENV}" ]; then
    VIRTUAL_ENV_PROMPT=$(basename "${CONDA_DEFAULT_ENV}")
fi
export VIRTUAL_ENV_PROMPT

