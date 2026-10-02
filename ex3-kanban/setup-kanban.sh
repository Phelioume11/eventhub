#!/usr/bin/env bash
# Exercice 3 - Étiquettes + issue liée au tableau Kanban
# Usage : ./setup-kanban.sh <owner>/eventhub <numero_projet>
# Prérequis : gh auth refresh -s project ; jq installé ; projet créé (voir KANBAN.md)
set -euo pipefail
REPO="${1:?Usage: $0 <owner>/eventhub <numero_projet>}"
PROJECT="${2:?numero du projet manquant}"
OWNER="${REPO%%/*}"

# 1. Étiquettes personnalisées (supprime les labels par défaut inutiles)
for l in "good first issue" "help wanted" "invalid" "question" "wontfix" "duplicate"; do
  gh label delete "$l" -R "$REPO" --yes 2>/dev/null || true
done
while IFS=$'\t' read -r name color desc; do
  gh label create "$name" -R "$REPO" --color "$color" --description "$desc" --force
done < labels.tsv

# 2. Lier le dépôt au projet
gh project link "$PROJECT" --owner "$OWNER" --repo "$REPO"

# 3. Créer l'issue
URL=$(gh issue create -R "$REPO" \
  --title "Mettre en place l'environnement Docker de dev (hot-reload)" \
  --label "type: devops" --label "priority: high" --label "area: api" \
  --assignee "@me" \
  --body "## Objectif
Développer EventHub en conteneur avec rechargement à chaud.

## Critères d'acceptation
- [ ] Dockerfile multistage (dev / build / prod)
- [ ] docker-compose avec volumes (code monté, données Postgres persistées)
- [ ] Modification d'un fichier \`src/\` = redémarrage auto de l'API
- [ ] README mis à jour")
echo "Issue : $URL"

# 4. Ajouter l'issue au tableau (= carte) et la placer en Ready
ITEM_ID=$(gh project item-add "$PROJECT" --owner "$OWNER" --url "$URL" --format json --jq .id)
PROJECT_ID=$(gh project view "$PROJECT" --owner "$OWNER" --format json --jq .id)
FIELDS=$(gh project field-list "$PROJECT" --owner "$OWNER" --format json)
STATUS_ID=$(jq -r '.fields[] | select(.name=="Status") | .id' <<<"$FIELDS")
READY_ID=$(jq -r '.fields[] | select(.name=="Status") | .options[] | select(.name=="Ready") | .id' <<<"$FIELDS")
gh project item-edit --id "$ITEM_ID" --project-id "$PROJECT_ID" \
  --field-id "$STATUS_ID" --single-select-option-id "$READY_ID"
echo "Carte placée dans la colonne Ready -> capture d'écran du tableau"
