#!/bin/sh

set -ex # fail on any error & print commands as they're run
if [ "x$MANAGEPY_MIGRATE" = "xon" ]; then
	python manage.py migrate --noinput
fi
if [ "x$MANAGEPY_COLLECTSTATIC" = "xon" ]; then
	python manage.py collectstatic --noinput
fi
if [ "x$MANAGEPY_COMPRESS" = "xon" ]; then
	python manage.py compress --extension haml,html --force
fi

TYPE=${1:-casepro}
if [ "$TYPE" = "casepro" ]; then
    uwsgi --ini /casepro/uwsgi.ini
elif [ "$TYPE" = "celery" ]; then
    celery multi start casepro.celery casepro.sync -A casepro.celery:app --loglevel=INFO --logfile=/tmp/celery_log/%n%I.log --pidfile=/tmp/celery/%n.pid -Q:casepro.celery celery -Q:casepro.sync sync
elif [ "$TYPE" = "celery-beat" ]; then
    celery beat -A casepro.celery:app --workdir=/casepro --loglevel=INFO --schedule=/tmp/celerybeat-schedule
fi
