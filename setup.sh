
# setup miniforge from https://github.com/conda-forge/miniforge
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash "Miniforge3-$(uname)-$(uname -m).sh" -b -p "$HOME/miniforge3"
rm "Miniforge3-$(uname)-$(uname -m).sh"

