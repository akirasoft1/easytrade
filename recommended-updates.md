# GKE Autopilot Configuration Recommendations

This document provides recommendations for updating the Kubernetes manifests in `kubernetes-manifests/release/` to ensure compatibility and optimal performance on GKE Autopilot.

## General Recommendations for GKE Autopilot

GKE Autopilot enforces specific rules for resource requests and limits. Here are some key points to consider:

*   **Resource Requests and Limits:** In GKE Autopilot, you only need to set `spec.containers[].resources.requests`. Autopilot automatically sets the limits to be equal to the requests.
*   **CPU and Memory Ratio:** Autopilot has a supported CPU to memory ratio for each compute class. For the default `General-purpose` compute class, the CPU to memory ratio must be between 1:1 and 1:6.5.
*   **Minimum Resource Requests:** Autopilot has minimum resource requests for pods. For the `General-purpose` compute class, the minimum is 250m CPU and 512Mi memory. However, Autopilot has a feature called "vertical pod autoscaling" which can automatically adjust resource requests for pods that consistently use less than the minimum. For the purpose of these recommendations, we will focus on the CPU to memory ratio.

## File-by-File Recommendations

Here are the specific recommendations for each of the manifest files:

### `accountservice.yaml`

The resource requests for the `accountservice` container are:

```yaml
resources:
  requests:
    cpu: 30m
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
    cpu: 10m
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