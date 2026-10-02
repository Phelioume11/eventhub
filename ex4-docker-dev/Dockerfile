# syntax=docker/dockerfile:1
ARG NODE_VERSION=24

# ---------- base : image commune ----------
FROM node:${NODE_VERSION}-alpine AS base
WORKDIR /app

# ---------- deps : toutes les dépendances (dev incluses) ----------
FROM base AS deps
COPY package.json package-lock.json ./
RUN npm ci

# ---------- dev : hot-reload (code monté en volume par compose) ----------
FROM deps AS dev
ENV NODE_ENV=development
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]

# ---------- build : compilation TypeScript ----------
FROM deps AS build
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

# ---------- prod-deps : dépendances de production uniquement ----------
FROM base AS prod-deps
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

# ---------- prod : image finale minimale, utilisateur non-root ----------
FROM base AS prod
ENV NODE_ENV=production
COPY --chown=node:node package.json ./
COPY --from=prod-deps --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/dist ./dist
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "dist/index.js"]
