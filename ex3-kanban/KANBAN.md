# Tableau Kanban - EventHub

## Colonnes

`Backlog` → `Ready` → `In progress` → `Review` → `Done`

| Colonne     | Entrée                                    | Sortie                   |
| ----------- | ----------------------------------------- | ------------------------ |
| Backlog     | Toute nouvelle issue                      | Issue rédigée et estimée |
| Ready       | Critères d'acceptation clairs             | Quelqu'un la prend       |
| In progress | Branche `feat/<id>-...` créée             | PR ouverte vers `dev`    |
| Review      | PR ouverte                                | PR approuvée et mergée   |
| Done        | PR mergée (issue fermée via `Closes #id`) | -                        |

## 1. Créer le tableau (interface GitHub)

1. Profil GitHub > **Projects** > **New project**
2. Template **Kanban** (colonnes fournies : Backlog, Ready, In progress, In review, Done)
3. Nom : `EventHub`
4. Renommer `In review` en `Review` : menu `...` de la colonne > **Edit details**
5. **Settings > Workflows** du projet, activer :
   - _Item added to project_ → Backlog
   - _Pull request merged_ et _Item closed_ → Done
6. Noter le numéro du projet (URL `.../projects/<numero>`)

## 2. Étiquettes + issue + carte

```bash
gh auth refresh -s project
./setup-kanban.sh <owner>/eventhub <numero>
```

Le script : remplace les labels par défaut par ceux de `labels.tsv`, lie le dépôt au projet, crée l'issue, l'ajoute au tableau et la place en `Ready`.

Équivalent manuel : **Issues > Labels** pour les étiquettes, puis dans l'issue, panneau de droite **Projects** > `EventHub`, et choisir le statut.

## Captures à fournir

- Le tableau avec ses 5 colonnes et la carte
- La page **Labels**
- L'issue montrant le projet lié dans le panneau de droite
