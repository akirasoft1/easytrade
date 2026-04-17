# GKE Autopilot Configuration Recommendations

This document provides recommendations for updating the Kubernetes manifests in `kubernetes-manifests/release/` to ensure compatibility and optimal performance on GKE Autopilot.

## General Recommendations for GKE Autopilot

GKE Autopilot enforces specific rules for resource requests and limits. Here are some key points to consider:

*   **CPU and Memory Ratio:** Autopilot has a supported CPU to memory ratio for each compute class. For the default `General-purpose` compute class, the CPU to memory ratio must be between 1:1 and 1:6.5.
*   **Minimum Resource Requests:** Autopilot has minimum resource requests for pods. For the `General-purpose` compute class, the minimum is 50m CPU and 52mi memory. However, Autopilot has a feature called "vertical pod autoscaling" which can automatically adjust resource requests for pods that consistently use less than the minimum.
*   **Limits vs. Requests:** Autopilot sets limits equal to requests. It is recommended to remove the `limits` section for clarity and to align with Autopilot's behavior.

## File-by-File Recommendations

Here are the specific recommendations for each of the manifest files:

### `accountservice.yaml`

The resource requests for the `accountservice` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 100m
              memory: 600Mi
```

### `aggregator-service.yaml`

The resource requests for the `aggregator-service` container are below the minimum CPU and memory requests.

**Recommendation:**

Increase the CPU and memory requests to meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 50m
              memory: 52Mi
```

### `broker-service.yaml`

The `limits` section is unnecessary as GKE Autopilot sets limits equal to requests.

**Recommendation:**

For clarity and to align with Autopilot's behavior, you can remove the `limits` section entirely.

```yaml
          resources:
            requests:
              cpu: 150m
              memory: 350Mi
```

### `calculationservice.yaml`

The resource requests for the `calculationservice` container are below the minimum CPU and memory requests.

**Recommendation:**

Increase the CPU and memory requests to meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 50m
              memory: 52Mi
```

### `contentcreator.yaml`

The resource requests for the `contentcreator` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 75m
              memory: 400Mi
```

### `credit-card-order-service.yaml`

The resource requests for the `credit-card-order-service` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 100m
              memory: 650Mi
```

### `db.yaml`

The resource requests for the `db` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 250m
              memory: 1.5Gi
```

### `engine.yaml`

The resource requests for the `engine` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 75m
              memory: 450Mi
```

### `feature-flag-service.yaml`

The resource requests for the `feature-flag-service` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 100m
              memory: 600Mi
```

### `frontend.yaml`

The resource requests for the `frontend` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 50m
              memory: 75Mi
```

### `frontendreverseproxy.yaml`

The `limits` section is unnecessary as GKE Autopilot sets limits equal to requests.

**Recommendation:**

For clarity and to align with Autopilot's behavior, you can remove the `limits` section entirely.

```yaml
          resources:
            requests:
              cpu: 50m
              memory: 100Mi
```

### `loadgen.yaml`

The `limits` section is unnecessary as GKE Autopilot sets limits equal to requests.

**Recommendation:**

For clarity and to align with Autopilot's behavior, you can remove the `limits` section entirely.

```yaml
          resources:
            requests:
              cpu: "1"
              memory: 2Gi
```

### `loginservice.yaml`

The resource requests for the `loginservice` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 75m
              memory: 450Mi
```

### `manager.yaml`

The resource requests for the `manager` container are outside the supported CPU to memory ratio.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 100m
              memory: 600Mi
```

### `offerservice.yaml`

The `limits` section is unnecessary as GKE Autopilot sets limits equal to requests.

**Recommendation:**

For clarity and to align with Autopilot's behavior, you can remove the `limits` section entirely.

```yaml
          resources:
            requests:
              cpu: 50m
              memory: 150Mi
```

### `pricing-service.yaml`

The resource requests for the `pricing-service` container are below the minimum CPU request.

**Recommendation:**

Increase the CPU request to meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 50m
              memory: 80Mi
```

### `problem-operator.yaml`

The resource requests for the `problem-operator` container are below the minimum CPU and memory requests.

**Recommendation:**

Increase the CPU and memory requests to meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 50m
              memory: 52Mi
```

### `rabbitmq.yaml`

The resource requests for the `rabbitmq` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 50m
              memory: 175Mi
```

### `third-party-service.yaml`

The resource requests for the `third-party-service` container are outside the supported CPU to memory ratio and below the minimum CPU request.

**Recommendation:**

Adjust the CPU request to bring the ratio within the supported range and meet the minimum requirements. Also, remove the memory limit.

```yaml
          resources:
            requests:
              cpu: 75m
              memory: 450Mi
```
