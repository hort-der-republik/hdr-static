FROM ghcr.io/acdh-oeaw/devcontainer-frontend:24

ENV LC_ALL=C.UTF-8 \
    ANT_OPTS="-Dfile.encoding=UTF-8"

RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-17-jdk-headless \
        ant \
        curl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

ENV UV_PYTHON_INSTALL_DIR=/opt/uv/python \
    UV_PYTHON_BIN_DIR=/usr/local/bin \
    UV_PYTHON_PREFERENCE=only-managed

RUN uv python install 3.13 --default  && chown -R node:node /opt/uv
