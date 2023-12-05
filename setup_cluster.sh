## BUILD & UPLOAD AIRFLOW IMAGE
docker build . --tag airflow_first_dag:0.1.0 --compress
docker tag docker.io/library/airflow_first_dag:0.1.0 localhost:5001/airflow_first_dag:0.1.0
docker push localhost:5001/airflow_first_dag:0.1.0

## FETCH LATEST HELM CHART VERSION AND INSTALL AIRFLOW
helm upgrade --install airflow helm-chart --namespace default --values helm-chart/values.yaml

##
echo "Running the below command to port-forward Airflow UI ✨"
echo "kubectl port-forward svc/airflow-webserver-svc 8080:8080 -n default"