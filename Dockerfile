FROM python:3.6-slim-buster

LABEL maintainer="techops@ona.io"

# Create a group and user for CasePro:
ARG CASEPRO_USER=casepro
RUN groupadd -r ${CASEPRO_USER} \
  && useradd -r -g ${CASEPRO_USER} ${CASEPRO_USER}

ARG CASEPRO_VERSION

ENV CASEPRO_VERSION=${CASEPRO_VERSION} \
  # python:
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PYTHONDONTWRITEBYTECODE=1

# Install run deps:
RUN set -ex \
  && RUN_DEPS=" \
  postgresql-client \
  wget \
  node-less \
  coffeescript \
  " \
  && apt-get update \
  && apt-get install -y --no-install-recommends $RUN_DEPS \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /casepro

# Download CasePro release:
RUN echo "Downloading CasePro ${CASEPRO_VERSION} from https://github.com/rapidpro/casepro/archive/${CASEPRO_VERSION}.tar.gz" \
  && wget -O casepro.tar.gz "https://github.com/rapidpro/casepro/archive/${CASEPRO_VERSION}.tar.gz" \
  && tar -xf casepro.tar.gz --strip-components=1 \
  && rm casepro.tar.gz

COPY requirements.txt /requirements.txt

# Install build deps:
RUN set -ex \
  && BUILD_DEPS=" \
    build-essential \
    libpq-dev \
  " \
  && apt-get update \
  && apt-get install -y --no-install-recommends $BUILD_DEPS \
  && pip install --no-cache-dir -r /requirements.txt \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $BUILD_DEPS \
  && rm -rf /var/lib/apt/lists/*

COPY settings.py /casepro/casepro/
COPY uwsgi.ini /casepro/

RUN mkdir /casepro/sitestatic

COPY docker-entrypoint.sh /

# Set up proper permissions:
RUN chmod +x '/docker-entrypoint.sh' \
  && chown ${CASEPRO_USER}:${CASEPRO_USER} -R /casepro

EXPOSE 3031

ENV DJANGO_SETTINGS_MODULE=casepro.settings

USER ${CASEPRO_USER}

ENTRYPOINT [ "/docker-entrypoint.sh" ]
