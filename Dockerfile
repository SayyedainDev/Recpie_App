FROM python:3.9-alpine3.13
LABEL maintainer="Sayyedain"

# Fix typo: Corrected 'PYTHONBUFFERD' to 'PYTHONUNBUFFERED'
ENV PYTHONUNBUFFERED=1

# Copy dependencies file
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy application code
COPY ./app /app

# Set working directory
WORKDIR /app

# Expose port 8000
EXPOSE 8000

ARG DEV=false  # Fix spacing issue

# Install dependencies inside a virtual environment
RUN apk add --update --no-cache \
        postgresql-client \
        build-base \
        postgresql-dev \
        musl-dev && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp && \
    apk del build-base postgresql-dev musl-dev

# Create a non-root user
RUN adduser -D django-user

# Set the virtual environment as default
ENV PATH="/py/bin:$PATH"

# Switch to non-root user
USER django-user
