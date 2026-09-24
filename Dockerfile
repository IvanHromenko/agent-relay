FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    RELAY_DATABASE_URL=sqlite:////data/agent-relay.db

RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml ./
COPY README.md ./
COPY *.py ./

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir uv && \
    uv sync --frozen --no-dev

RUN mkdir -p /data

EXPOSE 8000

CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
