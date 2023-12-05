FROM apache/airflow:slim-2.7.1-python3.11 as build

ENV ACCEPT_EULA=Y

USER root
RUN apt-get -qq update > /dev/null \
    && apt-get -y -qq upgrade \
    && apt-get -y -qq install libpq-dev gcc \
    && apt-get -y -qq clean \
    && apt-get -y -qq autoremove \
    && rm -rf /var/lib /var/lib/{apt,dpkg,cache,log}/ \
    && rm -rf /var/cache
USER airflow

RUN pip install --no-cache-dir psycopg2 apache-airflow-providers-cncf-kubernetes
# Airflow user in Docker image version 2.2.0+ moved to root group to be compatible with Open-Shift (https://airflow.apache.org/docs/docker-stack/entrypoint.html#allowing-arbitrary-user-to-run-the-container),
# below COPY is from official example: https://airflow.apache.org/docs/docker-stack/build.html#example-when-you-want-to-embed-dags
COPY --chown=airflow:root /airflow-dags/dags /opt/airflow/dags

ENTRYPOINT []
