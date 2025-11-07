# GEMINI.md - Your AI Assistant's Guide to EasyTrade

This file provides context for AI assistants to understand and interact with the EasyTrade project.

## Project Overview

EasyTrade is a microservices-based stock trading application. It simulates a real-world stock broking platform, allowing users to buy and sell stocks. The application is composed of numerous small services that communicate with each other.

**Key Technologies:**

*   **Backend:** Java, .NET, Go
*   **Frontend:** React (with Vite)
*   **Database:** Microsoft SQL Server
*   **Messaging:** RabbitMQ
*   **Containerization:** Docker
*   **Orchestration:** Kubernetes (with Skaffold and Kustomize)

**Architecture:**

The application follows a microservices architecture. A `frontendreverseproxy` service acts as an entry point, routing requests to the appropriate backend services. The backend services are responsible for specific functionalities like account management, trading, pricing, etc. A `db` service provides the database, and `rabbitmq` is used for asynchronous communication.

## Building and Running

### Local Development (Docker Compose)

To run the application locally, use Docker Compose:

```bash
docker compose up -d
```

The application will be available at `http://localhost`.

### Kubernetes Deployment

To deploy the application to a Kubernetes cluster, use the provided manifests:

```bash
# Create the namespace
kubectl create namespace easytrade

# Apply the manifests
kubectl -n easytrade apply -f ./kubernetes-manifests/release
```

### Building with Skaffold

Skaffold is used to build the container images for the various services. The `skaffold.yaml` file defines the build artifacts and deployment configurations.

## Development Conventions

*   **Service-Specific Documentation:** Each service has its own `README.md` file with more detailed information about its functionality and API.
*   **Frontend Linting and Formatting:** The frontend code uses `eslint` for linting and `prettier` for formatting. The following commands can be used to enforce the conventions:
    *   `npm run lint`: Check for linting errors.
    *   `npm run format`: Format the code.
*   **Kubernetes Manifests:** The Kubernetes manifests are organized into `base` and `release` directories, with `kustomize` used for managing configurations.
*   **Dynatrace Integration:** The project is designed to be monitored with Dynatrace, with configuration managed by Monaco.

# Observability

We use Dynatrace as an Observability solution. This document provides instructions on how to get data for easytrade from Dynatrace using DQL.

## How to get any data for my App

Depending on the query and tool used, the following filters can be applied to narrow down results:

* `contains(entity.name, "easytrade")`
* `contains(affected_entity.name, "easytrade")`
* `contains(container.name, "easytrade")`


For best results, you can combine these filters with an `OR` operator.

*   **DQL Filtering with '~' operator:** When filtering DQL statements, the '~' operator can be more effective than '==' for fields like 'k8s.cluster.name' to locate more results. contains(field, "value") is functionaly equivalent to field ~ "value". If a query using contains fails, attempt to use filter field ~ "value".

## Logs
For fetching just error-logs, add `| filter loglevel == "ERROR".
For Docker based deployments: 
To fetch logs for easytrade, execute `fetch logs | filter contains(container.name, "easytrade")` 
THIS IS NOT VALID FOR KUBERNETES DEPLOYMENTS


fetch logs | filter status != "INFO" | filter k8s.cluster.name ~ "mvilliger-autopilot-cluster1"

DO NOT ATTEMPT TO GUESS TIME SYNTAX