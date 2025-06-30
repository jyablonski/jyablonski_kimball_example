.PHONY: up
up:
	@docker compose -f docker/docker-compose-postgres.yml up --build -d

.PHONY: dbt-ci-build
dbt-ci-build:
	@uv run dbt build --target dev --profiles-dir profiles/

.PHONY: docker-build
docker-build:
	@docker-compose -f docker/docker-compose-local.yml build

# exit as soon as dbt finsihes
# only see logs from dbt
.PHONY: test
test:
	@docker compose -f docker/docker-compose-local.yml down
	@docker compose -f docker/docker-compose-local.yml up --exit-code-from dbt_runner --attach dbt_runner

.PHONY: down
down:
	@docker compose -f docker/docker-compose-local.yml down

.PHONY: compare-coverage
compare-coverage:
	@make up
	@uv run dbt deps
	@uv run dbt build --target dev --profiles-dir profiles/
	@uv run dbt docs generate --target dev --profiles-dir profiles/
	@uv run dbt-coverage compute doc --cov-report coverage-doc.json
	@uv run dbt-coverage compare coverage-doc.json coverage-prod.json
	@make down