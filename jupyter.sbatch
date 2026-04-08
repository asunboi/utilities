#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=100GB
#SBATCH --time=1:00:00
#SBATCH --export=ALL

module purge
#module load python
port=1234
ssh -N -f -R $port:localhost:$port asun@login03-adm
jupyter lab --no-browser --port $port
