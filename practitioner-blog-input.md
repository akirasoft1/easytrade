# Troubleshooting EasyTrade Services with Gemini CLI and Dynatrace

This document outlines two distinct troubleshooting scenarios within the EasyTrade application, demonstrating how to diagnose and resolve complex issues using a combination of Dynatrace monitoring and the Gemini CLI.

***
*Blog Writer's Hint: This file is structured into two parts. Each part is a self-contained story about solving a specific problem. The first part deals with a database connectivity issue caused by a race condition. The second part, starting with "Part 2", tackles a code-level bug causing a high failure rate, including the challenges of a complex CI/CD environment. When writing the blog, you can either combine these into a single narrative or present them as two separate case studies. Emphasize the synergy between Dynatrace for problem detection and Gemini CLI for deep-dive analysis and remediation.*
***

## Part 1: The Case of the Impatient Service

### 1. Initial Problem Detection

The investigation started with a problem identified in the Dynatrace UI. The `easyTradeManager` service was reporting critical errors, and the Dynatrace problem card pointed to a failure in database connectivity.

### 2. Deep Dive with Gemini CLI & DQL

To get more detailed, unfiltered information, we moved to the Gemini CLI to query the logs directly from Dynatrace's Grail data lake. A targeted DQL query on the `manager` service's pods revealed the root cause:

```dql
fetch logs
| filter status != "INFO"
| filter k8s.cluster.name ~ "mvilliger-autopilot-cluster1" and k8s.pod.name ~ "manager-"
```

This query consistently returned the error: `Microsoft.EntityFrameworkCore.Database.Connection[20004] An error occurred using the connection to database 'easytrade' on server 'db'.`

### 3. Root Cause Analysis: A Startup Race Condition

The error pattern strongly suggested a startup race condition. The `manager` service pod was starting up and attempting to connect to the database before the `db` pod's SQL Server instance was fully initialized and ready to accept connections.

### 4. The Solution: Kubernetes Startup Probe

To solve this, we implemented a Kubernetes `startupProbe` in the `db` service's deployment manifest (`kubernetes-manifests/release/db.yaml`). This probe ensures that dependent services won't try to connect to the database prematurely by delaying the container from being marked as "running" until it can successfully execute a simple SQL query.

### 5. Applying and Verifying the Fix

The updated manifest was applied to the cluster using `kubectl apply`. After restarting the affected pods, we re-ran our targeted DQL query against the logs of the new `manager` pod. The database connection errors were gone, confirming that the `startupProbe` had successfully resolved the race condition.

***
*Blog Writer's Hint: The next section describes a more complex scenario involving a code bug, a tricky build/deploy process, and a key lesson about monitoring systems. This is a great opportunity to highlight the iterative nature of troubleshooting and the importance of patience and persistence.*
***

## Part 2: The Phantom Error and the Patient Observer

### 1. A New Problem Emerges: Failure Rate Increase

Shortly after resolving the database issue, a new problem surfaced in Dynatrace: a "Failure rate increase" in the `credit-card-order-service`.

### 2. Pinpointing the Bug with Log Analysis

Using Gemini CLI, we inspected the logs of the affected pod and quickly found the culprit: a `java.lang.ArithmeticException: / by zero`. The stack trace pointed directly to a method named `CountArythmeticSequenceTotal` in `OrderController.java`, where a variable `theGreatDivider` was intentionally set to `0`.

### 3. The Fix and the Deployment Challenge

The fix was simple: change `theGreatDivider` from `0` to `2`. However, deploying this fix proved to be a multi-step challenge that showcases real-world complexities:

*   **Initial Failure:** Our first attempts to build and deploy the image using `skaffold` failed. The running pod continued to serve the old, buggy code, and the `ArithmeticException` persisted in the logs.
*   **The Container Registry Hurdle:** We discovered we couldn't push to the official container registry. The solution was to create a new Artifact Registry repository within the existing GCP project (`strategic-technical-alliances`).
*   **Wrangling Skaffold:** We then had to reconfigure `skaffold.yaml` to use this new repository. This involved a series of trial-and-error steps to get the configuration just right, demonstrating the importance of understanding the build tool's specific syntax and structure.
*   **Forcing the Update:** Even after successfully building and pushing the image to the new registry, the Kubernetes deployment didn't automatically pull the new image. We had to forcefully delete the existing deployment and re-apply the manifest to ensure the cluster was running the corrected code.

### 4. Verification and a Lesson in Patience

After the forced redeployment, we verified the fix by checking the logs of the new pod—the `ArithmeticException` was finally gone.

However, a crucial lesson emerged: **Dynatrace problems don't always resolve instantly.** For several minutes, the "Failure rate increase" and a related "Deployment stuck" problem remained active in the Dynatrace UI, even though we had confirmed on the cluster that the issue was resolved.

***
*Blog Writer's Hint: This is the key takeaway for the blog post. Frame this as a pro-tip for practitioners. When you're confident in a fix, give your monitoring system (like Dynatrace) 10-15 minutes to catch up and automatically close the problem before you assume the fix failed and start re-investigating.*
***

This experience highlights that while tools like Gemini CLI provide immediate, ground-truth data from the cluster, monitoring platforms like Dynatrace operate on a slightly different timescale, processing and analyzing data before updating problem statuses. The combination of both perspectives is powerful, but it requires an understanding of their respective behaviors.