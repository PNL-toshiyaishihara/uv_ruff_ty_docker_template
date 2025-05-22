# syntax=docker/dockerfile:1

ARG PY_MAJOR_VERSION="3"
ARG PY_MINOR_VERSION="12"
ARG PY_PATCH_VERSION="4"
ARG PY_VERSION="${PY_MAJOR_VERSION}.${PY_MINOR_VERSION}.${PY_PATCH_VERSION}"

FROM python:${PY_VERSION}-slim-bookworm AS builder
WORKDIR /src

ENV UV_SYSTEM_PYTHON=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_CACHE_DIR=/root/.cache/uv \
    UV_LINK_MODE=copy
RUN --mount=from=ghcr.io/astral-sh/uv:0.4.28,source=/uv,target=/bin/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=cache,target=${UV_CACHE_DIR} \
    uv export --frozen --no-dev --format requirements-txt > requirements.txt \
    && uv pip install -r requirements.txt

### for prod
FROM python:${PY_VERSION}-slim-bookworm AS prod
ENV PYTHONUNBUFFERED=1
WORKDIR /src
COPY --from=builder /usr/local/lib/python${PY_MAJOR_VERSION}.${PY_MINOR_VERSION}/site-packages /usr/local/lib/python${PY_MAJOR_VERSION}.${PY_MINOR_VERSION}/site-packages
# ↓need to copy cli python pacakge
COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY src/ ./src/

CMD ["python","src/main.py"]