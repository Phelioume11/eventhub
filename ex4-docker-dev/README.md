# EventHub - Environnement Docker

## Stages du Dockerfile

| Stage       | Rôle                                          | Utilisé par               |
| ----------- | --------------------------------------------- | ------------------------- |
| `base`      | `node:24-alpine`, `WORKDIR /app`              | tous                      |
| `deps`      | `npm ci` (dépendances dev incluses)           | `dev`, `build`            |
| `dev`       | `nodemon` + `tsx` : redémarre à chaque modif  | `docker-compose.yml`      |
| `build`     | `tsc` → `dist/`                               | `prod`                    |
| `prod-deps` | `npm ci --omit=dev`                           | `prod`                    |
| `prod`      | `dist/` + deps prod, user `node`, healthcheck | `docker-compose.prod.yml` |

## Dev (hot-reload)

```bash
cp .env.example .env
docker compose up --build
```

- API : http://localhost:3000/health et http://localhost:3000/events
- Adminer : http://localhost:8080 (serveur `db`, identifiants du `.env`)
- Modifier un fichier de `src/` : l'API redémarre (`[nodemon] restarting due to changes...` dans les logs)

Volumes :

- `.:/app` : code monté, base du hot-reload
- `/app/node_modules` : volume anonyme, évite que le dossier local écrase les modules installés dans l'image
- `pgdata` : données Postgres persistées entre redémarrages
- `./db/init.sql` : création de la table `events` au premier démarrage

Après un changement de `package.json` : `docker compose up --build -V` (`-V` recrée le volume `node_modules`).

## Prod

```bash
docker compose -f docker-compose.prod.yml up --build
docker images eventhub-api   # comparer la taille avec l'image dev
```

## Tests rapides

```bash
curl localhost:3000/health
curl -X POST localhost:3000/events -H 'Content-Type: application/json' \
  -d '{"title":"Meetup DevOps","startsAt":"2026-11-15T18:00:00Z"}'
curl localhost:3000/events
```

## Commandes utiles

```bash
docker compose logs -f api
docker compose exec db psql -U eventhub -d eventhub
docker compose down        # stop (données conservées)
docker compose down -v     # stop + suppression des volumes
```
