# OpenTelemetry instrumentation for easyTrade

easyTrade is instrumented with OpenTelemetry using **zero-code injection via the
OpenTelemetry Operator**. No service image is rebuilt and no application source is
changed — the Operator injects the right language agent into each annotated pod at
start-up and points it at the Dynatrace OTLP endpoint.

Telemetry is sent to the Bluebox/Dynatrace OTLP endpoint resolved by
`bluebox otlp-endpoint`:

```
https://qgv89709.apps.dynatrace.com/api/v2/otlp   (http/protobuf)
```

The static transport config lives in [`../../.env.otel.bluebox-template`](../../.env.otel.bluebox-template).

## What gets instrumented

| Service | Language | Mechanism | Status |
|---|---|---|---|
| accountservice | Java | `inject-java` | ✅ injected |
| contentcreator | Java | `inject-java` | ✅ injected |
| credit-card-order-service | Java | `inject-java` | ✅ injected |
| engine | Java | `inject-java` | ✅ injected |
| feature-flag-service | Java | `inject-java` | ✅ injected |
| third-party-service | Java | `inject-java` | ✅ injected |
| broker-service | .NET | `inject-dotnet` | ✅ injected |
| loginservice | .NET | `inject-dotnet` | ✅ injected |
| manager | .NET | `inject-dotnet` | ✅ injected |
| loadgen | Node.js | `inject-nodejs` | ✅ injected |

### Not instrumented in this pass (and why)

| Service | Reason | Recommended follow-up |
|---|---|---|
| frontend | Runtime container is **nginx** serving a static Angular SPA — there is no Node process to instrument. Browser telemetry needs **RUM**, not backend OTLP. | Add Dynatrace RUM (or the OTel browser SDK) to the Angular app separately. |
| db | Microsoft **SQL Server** container, not an application. Database calls are captured as client spans from the services that call it. | None — DB activity surfaces via caller spans. |
| aggregator-service, pricing-service | **Go**. The Operator's SDK injection does not support Go; its eBPF auto-instrumentation (`inject-go`) needs a privileged init container, which **GKE Autopilot blocks**. | Add the OTel Go SDK in code (`otelhttp` for aggregator-service, `otelgin` for pricing-service) and rebuild those two images. |
| problem-operator | **Go**, and a controller rather than a request-serving service. | Low value; instrument only if you need operator traces. |
| calculationservice | **C++**. No drop-in/auto-instrumentation path. | Manual `opentelemetry-cpp` integration if traces are required; otherwise leave as a known gap. |

> `offerservice` (Node.js) exists in `src/` and `compose*.yaml` but has **no Deployment**
> in `kubernetes-manifests/release/`, so there is nothing to annotate here. If you add
> its Deployment, give it `instrumentation.opentelemetry.io/inject-nodejs: "easytrade"`.

## Prerequisites — install once per cluster

The Operator depends on cert-manager.

```bash
# 1. cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
kubectl wait --for=condition=Available -n cert-manager --all deployment --timeout=180s

# 2. OpenTelemetry Operator
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
kubectl wait --for=condition=Available -n opentelemetry-operator-system deployment/opentelemetry-operator-controller-manager --timeout=180s
```

### GKE Autopilot caveat (required)

On GKE Autopilot, cert-manager's controller and cainjector default their
leader-election lease to the **`kube-system`** namespace, which Autopilot forbids
(`GKE Warden ... the namespace "kube-system" is managed`). cainjector then never
runs, never injects the webhook `caBundle`, and the OpenTelemetry Operator's
cert-manager `Issuer`/`Certificate` fail to create with
`tls: ... certificate signed by unknown authority`.

Move leader election to the `cert-manager` namespace and grant the matching RBAC:

```bash
kubectl patch deploy -n cert-manager cert-manager --type=json \
  -p '[{"op":"replace","path":"/spec/template/spec/containers/0/args/2","value":"--leader-election-namespace=cert-manager"}]'
kubectl patch deploy -n cert-manager cert-manager-cainjector --type=json \
  -p '[{"op":"replace","path":"/spec/template/spec/containers/0/args/1","value":"--leader-election-namespace=cert-manager"}]'

kubectl apply -f opentelemetry-cert-manager-autopilot-rbac.yaml
```

(Equivalently, install cert-manager via Helm with `global.leaderElection.namespace=cert-manager`.)
The RBAC manifest lives next to this file. Verify the fix worked — the caBundle should be non-empty:

```bash
kubectl get validatingwebhookconfiguration cert-manager-webhook \
  -o jsonpath='{.webhooks[0].clientConfig.caBundle}' | wc -c   # > 100
```

## Two deployment paths — pick the one you actually run

These raw manifests create **unprefixed** workloads (`accountservice`, `manager`, …).
The README's primary install instead uses the upstream **Helm chart**
(`oci://europe-docker.pkg.dev/dynatrace-demoability/helm/easytrade`), which creates
**release-prefixed** workloads (`easytrade-accountservice`, …).

- **Raw-manifest deployments:** the inject annotations are already in the files here —
  follow *Deploy* below.
- **Helm-deployed releases:** the annotations in these files do NOT apply to the running
  `easytrade-*` workloads. Add them to the live release instead — either via the chart's
  pod-annotation values, or by patching the running Deployments, e.g.:

  ```bash
  NS=easytrade
  # Java
  for d in accountservice contentcreator credit-card-order-service engine feature-flag-service third-party-service; do
    kubectl patch deploy -n $NS easytrade-$d --type=merge \
      -p '{"spec":{"template":{"metadata":{"annotations":{"instrumentation.opentelemetry.io/inject-java":"easytrade"}}}}}'
  done
  # .NET
  for d in broker-service loginservice manager; do
    kubectl patch deploy -n $NS easytrade-$d --type=merge \
      -p '{"spec":{"template":{"metadata":{"annotations":{"instrumentation.opentelemetry.io/inject-dotnet":"easytrade"}}}}}'
  done
  # Node
  for d in loadgen offerservice; do
    kubectl patch deploy -n $NS easytrade-$d --type=merge \
      -p '{"spec":{"template":{"metadata":{"annotations":{"instrumentation.opentelemetry.io/inject-nodejs":"easytrade"}}}}}'
  done
  ```

  Direct patches are wiped by the next `helm upgrade`. For persistence, these annotations
  are committed as per-service `podAnnotations` in [`../../gke-autopilot-values.yaml`](../../gke-autopilot-values.yaml),
  so `helm upgrade easytrade oci://europe-docker.pkg.dev/dynatrace-demoability/helm/easytrade -n easytrade -f gke-autopilot-values.yaml`
  reproduces the live state (11 services injected + OneAgent disabled; the other 7 keep OneAgent).

## Deploy

All three of the easyTrade workloads, the `Instrumentation` CR, and the token Secret
**must live in the same namespace**. Substitute your namespace below.

```bash
NS=easytrade   # the namespace easyTrade is deployed into

# 1. Create the ingest-token Secret (never committed). Reveal the token in
#    Bluebox -> Onboarding -> Instrumentation setup -> Reveal token.
kubectl create secret generic dynatrace-otel-ingest \
  --from-literal=OTEL_EXPORTER_OTLP_HEADERS="Authorization=Api-Token <ingest-token>" \
  -n "$NS"

# 2. Apply the Instrumentation CR.
kubectl apply -n "$NS" -f opentelemetry-instrumentation.yaml

# 3. (Re)apply the workload manifests so the new pod annotations take effect.
kubectl apply -n "$NS" -f .

# 4. Roll the annotated workloads so the Operator injects the agents.
kubectl rollout restart -n "$NS" deployment \
  accountservice contentcreator credit-card-order-service engine \
  feature-flag-service third-party-service broker-service loginservice \
  manager loadgen
```

> The token Secret is referenced by [`opentelemetry-instrumentation.yaml`](opentelemetry-instrumentation.yaml)
> and injected as `OTEL_EXPORTER_OTLP_HEADERS`. The token value is never stored in this
> repo. See [`opentelemetry-token-secret.example.yaml`](opentelemetry-token-secret.example.yaml)
> if you manage Secrets via GitOps (sealed-secrets / SOPS); a non-`.example` token file is git-ignored.

## Coexistence with Dynatrace OneAgent (pure-OTel opt-out)

If the cluster also runs the **Dynatrace Operator** (a `DynaKube` with app injection),
its webhook injects OneAgent into every pod in a monitored namespace — so an
OTel-instrumented pod ends up **double-instrumented** (a `dynatrace-operator` init
container *and* an `opentelemetry-auto-instrumentation-*` init container), reporting via
both paths.

To make the OTel-instrumented services **pure OTel**, opt them out of Dynatrace injection
with a pod annotation (this disables both OneAgent and metadata-enrichment):

```yaml
      annotations:
        dynatrace.com/inject: "false"
```

Apply it only to workloads that have an OTel replacement. Leave OneAgent in place on
services you did NOT OTel-instrument (the Go services, frontend, calculationservice, db,
rabbitmq) so they keep reporting. On the live release:

```bash
NS=easytrade
for d in accountservice contentcreator credit-card-order-service engine feature-flag-service \
         third-party-service broker-service loginservice manager loadgen offerservice; do
  kubectl patch deploy -n $NS easytrade-$d --type=merge \
    -p '{"spec":{"template":{"metadata":{"annotations":{"dynatrace.com/inject":"false"}}}}}'
done
```

Verify: an opted-out pod's `spec.initContainers` should list only the
`opentelemetry-auto-instrumentation-*` container and no `dynatrace-operator`.

## Verify

After the pods are running with some traffic (loadgen drives this automatically),
confirm telemetry is arriving:

```bash
# Per-pod: an init container named "opentelemetry-auto-instrumentation" should exist.
kubectl get pod -n "$NS" -l app=accountservice \
  -o jsonpath='{.items[0].spec.initContainers[*].name}{"\n"}'

# End-to-end, against live Dynatrace data:
bluebox ask --service accountservice "are any spans or traces arriving for accountservice in the last 15 minutes?"
```

Allow a few minutes after first traffic before concluding no data is flowing. A 401/403
on export means the token in the Secret is wrong or missing — fix the Secret, not the manifests.
