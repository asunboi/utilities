when i work in certain directories, I want to have certain functions/scripts callable from command line. for example, if I were to work in dir1, with the subdirectory+file src/train.py, I want to be able to call train in cli, but if i have another directory dir2 with the same subdirectory structure and scripts, I want this to be different from the src/train.py in dir1.
```
“bin/ shim” + per-project PATH (fastest)

Give each project its own tiny CLI wrapper and add that folder to PATH only when you’re in that project.

1) In each project, add a wrapper

<project>/
├─ bin/
│  └─ train
└─ src/train.py

bin/train

#!/usr/bin/env bash
set -euo pipefail
# forward all CLI args to your script
exec python "$(dirname "$0")/../src/train.py" "$@"

chmod +x bin/train

2) Auto-add bin/ to PATH when you cd into the project
	•	Easiest: use direnv (recommended)
	•	Create .envrc at project root:

PATH_add bin
# optional: auto-activate venv/conda here
# layout python       # (direnv’s venv)
# or: source .venv/bin/activate

	•	Run: direnv allow

Now, in dir1/ you can run train … and it executes dir1/bin/train. In dir2/, train resolves to dir2/bin/train. No global conflicts.

Not using direnv? Manually export PATH="$PWD/bin:$PATH" while working in that repo.

Pros: zero packaging, works for any script; Cons: needs direnv (or manual PATH).
```

what is a shim?
```
A shim is a tiny compatibility wrapper that sits between you and a real program or API so you can call it in a convenient or consistent way.

In software, shims are used to:
	•	Expose a command name: e.g., a small script named train that calls python src/train.py "$@".
	•	Redirect to the right version/env: tools like conda, pipx, nvm, pyenv place shims on your PATH that forward to the active environment’s binary.
	•	Smooth API differences: a thin layer that adapts an old interface to a new one (like a “polyfill” in JS).

Not the same as:
	•	Symlink: just points to another file.
	•	Proxy: intermediates network traffic.
	•	Stub: placeholder that may do nothing.

(Name comes from mechanical shims: thin spacers that make parts fit.)
```

what does `set -euo pipefail` mean
```
set -euo pipefail is a common “make bash stricter” line. It flips on three safety switches:

- -e (**errexit**): exit immediately if any simple command returns a non-zero status.
    
    _Exceptions:_ it won’t exit inside if/while tests, after a !, or in commands that are part of cmd1 || cmd2 / cmd1 && cmd2.
    
- -u (**nounset**): treat **unset variables** as errors (use "${var:-default}" if a default is OK).
    
- -o pipefail: in a **pipeline**, return the **first failing command’s** status (not just the last one).
    
    Without this, grep foo file | head -n1 would look “successful” even if grep failed, because head exited 0.
```

what does `exec python "$(dirname "$0")/../src/train.py" "$@"` do
```
What each part does
	•	exec → replace the current shell process with the Python process (no extra wrapper left running; signals/exit code pass through).
	•	python → run the Python interpreter found on your PATH (e.g., your conda env).
	•	$(dirname "$0")/../src/train.py → build a path to src/train.py relative to the shim’s file location:
	•	"$0" is the path of this shim script.
	•	dirname "$0" is the shim’s directory.
	•	../src/train.py moves up one dir, into src/.
	•	"$@" → forward all original CLI arguments exactly as given (properly quoted).
```

what is $0
```
$0 is the zeroth positional parameter in a POSIX shell (bash, zsh, sh). It expands to the name/path used to invoke the current program
```

what is .envrc, is it direnv specific?
```
Yep.
```

what does rc mean in this context?
```
In this context, rc stands for “run commands” (historically “runcom”). Files ending in rc are startup/config scripts that a program reads and executes to set itself up.
```

using direnv vs using conda env config vars

```
Conda allows the definition of environment-specific variables that are automatically set when a particular conda environment is activated and unset when it is deactivated. This functionality is useful for managing project-specific configurations, paths to libraries, or other settings without affecting the global system environment.
```

the conda environment variable is actually a variable, and not something that I can assign functions to. 