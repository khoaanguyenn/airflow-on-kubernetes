# Build stage
FROM apache/airflow:slim-2.7.1-python3.11 as build

USER root
RUN apt-get -qq update \
    && apt-get -y -qq install libpq-dev gcc \
    && apt-get -y -qq clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow
RUN pip install --no-cache-dir --user psycopg2 apache-airflow-providers-cncf-kubernetes

# Final stage
FROM apache/airflow:slim-2.7.1-python3.11

USER root
RUN apt-get -qq update \
    && apt-get -y -qq install libpq-dev \
    && apt-get -y -qq clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow
# Copy installed python packages from build stage
COPY --from=build --chown=airflow:root /home/airflow/.local /home/airflow/.local

# Copy DAGs
COPY --chown=airflow:root /airflow-dags/dags /opt/airflow/dags

# Add .local/bin to PATH
ENV PATH="/home/airflow/.local/bin:${PATH}"

ENTRYPOINT []
