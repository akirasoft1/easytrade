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

### Kubernetes Deployment

To deploy the application to a Kubernetes cluster, use the provided manifests:

```bash
# Create the namespace
kubectl create namespace easytrade

# Apply the manifests
kubectl -n easytrade apply -f ./kubernetes-manifests/release
```

### Building with Skaffold

Skaffold is used to build the container images for the various services. The `skaffold.yaml` file defines the build artifacts and deployment configurations. We do not have push access to the container registry specified in the manifest files so if we need to rebuild container images we must create an artifact registry in GCP.

## Development Conventions

*   **Service-Specific Documentation:** Each service has its own `README.md` file with more detailed information about its functionality and API.
*   **Frontend Linting and Formatting:** The frontend code uses `eslint` for linting and `prettier` for formatting. The following commands can be used to enforce the conventions:
    *   `npm run lint`: Check for linting errors.
    *   `npm run format`: Format the code.
*   **Kubernetes Manifests:** The Kubernetes manifests are organized into `base` and `release` directories, with `kustomize` used for managing configurations.
*   **Dynatrace Integration:** The project is designed to be monitored with Dynatrace, with configuration managed by Monaco.

# GKE Autopilot Configuration Recommendations

This document provides recommendations for updating the Kubernetes manifests in `kubernetes-manifests/release/` to ensure compatibility and optimal performance on GKE Autopilot.

## General Recommendations for GKE Autopilot

GKE Autopilot enforces specific rules for resource requests and limits. Here are some key points to consider:

*   **CPU and Memory Ratio:** Autopilot has a supported CPU to memory ratio for each compute class. For the default `General-purpose` compute class, the CPU to memory ratio must be between 1:1 and 1:6.5.
*   **Minimum Resource Requests:** Autopilot has minimum resource requests for pods. For the `General-purpose` compute class, the minimum is 50m CPU and 52mi memory. However, Autopilot has a feature called "vertical pod autoscaling" which can automatically adjust resource requests for pods that consistently use less than the minimum. 

## File-by-File Recommendations

Here are the specific recommendations for each of the manifest files:

### `accountservice.yaml`

The resource requests for the `accountservice` container are:

```yaml
resources:
  requests:
    cpu: 50m
    memory: 600Mi
  limits:
    memory: 600Mi
```

The CPU to memory ratio is 30:600 or 1:20, which is outside the supported 1:1 to 1:6.5 range for the general-purpose compute class.

**Recommendation:**

Adjust the CPU and/or memory requests to bring the ratio within the supported range. For example, you could increase the CPU request or decrease the memory request. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 600Mi
```

This would result in a 1:6 ratio.

### `aggregator-service.yaml`

The resource requests for the `aggregator-service` container are within the supported CPU to memory ratio. No changes are recommended.

### `broker-service.yaml`

The resource requests for the `broker-service` container are:

```yaml
resources:
  requests:
    cpu: 150m
    memory: 350Mi
  limits:
    cpu: 600m
    memory: 350Mi
```

The requested CPU to memory ratio is 150:350 or roughly 1:2.33, which is within the supported range. However, GKE Autopilot will ignore the specified `limits` and set them to be equal to the `requests`.

**Recommendation:**

For clarity and to align with Autopilot's behavior, you can remove the `limits` section entirely.

### `calculationservice.yaml`

The resource requests for the `calculationservice` container are within the supported CPU to memory ratio. No changes are recommended.

### `contentcreator.yaml`

The resource requests for the `contentcreator` container are:

```yaml
resources:
  requests:
    cpu: 50m
    memory: 400Mi
```

The CPU to memory ratio is 1:40, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 75m
    memory: 400Mi
```
This would result in a ~1:5.3 ratio.

### `credit-card-order-service.yaml`

The resource requests for the `credit-card-order-service` container are:

```yaml
resources:
  requests:
    cpu: 20m
    memory: 650Mi
```

The CPU to memory ratio is 1:32.5, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 650Mi
```
This would result in a 1:6.5 ratio.

### `db.yaml`

The resource requests for the `db` container are:

```yaml
resources:
  requests:
    cpu: 40m
    memory: 1.5Gi
```

The CPU to memory ratio is 40:1536 or ~1:38, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 250m
    memory: 1.5Gi
```
This would result in a ~1:6 ratio.

### `engine.yaml`

The resource requests for the `engine` container are:

```yaml
resources:
  requests:
    cpu: 10m
    memory: 450Mi
```

The CPU to memory ratio is 1:45, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 75m
    memory: 450Mi
```
This would result in a 1:6 ratio.

### `feature-flag-service.yaml`

The resource requests for the `feature-flag-service` container are:

```yaml
resources:
  requests:
    cpu: 30m
    memory: 600Mi
```

The CPU to memory ratio is 1:20, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 600Mi
```
This would result in a 1:6 ratio.

### `frontend.yaml`

The resource requests for the `frontend` container are:

```yaml
resources:
  requests:
    cpu: 10m
    memory: 75Mi
```

The CPU to memory ratio is 1:7.5, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 15m
    memory: 75Mi
```
This would result in a 1:5 ratio.



### `frontendreverseproxy.yaml`

The resource requests for the `frontendreverseproxy` container are within the supported CPU to memory ratio. No changes are recommended.

### `loadgen.yaml`

The resource requests for the `loadgen` container are within the supported CPU to memory ratio. No changes are recommended.

### `loginservice.yaml`

The resource requests for the `loginservice` container are:

```yaml
resources:
  requests:
    cpu: 20m
    memory: 450Mi
```

The CPU to memory ratio is 1:22.5, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 75m
    memory: 450Mi
```
This would result in a 1:6 ratio.

### `manager.yaml`

The resource requests for the `manager` container are:

```yaml
resources:
  requests:
    cpu: 50m
    memory: 600Mi
```

The CPU to memory ratio is 1:12, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 600Mi
```
This would result in a 1:6 ratio.

### `offerservice.yaml`

The resource requests for the `offerservice` container are within the supported CPU to memory ratio. No changes are recommended.

### `pricing-service.yaml`

The resource requests for the `pricing-service` container are within the supported CPU to memory ratio. No changes are recommended.

### `problem-operator.yaml`

The resource requests for the `problem-operator` container are within the supported CPU to memory ratio. No changes are recommended.

### `rabbitmq.yaml`

The resource requests for the `rabbitmq` container are:

```yaml
resources:
  requests:
    cpu: 10m
    memory: 175Mi
```

The CPU to memory ratio is 1:17.5, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 30m
    memory: 175Mi
```
This would result in a ~1:5.8 ratio.

### `third-party-service.yaml`

The resource requests for the `third-party-service` container are:

```yaml
resources:
  requests:
    cpu: 10m
    memory: 450Mi
```

The CPU to memory ratio is 1:45, which is outside the supported range.

**Recommendation:**

Adjust the CPU and/or memory requests. A possible adjustment:

```yaml
resources:
  requests:
    cpu: 75m
    memory: 450Mi
```
This would result in a 1:6 ratio.

**Additional guidance regarding minimums**

the minimums of 50m cpu and 52mi memory should always be taken into consideration even if the ratio would otherwise be supported. 

i.e. while the following supports the proper ratio, the requests are far to low:

```yaml
resources:
  requests:
    cpu: 15m
    memory: 75Mi
```

a better set of requests would be as follows:

```yaml
resources:
  requests:
    cpu: 50mi
    memory: 75Mi
```

**Additional guidance regarding kubernetes probes**

When possible, always create readiness probes on the CALLED service before creating startup probes on the CALLING service

# Observability

We use Dynatrace as an Observability solution. This document provides instructions on how to get data for easytrade from Dynatrace using DQL.

## Important info regarding GKE Autopilot ##

VERY IMPORTANT: GKE Autopilot allocates the bare minimum cpu, memory, and disk for worker nodes based on requests. As such it will ALWAYS generate alse positive resource contention problems such as memory-request saturation, memory usage close to limits, or pod saturation. We can safely ignore these if reported by Dynatrace

## How to get any data for my App

Depending on the query and tool used, for logs the following filters can be applied to narrow down results:

* `k8s.cluster.name ~ "mvilliger-autopilot-cluster1"`
* `k8s.namespace.name ~ "easytrade"`

For best results, you can combine these filters with an `OR` operator.

*   **DQL Log Filtering with '~' operator:** When filtering DQL statements, the '~' operator can be more effective than '==' for fields like 'k8s.cluster.name' to locate more results. contains(field, "value") is functionaly equivalent to field ~ "value". If a query using contains fails, attempt to use filter field ~ "value".

# EasyTrade

## Observability & Monitoring

Components of this repository are deployed to a Kubernetes Cluster and monitored by Dynatrace.

### Finding EasyTrade Service Entities

You can find entities via the `find_entities_by_name` tool using `easytrade` as well as specific service names (see service list in README).
You should find entities like `[mvilliger-autopilot-cluster1][easytrade] BrokerService`.

### Finding Problems

You can find problems via the `list_problems` tool and applying the following filter:

```dql
contains(k8s.namespace.name, "easytrade") OR contains(dt.entity.application.name, "EasyTrade")
```

If you want to narrow down the problem of a specific entity, like a service, you can use the following filter:

```dql
in(affected_entity_ids, "<service-id>") OR dt.entity.$type == "<entity-id>" OR ...
```

### Metrics

You can then investigate metrics via the DQL command

```dql
timeseries {
  avg(<metric-key>)
},
from: now() -14d, to: now(),
filter: { matchesValue(k8s.deployment.name, "*<service-name>*") }
```

#### Service-Level Metrics

- _Service Response Time_: `dt.service.request.response_time`
- _Service Request Count_: `dt.service.request.count`
- _Service Failure Count_: `dt.service.request.failure_count`

#### Container-Level Metrics

- _Container CPU Usage_: `dt.kubernetes.container.cpu_usage`
- _Container Memory Working Set_: `dt.kubernetes.container.memory_working_set`
- _Container CPU Requests_: `dt.kubernetes.container.requests_cpu`
- _Container Memory Requests_: `dt.kubernetes.container.requests_memory`
- _Container CPU Limits_: `dt.kubernetes.container.limits_cpu`
- _Container Memory Limits_: `dt.kubernetes.container.limits_memory`

#### Kubernetes Infrastructure Metrics

- _Pod Conditions_: `dt.kubernetes.workload.conditions`
- _Pod Status_: `dt.kubernetes.pods`
- _Container State_: `dt.kubernetes.containers`

#### Technology-Specific Metrics

- _JVM Memory Usage_: `dt.runtime.jvm.memory.heap.used`, `dt.runtime.jvm.memory.heap.max`
- _Goroutine count_: `dt.runtime.go.scheduler.goroutine_count`
- _Go Worker thread count_: `dt.runtime.go.scheduler.worker_thread_count`
- _Go Heap Memory_: `dt.runtime.go.memory.heap`
- _Go Memory Committed_: `dt.runtime.go.memory.committed`

You can find additional metrics via `fetch metric.series | filter dt.entity.service == "<service-id>" | limit 50` or for kubernetes: `fetch metric.series | filter k8s.namespace.name == "easytrade" | filter metric.key == "dt.kubernetes.container.cpu_usage" or metric.key == "dt.kubernetes.container.memory_working_set" | limit 50`.

### Logs

You can find logs via the `fetch logs` tool and applying the following filter:

```dql
fetch logs, from: now()-24h
| filter k8s.namespace.name ~ "easytrade"
| sort timestamp desc
```

Filter error logs with

```dql
| filter loglevel == "ERROR"
```

You can furthermore narrow down logs for a specific service by adding a filter like this: `| filter k8s.deployment.name ~ "<service-name>"`.

DO NOT ATTEMPT TO GUESS DQL TIME SYNTAX AND ONLY ADJUST TIME SYNTAX IF CONFIDENT

example syntax to query for error logs from last 8 hours:

```dql
fetch logs, from: now()-8h
| filter k8s.namespace.name ~ "easytrade"
| sort timestamp desc
```

###

If many DQL syntax errors are encountered, you can use the "generate_dql_from_natural_language" tool to have the Dynatrace MCP generate the DQL syntax for you. Use this early and often as DQL syntax is confusing and changes quickly when new features are released after your knowledge cutoff.

**Additional Info**

Adjust all manifests to ensure EasyTrade components are installed to the easytrade namespace

Dynatrace problems will automatically close if the problem has been resolved but it can take Dynatrace up to 30 minutes to consider an issue closed. This time prevents the same problem from constantly being closed and recreated. If the error persists past this time period it is likely the root cause was not addressed. 

**Tool Notes**

always specify absolute paths for the `write_file` tool.