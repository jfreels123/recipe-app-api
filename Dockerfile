FROM python:3.9-alpine3.13
LABEL maintainer="jfreels123"

ENV PYTHONUNBUFFERED 1

# Create the app directory in the image
RUN mkdir /app
WORKDIR /app

# Copy only the requirements file first to leverage caching
COPY ./requirements.txt /app/requirements.txt
COPY requirements.dev.txt /tmp/requirements.dev.txt
# Install dependencies

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /app/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

# Copy the rest of the application code
COPY ./app /app

EXPOSE 8000

# Set the user to run the application
USER django-user
