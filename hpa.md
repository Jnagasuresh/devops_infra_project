
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
* hpa will override deployment replicas as per the resource utilization.
