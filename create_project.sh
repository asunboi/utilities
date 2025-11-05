#!/bin/bash

# Usage: ./create_github_project.sh <project-name> [--private]
# requires gh and git > 1.8.5

if [ -z "$1" ]; then
    echo "Usage: $0 <project-name> [--private]"
    exit 1
fi

PROJECT_NAME=$1
TEMPLATE_DIR="/gpfs/home/asun/programs/utilities/template"
VISIBILITY="public"

# Check if --private flag is set
if [ "$2" == "--private" ]; then
    VISIBILITY="private"
fi

# Copy template
echo "Creating project from template..."
cp -r "$TEMPLATE_DIR" "./$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize git
echo "Initializing git repository..."
git init
git add .
git commit -m "Initial commit from template"
git branch -m main

# Create GitHub repository using gh CLI
echo "Creating GitHub repository..."
gh repo create "$PROJECT_NAME" --$VISIBILITY --source=. --push

echo "✓ Project created: $PROJECT_NAME"
echo "✓ GitHub repo: https://github.com/$(gh api user --jq .login)/$PROJECT_NAME"