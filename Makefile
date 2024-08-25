.PHONY: bump-patch
bump-patch:
	@bump2version patch
	@git push --tags
	@git push

.PHONY: bump-minor
bump-minor:
	@bump2version minor
	@git push --tags
	@git push

.PHONY: bump-major
bump-major:
	@bump2version major
	@git push --tags
	@git push

.PHONY: up
up:
	@docker compose -f docker/docker-compose-postgres.yml up --build -d

.PHONY: dbt-ci-build
dbt-ci-build:
	@poetry run dbt build --target dev --profiles-dir profiles/

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
	@poetry run dbt build --target dev
	@poetry run dbt docs generate
	@poetry run dbt-coverage compute doc --cov-report coverage-doc.json
	@poetry run dbt-coverage compare coverage-doc.json coverage-prod.json
	@make down