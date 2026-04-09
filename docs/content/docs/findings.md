---
title: Lessons Learned & Findings
---

# Lessons Learned & Findings

Setting up Airflow on Kubernetes involves several moving parts. Here are the key findings and best practices identified during the development of this project.

## 1. Local Development with KinD and Registries

One of the biggest hurdles in local Kubernetes development is getting your local images into the cluster.

- **Finding**: Simply building an image locally isn't enough; the Kubernetes nodes (which are Docker containers in KinD) need to be able to "pull" that image.
- **Solution**: Setting up a dedicated local registry container and connecting it to the KinD network is the most robust way. Using a `LocalRegistryHosting` ConfigMap helps Kubernetes understand where to find the local registry.

## 2. Advantages of the KubernetesExecutor

While the CeleryExecutor is popular, the **KubernetesExecutor** is often a better fit for Kubernetes-native environments.

- **Isolation**: We found that running tasks in separate pods prevents "dependency hell" where different DAGs might require conflicting library versions.
- **Resource Management**: You can specify exact CPU and memory requests/limits for each task via the `executor_config`, allowing for much better cluster utilization.
- **Zero Idle Costs**: Since pods are created on-demand and destroyed after completion, you don't have worker nodes sitting idle when no tasks are running.

## 3. Multi-stage Docker Builds

Airflow images can easily become bloated (over 1GB).

- **Finding**: Build-time dependencies like `gcc`, `libpq-dev`, and `python3-dev` are only needed during the `pip install` phase.
- **Optimization**: Using a multi-stage Dockerfile based on `apache/airflow:slim` allows us to compile dependencies in a "build" stage and only copy the resulting site-packages into the final runtime image. This significantly reduces image size and speeds up pod startup times.

## 4. Standardizing Database Connections

- **Standard**: Always use the `postgresql+psycopg2://` scheme for Airflow metadata database connections.
- **Security**: For production-ready setups, sensitive values like database passwords and Fernet keys should never be plaintext in Helm `values.yaml`. Instead, use Kubernetes Secrets and reference them via `secretKeyRef`.

## 5. DAG Deployment Strategies

In this project, we bake DAGs directly into the Docker image.

- **Pros**: Ensures that the code running in the Scheduler and the Workers is always perfectly in sync.
- **Cons**: Requires a new image build and push for every DAG change.
- **Alternative**: For larger teams, using a `git-sync` sidecar or a shared PersistentVolume (AWS EFS / Azure Files) might be more efficient, though it adds architectural complexity.

## 6. Networking & Port Forwarding

In a local setup, accessing the Airflow UI can be tricky.

- **Finding**: Using a `LoadBalancer` service type doesn't work out-of-the-box in KinD without extra tools like MetalLB.
- **Solution**: `kubectl port-forward` is the simplest and most reliable way to access the Webserver on `localhost:8080`.
