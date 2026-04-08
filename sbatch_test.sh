#!/bin/bash

PARTS=(gpu alphafold)

for p in "${PARTS[@]}"; do
  echo "Testing partition: $p"
  srun -p "$p" \
       --nodes=1 \
       --cpus-per-task=16 \
       --mem=128G \
       --time=72:00:00 \
       --gres=gpu:1 \
       --test-only true && \
    echo "  ✔ OK on $p" || \
    echo "  ✖ NOT allowed on $p"
done