import os

# import our default settings
from casepro.settings_common import *  # noqa

ALLOWED_HOSTS = ['*']

# INSTALLED_APPS = INSTALLED_APPS + ('debug_toolbar.apps.DebugToolbarConfig',)
# MIDDLEWARE_CLASSES += ('debug_toolbar.middleware.DebugToolbarMiddleware',)

DEBUG = False

ADMINS = (
   ('Ona Ops', 'techops+{}@ona.io'.format(os.getenv('CASEPRO_DOMAIN'))),
)

HOSTNAME = os.getenv('CASEPRO_DOMAIN')

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        "NAME": os.getenv('CASEPRO_PG_DB_NAME'),
        "USER": os.getenv('CASEPRO_PG_DB_USER'),
        "PASSWORD": os.getenv('CASEPRO_PG_DB_PASSWORD'),
        "HOST": os.getenv('CASEPRO_PG_DB_HOST'),
        "PORT": int(os.getenv('CASEPRO_PG_DB_PORT')),
        "ATOMIC_REQUESTS": True,
        "OPTIONS": {},
    }
}

# dash configuration
SITE_API_HOST = os.getenv('CASEPRO_SITE_API_HOST')
SITE_HOST_PATTERN = os.getenv('CASEPRO_SITE_HOST_PATTERN')

# casepro configuration
SITE_EXTERNAL_CONTACT_URL = os.getenv('CASEPRO_SITE_EXTERNAL_CONTACT_URL')
SITE_BACKEND = os.getenv('CASEPRO_SITE_BACKEND')

# timezones
USER_TIME_ZONE = os.getenv('CASEPRO_USER_TIME_ZONE')

# secret key
SECRET_KEY = os.getenv('CASEPRO_SECRET_KEY')

BROKER_URL = os.getenv('CASEPRO_BROKER_URL')

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": BROKER_URL,
        "OPTIONS": {"CLIENT_CLASS": "django_redis.client.DefaultClient"},
    }
}
