# Filamentory

Webapp for keeping an inventory of 3D printing filament spools.

## Stack

- Ruby on Rails
- Postgres
- Admin UI: Trestle
- Authentication: Devise (via `trestle-auth`)

## Development

```bash
bundle install
bin/rails db:create db:migrate
bin/rails db:seed
bin/rails server
```

Visit `http://localhost:3000/admin`.

The seed creates an initial user. Override via env vars:
`SEED_ADMIN_EMAIL` and `SEED_ADMIN_PASSWORD`.

## Domain Model

- `Brand` → `Product`
- `Material` → `Product`
- `Variant` → `Product`
- `Product` → `Filament`
- `Filament` → `Spool`

Spools track `gross_weight_grams` and auto-calculate `remaining_weight_grams`.
