#!/usr/bin/env bash
# Exercice 2 - Crée dev et active la protection de main et dev
# Usage : ./protect-branches.sh <owner>/eventhub   (gh auth login requis, droits admin)
set -euo pipefail
REPO="${1:?Usage: $0 <owner>/eventhub}"

# Création de dev depuis main si absente
if ! gh api "repos/$REPO/branches/dev" >/dev/null 2>&1; then
  SHA=$(gh api "repos/$REPO/git/ref/heads/main" --jq .object.sha)
  gh api "repos/$REPO/git/refs" -f ref=refs/heads/dev -f sha="$SHA" >/dev/null
  echo "Branche dev créée"
fi

protect() { # $1 branche, $2 approbations, $3 dismiss_stale, $4 linear
  gh api -X PUT "repos/$REPO/branches/$1/protection" \
    -H "Accept: application/vnd.github+json" --input - >/dev/null <<JSON
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": $2,
    "dismiss_stale_reviews": $3
  },
  "restrictions": null,
  "required_linear_history": $4,
  "required_conversation_resolution": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
  echo "Protection activée sur $1"
}

protect main 1 true true
protect dev 0 false false

# Branche par défaut = dev (les PR partent vers dev)
gh repo edit "$REPO" --default-branch dev --delete-branch-on-merge
echo "Vérification : https://github.com/$REPO/settings/branches  -> capture d'écran"
