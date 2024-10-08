## Auto Scaling (HPA: Horizontal Pod Autoscaling)

```yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: my-scaling-deploy
 spec:
   replicas: 3
   selector:
     matchLabels:
       app: my-scaling-deploy
   template:
     metadata:
       labels:
        app: my-scaling-deploy
     spec:
       containers:
       -  name: my-scaling-deploy-pod
          image: gcr.io/k8s-staging-e2e-test-images/resource-consumer:1.9
          resources:
            requests:
              cpu: 100m # 1/10th of a cpu

```

kubectl autoscale deployment my-scaling-deploy --cpu-percent=50 --min=1 --mx=10 --dry-run=client -o yaml > hpa.yaml

```yaml
 apiVersion: autoscaling/v1
 kind: HorizontalPodAutoscaler
 metadata:
   creationTimestamp: null
   name: my-scaling-deploy
 spec:
   maxReplicas: 10
   minReplicas: 1
   scaleTargetRef:
     apiVerison: apps/v1
     kind: Deployment
     name: my-scaling-deploy
   targetCPUUtilizationPercentage: 50
```

> kubectl get hpa

* `hpa waits for 5 mins to decrease the pods`
* `scaling up will happend immediately`
* hpa will override `deployment replicas` as per the resource utilization.
---
Kubernetes Horizontal Pod Autoscaler (HPA) can be configured to scale your application based on various metrics, not just CPU utilization. You can use memory utilization, custom metrics, or external metrics to define the scaling policy.

### HPA Based on CPU Utilization

Here’s an example of an HPA configuration based on CPU utilization:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: cpu-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-deployment
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

### HPA Based on Memory Utilization

To create an HPA based on memory utilization, you can modify the `metrics` section accordingly:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: memory-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-deployment
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

In this example:
- The HPA will scale the number of pods in the `my-deployment` deployment.
- It will maintain an average memory utilization of 80%.

### HPA Based on Custom Metrics

Kubernetes HPA can also scale based on custom metrics. Custom metrics can be application-specific metrics like request rates, error rates, or any other custom-defined metrics.

Here’s an example:

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: custom-metric-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-deployment
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Pods
    pods:
      metric:
        name: custom_metric_name
      target:
        type: AverageValue
        averageValue: 100
```

In this example:
- The HPA will scale based on a custom metric named `custom_metric_name`.
- The target is set to an average value of 100.

### HPA Based on External Metrics

You can also scale your pods based on external metrics, such as metrics provided by an external system or service.

Example:

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: external-metric-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-deployment
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: External
    external:
      metric:
        name: external_metric_name
      target:
        type: AverageValue
        averageValue: 100
```

In this example:
- The HPA will scale based on an external metric named `external_metric_name`.
- The target is set to an average value of 100.

### Summary

Kubernetes HPA can be configured to scale your application based on various metrics:
- **CPU Utilization**: Scale based on CPU usage.
- **Memory Utilization**: Scale based on memory usage.
- **Custom Metrics**: Scale based on application-specific metrics.
- **External Metrics**: Scale based on metrics from external sources.

This flexibility allows you to tailor the scaling behavior of your applications to meet your specific requirements and workload patterns.