
## Replicaset
 * Relication control vs Replica Set.


## Deployment

* Deployment will be create new replica set for any change in deployment manifest.

### Deployment Strategies

 1. Rolling update strategy (Default and This is recommended )
    - maxSurge (can be a number or percentate)
    - maxUnavailable (can be a number or percentate)
 2.  Recreate
     - there will be down time
     - Mostly used in dev environment


* scale the number replicas using command
> kubectl scale deploy rol-deploy --replicas 4


* Update image using command line
> kubectl set image deployment/rol-deploy <containername>=devopswithcloudhub/python_webpage:red

> kubectl set image deployment/rol-deploy python=devopswithcloudhub/python_webpage:red # here python is my container name


### rollout command

> kubectl rollout history deployment/sivanginx

> kubectl create deploy sivanginx --image developswithcloudhub/nginx:blue --replicas 2

> kubectl expose deploy sivanginx --port 80 --type LoadBalancer

> kubectl set image deployment/sivanginx nginx=devopswithcloudhub/nginx:blue --record=true

> kubectl set image deployment/sivanginx nginx=devopswithcloudhub/nginx:orange --record=true

### rollout
 * history
 * pause
 * restart
 * resume
 * status
 * undo


 > kubectl rollout history deployment/sivanginx


 ### rollback

 * roll back is undo the rollout command

 > kubectl rollout undo deployment/sivanginx
 > kubectl rollout undo deployment/sivanginx --to-revision=2

 ---
 In Kubernetes, rollout strategies are methods used to manage updates to applications deployed on the cluster. The main rollout strategies are **Rolling Update** and **Recreate**, each suited for different use cases and requirements.

### Rolling Update Strategy

**Definition**: The Rolling Update strategy updates the application instances incrementally, ensuring that some instances of the application remain available during the update process.

**How It Works**:
- Kubernetes updates pods gradually, replacing old pods with new ones.
- By default, it follows a max surge and max unavailable policy, meaning a certain number of pods are updated at a time while others remain available to handle requests.
- Ensures minimal downtime if the application supports it.

**Advantages**:
- **High Availability**: Keeps the application available during the update process.
- **Controlled Rollout**: Limits the number of pods that are unavailable during the update.
- **Rollback Capability**: Easier to rollback to a previous version if issues are detected during the update.

**Disadvantages**:
- **Complexity**: More complex to manage if the new version is not backward compatible with the old version.
- **Resource Utilization**: Requires additional resources to run both old and new versions simultaneously during the update.

**Use Cases**:
- Ideal for applications requiring high availability.
- Suitable for stateless applications where each instance can handle requests independently.

**Example Configuration**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app-container
        image: my-app:latest
```

### Recreate Strategy

**Definition**: The Recreate strategy involves terminating all existing instances of the application and then creating new instances. This approach ensures that no old instances are running when the new ones start.

**How It Works**:
- Kubernetes deletes all the existing pods before new pods are created.
- This results in a period of downtime when no pods are available to serve requests.

**Advantages**:
- **Simplicity**: Simple to understand and implement.
- **No Resource Overlap**: No need for additional resources to run old and new versions simultaneously.

**Disadvantages**:
- **Downtime**: Causes downtime as the old pods are terminated before new ones are created.
- **User Impact**: Not suitable for applications requiring high availability or continuous operation.

**Use Cases**:
- Suitable for development and testing environments where downtime is acceptable.
- Applicable for applications where a brief downtime is acceptable or necessary, such as when the new version requires a completely different setup.

**Example Configuration**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app-container
        image: my-app:latest
```

### Canary Deployments

**Definition**: A Canary deployment is a technique to reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users before deploying it to the entire infrastructure.

**How It Works**:
- A small subset of users is directed to the new version of the application.
- Monitor the performance and errors of the new version.
- Gradually increase the traffic to the new version if no issues are found.

**Advantages**:
- **Risk Mitigation**: Reduces the risk of introducing a faulty new version.
- **User Impact**: Limits the potential impact of issues to a smaller group of users.

**Disadvantages**:
- **Complexity**: More complex to set up and manage.
- **Time-Consuming**: Takes longer to fully roll out the new version.

**Use Cases**:
- Suitable for applications where stability and user experience are critical.
- Ideal for gradual and controlled rollouts.

**Example Configuration Using Argo Rollouts**:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: my-app
spec:
  replicas: 3
  strategy:
    canary:
      steps:
      - setWeight: 10
      - pause: { duration: 10m }
      - setWeight: 50
      - pause: { duration: 30m }
      - setWeight: 100
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app-container
        image: my-app:latest
```

### Blue-Green Deployments

**Definition**: Blue-Green deployment is a release management strategy that runs two identical production environments, Blue and Green, to ensure zero downtime during deployment.

**How It Works**:
- One environment (e.g., Blue) is live, while the other (e.g., Green) is idle.
- The new version is deployed to the idle environment.
- After testing, traffic is switched to the new environment.

**Advantages**:
- **Zero Downtime**: Ensures zero downtime during deployment.
- **Immediate Rollback**: Allows immediate rollback by switching traffic back to the previous environment.

**Disadvantages**:
- **Resource Intensive**: Requires double the resources since both environments need to be maintained.
- **Complexity**: More complex to manage due to the need for traffic switching.

**Use Cases**:
- Suitable for mission-critical applications where downtime is not acceptable.
- Ideal for environments with sufficient resources to maintain two identical setups.

**Example Configuration Using Istio**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app
spec:
  selector:
    app: my-app-blue
  ports:
  - port: 80
    targetPort: 8080

apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app-blue
  template:
    metadata:
      labels:
        app: my-app-blue
    spec:
      containers:
      - name: my-app-container
        image: my-app:latest

apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app-green
  template:
    metadata:
      labels:
        app: my-app-green
    spec:
      containers:
      - name: my-app-container
        image: my-app:new-version
```

### Summary

| Strategy               | Pros                                                 | Cons                                             | Use Cases                                          |
|------------------------|------------------------------------------------------|--------------------------------------------------|----------------------------------------------------|
| Rolling Update         | High availability, controlled rollout, easy rollback | Requires additional resources, complex to manage | High availability, stateless applications          |
| Recreate               | Simplicity, no resource overlap                      | Downtime during update, not suitable for HA      | Development/testing, acceptable downtime           |
| Canary Deployment      | Risk mitigation, limited user impact                 | Complexity, time-consuming                       | Critical applications, gradual rollouts             |
| Blue-Green Deployment  | Zero downtime, immediate rollback                    | Resource intensive, complex traffic switching    | Mission-critical applications, sufficient resources|

Choosing the right strategy depends on your application's requirements for availability, complexity, and resource utilization. Each strategy has its own advantages and disadvantages, and the best choice will depend on your specific use case and environment.


## Service

* 2 pods are in same container can't be with same port
* Pod is process
* Service is an entry
* Service will have static ip (Service is kind of a load balancer)
* Service will take the responsibility to route the traffic to pods using lables.

### there are 3 types of access the applicaiton
* Nodeport
* ClusterIP
* Load balancer


* Service is namespace sooped and it is spanning across all the nodes
* When you selected the Nodeport type service, service will open port on each node.
* Service is kubernetes object and it is allocated with private IP (not a public ip), so, service can't access from outside.

>kubectl expose deploy nginx --target-port 80 --port 80 --type Loadbalancer