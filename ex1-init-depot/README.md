# Exercice 1 - Initialisation du dépôt

Bases qualité du dépôt : `.gitignore`, conventions de commit, hooks Git (Husky + lint-staged + commitlint).

## Installation

```bash
git clone https://github.com/Phelioume11/eventhub.git
cd eventhub/ex1-init-depot
npm install   # installe les outils et active les hooks pour tout le dépôt
```

## Conventions de commit

Le projet suit la spécification [Conventional Commits 1.0.0](https://www.conventionalcommits.org/fr/v1.0.0/). Chaque message est vérifié automatiquement par `commitlint` avant d'être accepté.

### Format

```
<type>(<scope optionnel>): <description>

[corps optionnel]

[footer(s) optionnel(s)]
```

- **type** : nature du changement (liste ci-dessous), en minuscules.
- **scope** : partie du projet concernée, entre parenthèses (`api`, `front`, `docker`, `ci`, `docs`, `deps`).
- **description** : résumé à l'impératif, en minuscules, sans point final, 72 caractères maximum.
- **corps** : le pourquoi du changement, séparé du titre par une ligne vide.
- **footer** : références (`Refs: #12`, `Closes: #12`) ou `BREAKING CHANGE: ...`.

### Types autorisés

| Type       | Usage                                               | Impact SemVer |
| ---------- | --------------------------------------------------- | ------------- |
| `feat`     | Nouvelle fonctionnalité                             | MINOR         |
| `fix`      | Correction de bug                                   | PATCH         |
| `docs`     | Documentation uniquement                            | -             |
| `style`    | Formatage, sans changement de logique               | -             |
| `refactor` | Restructuration sans nouvelle fonctionnalité ni fix | -             |
| `perf`     | Amélioration de performance                         | -             |
| `test`     | Ajout ou modification de tests                      | -             |
| `build`    | Système de build, dépendances                       | -             |
| `ci`       | Configuration CI/CD                                 | -             |
| `chore`    | Maintenance diverse (outillage, config)             | -             |
| `revert`   | Annulation d'un commit précédent                    | -             |

Un changement cassant (MAJOR) se signale par un `!` après le type/scope **ou** par un footer `BREAKING CHANGE:` (en majuscules).

### Exemples

```
feat(api): ajouter la création d'événement
fix(front): corriger l'affichage des dates en UTC
docs: compléter la section installation
chore(deps): mettre à jour express en 5.2.1
feat(api)!: renommer le champ date en startAt

BREAKING CHANGE: le champ `date` n'existe plus, utiliser `startAt`.
```

Refusés : `update`, `Fix bug`, `feat: Ajout.`, `wip`.

## Hooks Git (Husky + lint-staged + commitlint)

| Hook         | Action                                                                                                              |
| ------------ | ------------------------------------------------------------------------------------------------------------------- |
| `pre-commit` | `lint-staged` : ESLint + Prettier sur `*.{ts,tsx,js}`, Prettier sur `*.{json,md,yml}` (fichiers indexés uniquement) |
| `commit-msg` | `commitlint` : refuse tout message non conforme à Conventional Commits                                              |

Fichiers concernés (dans ce dossier) : `.husky/`, `commitlint.config.js`, `lint-staged.config.js`, `eslint.config.js`, `.prettierrc.json`. Les hooks s'appliquent aux commits de **tout le dépôt** (tous les exercices).

Contournement exceptionnel (déconseillé) : `git commit --no-verify`.
