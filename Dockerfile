FROM python:3.7-alpine
LABEL maintainer="Victor Medoma<victor.medina@globant.com>"

RUN apk update && apk add bash \
	&&  apk add --virtual \
		build-dependencies \
		build-base \
		gcc wget git curl \
		libffi libffi-dev cython \
		py3-cffi freetds freetds-dev \
		krb5-libs krb5-dev libsasl \
		libpq openssl-dev mysql-dev postgresql-dev \
	&& adduser -h /opt/airflow -s /bin/bash -D airflow

RUN pip install pytz pyOpenSSL ndg-httpsclient pyasn1 'redis==3.2'
RUN pip install 'apache-airflow[postgres,aws,celery,devel,password,redis,ssh]==1.10.10'

USER airflow
WORKDIR /opt/airflow
COPY script/entrypoint.sh .
COPY config/airflow.cfg .

EXPOSE 8080 5555 8793

ENTRYPOINT ["/opt/airflow/entrypoint.sh"]
CMD ["webserver"]