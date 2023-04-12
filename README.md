# Beatrix

__Prepare:__

* Get GitHub personal access token: https://github.com/settings/tokens?type=beta
* Generate SECRET_KEY_BASE with `mix phx.gen.secret`
* Paste token and secret_key in docker-compose.prod.yaml environment section:

```yaml
environment:
    ...
    SECRET_KEY_BASE: MY_SECRET_KEY_BASE
    GITHUB_TOKEN: MY_GITHUB_TOKEN
    ...
```

__Start containers with app + postgresdb:__

`docker compose -f docker-compose.prod.yaml up -d --build`

__Migrate:__

`docker compose -f docker-compose.prod.yaml exec app bash -c /app/bin/migrate`

__Start parsing awesome list now:__

`docker compose -f docker-compose.prod.yaml exec app bash -c /app/bin/parse`
