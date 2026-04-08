#!/bin/bash
#SBATCH --output="tunnel.log"
#SBATCH --job-name="vscode_tunnel2"
#SBATCH --time=72:00:00     # walltime
#SBATCH --cpus-per-task=16  # number of cores
#SBATCH --mem=0
#SBATCH --partition=highmem
#SBATCH --exclusive

set -euo pipefail

usage() {
  echo "Usage: sbatch $(basename "$0") <tunnel_id>"
  echo "Example: sbatch $(basename "$0") 2"
  echo "Optional: export TUNNEL_PARTITION=<partition> for logging/validation (default: highmem)"
  exit 1
}

if [[ $# -ne 1 ]]; then
  usage
fi

ID="$1"
if ! [[ "${ID}" =~ ^[0-9]+$ ]]; then
  echo "Error: tunnel_id must be an integer." >&2
  usage
fi

if [[ -z "${SLURM_JOB_ID:-}" ]]; then
  echo "Error: this script must be launched with sbatch." >&2
  exit 1
fi

PARTITION="${TUNNEL_PARTITION:-${SLURM_JOB_PARTITION:-highmem}}"
TUNNEL_NAME="vscode_tunnel${ID}"

if [[ -n "${SLURM_JOB_PARTITION:-}" && -n "${TUNNEL_PARTITION:-}" && "${TUNNEL_PARTITION}" != "${SLURM_JOB_PARTITION}" ]]; then
  echo "Warning: TUNNEL_PARTITION=${TUNNEL_PARTITION} but allocated partition is ${SLURM_JOB_PARTITION}." >&2
fi

# Make the running job discoverable by local ssh aliases like hpcx1/hpcx2.
scontrol update JobId="${SLURM_JOB_ID}" JobName="${TUNNEL_NAME}"

# Find open port and advertise it in the SLURM job comment.
PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
scontrol update JobId="${SLURM_JOB_ID}" Comment="${PORT}"

NODE="${SLURMD_NODENAME:-${HOSTNAME:-unknown}}"
echo "Tunnel name: ${TUNNEL_NAME}"
echo "Partition: ${PARTITION}"
echo "Node: ${NODE}"
echo "Port: ${PORT}"
echo "Starting sshd on port ${PORT}"

exec /usr/sbin/sshd -D -p "${PORT}" -f /dev/null -h "${HOME}/.ssh/id_ed25519"
