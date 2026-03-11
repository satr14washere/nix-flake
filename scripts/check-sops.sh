#!/usr/bin/env bash
# Pre-commit hook: block commits containing unencrypted sops secret files.
# Install with: ln -sf ../../scripts/check-sops.sh .git/hooks/pre-commit

set -euo pipefail

staged_secrets=$(git diff --cached --name-only --diff-filter=ACM -- 'secrets/*.yaml' 'secrets/*.yml' 'secrets/*.json')

if [ -z "$staged_secrets" ]; then
    exit 0
fi

failed=0

for file in $staged_secrets; do
    # sops-encrypted YAML/JSON files always contain a top-level "sops" key with metadata
    if ! git show ":$file" | grep -q '"sops"\|sops:'; then
        echo "ERROR: $file is not encrypted with sops! Encrypt it first:"
        echo "       sops $file"
        echo
        echo "hint: bypass with: git commit --no-verify"
        failed=1
    fi
done

if [ "$failed" -ne 0 ]; then
    echo ""
    echo "Commit aborted. Encrypt secret files before committing."
    exit 1
fi