FROM python:3.12-slim AS base

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/.venv/bin:/root/.cargo/bin:$PATH" \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PYTHON=3.12

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

FROM base AS python-deps

ARG INSTALL_DEV_DEPENDENCIES=false

COPY pyproject.toml uv.lock ./

RUN pip install uv==0.6.12 && \
    if [ "$INSTALL_DEV_DEPENDENCIES" = "true" ]; then \
        uv sync --frozen; \
    else \
        uv sync --frozen --no-dev; \
    fi

FROM base AS runtime

COPY --from=python-deps ./.venv ./.venv
ENV PATH="/.venv/bin:$PATH"

RUN useradd --create-home appuser
WORKDIR /home/appuser
COPY . .
COPY profiles/docker_profiles.yml /root/.dbt/profiles.yml

RUN dbt deps

CMD ["dbt", "build"]