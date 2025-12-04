# TechLift Store

Containerized Rails app with Active Storage, Stripe checkout, and Admin panel.

## Run locally with Docker

Prereqs: Docker + Docker Compose.

1) Copy env template and set secrets:
```bash
cp .env.docker.example .env.docker
# edit .env.docker to set SECRET_KEY_BASE, RAILS_MASTER_KEY (if using credentials), and AWS_* if you want S3
```

2) Build and boot:
```bash
docker compose up --build
```
This starts PostgreSQL and the Rails app on http://localhost:3000.

3) Seed the database (includes categories/products with images):
```bash
docker compose run --rm web ./bin/rails db:prepare db:seed
```

Notes:
- To use S3 for Active Storage, set `ACTIVE_STORAGE_SERVICE=amazon` and AWS_* vars in `.env.docker`.
- SSL redirects are disabled in Docker by default via `DISABLE_FORCE_SSL=true`.
- App/log/tmp/storage are volume-mounted locally for easy inspection.
