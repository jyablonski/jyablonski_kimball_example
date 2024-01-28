FROM python:3.11-slim as base

ENV POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_NO_INTERACTION=1

FROM base AS python-deps

COPY pyproject.toml .
COPY poetry.lock .

RUN pip install poetry
RUN poetry install --no-root --without dev

FROM base AS runtime

COPY --from=python-deps ./.venv ./.venv
ENV PATH="/.venv/bin:$PATH"

RUN useradd --create-home appuser
WORKDIR /home/appuser
COPY . .
COPY profiles/docker_profiles.yml /root/.dbt/profiles.yml

RUN dbt deps

CMD ["dbt", "build"]