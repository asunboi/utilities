Currently my PS1 looks like this
`\[\](base) [\u@\h \W]\$ \[\]`

And even when I use direnv to activate conda environments, my PS1 still displays as root. 

I want to update my PS1 when i enter certain directories that have direnv enabled. My .envrc activates a conda environment, and I want my PS1 to reflect this updated conda environment.

https://github.com/direnv/direnv/wiki/PS1

fixed in ~/.bashrc by doing
```
export CONDA_CHANGEPS1=false
PS1='${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV)}[\u@\h \W]\\$ '
```

