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

.PHONY: start-postgres
start-postgres:
	@docker compose -f docker/docker-compose-postgres.yml up --build -d

.PHONY: stop-postgres
stop-postgres:
	@docker compose -f docker/docker-compose-postgres.yml down

.PHONY: up
up:
	@docker compose -f docker/docker-compose-postgres.yml up -d

.PHONY: down
down:
	@docker compose -f docker/docker-compose-postgres.yml down

.PHONY: dbt-ci-build
dbt-ci-build:
	@poetry run dbt build --target dev --profiles-dir profiles/

.PHONY: test
test:
	@make down
	@make up
	@make dbt-ci-build
	@make down