#!/bin/bash

# Check if a project name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

# Create the project directory and subdirectories
PROJECT_NAME="$1"
mkdir -p "$PROJECT_NAME"/{documents,figures,notebooks,raw_data,src,web}

# Create an empty README.md file
touch "$PROJECT_NAME/README.md"

echo "Project directory '$PROJECT_NAME' created successfully with subdirectories."