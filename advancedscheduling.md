
To by pass the scheduler and get scheduling under your controll, you can use advanced scheduling

* Below concepts are important for advanced schedulig.

 - **Node Name**
 - **Node selector**
 - **Affinity & antiaffinity**
 - **Taints & toleration**


### Node Name
* Below manifest will try to deploy pod in worker-2 node only. in case worker-2 is not available, pod will be in __pending__ state. Even you have number other nodes, pod won't deployed to another nodes as you mentioned the **nodeName** in the manifest.

 ```
 apiVersion: v1
 kind: Pod
 metadata:
    name: nodename-pod
spec:
    nodeName: worker-2
    containers:
    -  image: nginx
       name: nginx
 ```

 ### Node Selector
 
 - Select based on label instead of Node Name, Node must have a label while creating. with Node selector approach, multiple matching nodes will provide the option deploy the POD


* Command to see the labels on node
```
 kubectl get nodes --show-lables
 ```

* Command to update lable on the node
  - note: if you oberve syntax, there is no **create** phrase in the command syntax for label creation
```yaml
# Labels on Node
 kubectl label node <Node_Name> disktype=ssd
 kubectl label node worker-2 disktype=ssd

# Label's on POD
kubectl label pod pod1 app=web
kubectl label pod pod2 app=web
kubectl label pod pod1 environment=development
kubectl label pod pod2 environment=production


 kubectl get nodes --show-labels | grep -i ssd
 kubectl get pods -l environment=production

 ```

* NodeSelector example for Deployment manifest
```
apiVersion: v1
kind: Deployment
metadata:
  name: my-deploy
spec:
    replicas: 1
    selector:
      matchLabels:
        env: test
    template:
      metadata:
        labels:
          env: test
      spec:
        containers:
        -  image: nginx
           name: nginx
        nodeSelector: 
          disktype: ssd
```

* if the nodeselector is removed, it won't effect the running pod.

* A node selector is used, during the placement of the pod, not during the execution of the pod

* When we remove the label of the node and then if pod is terminated due to some reason, and when the new pod is getting created, will the pods be created or not?
 - **Pod won't be created instead it will be in pending state.**

* Below command would help to remove the label from the node

```
kubectl label node workder-2 disktype-
```
* To deploy the pod on nodes, scheduler will follow some criteria based on filtering and scoring.

* Filtering:
  -  Filter all the nodes in the cluster who are healty

* Scoring:
-  Scoring is equivalent of assigning them a weitage value

![Node Filters](/images/Node_filter.png)

* Based on below points schedular will take the decission
  - Does the node have adequate hardware resources?
  - Is the node running out of resources/capacity?
  - Does the pod requests a specific node?
  - Does the node have matching labels?
  - If the pod requests a port number, is it available on the node?
  - Are taints and tolerations avialable?

  ### Node Affinity -- anti affinity

  * The primary purpose of the Node affinity is to ensure that the pods are hosted on a particular node. Affinity, basically allow multiple condition to choose the node during scheduling where as **nodename** and **nodeselector** allowing the single condition. Node affinity would add more control over other types.

  * **preferredDuringSchedulingIngnoredDuringExecution**: The scheduler tries to find a node that meets the rule. If a matching is not available, the scheduler still schedues the pod.

  * **requiredDuringSchedulingIgnoredDuringExecution**: The scheduler can't schedule the Pod unless the rule is met. This functions like nodeSelector, but with a more expressive syntax

  * **Scheduling:** Create, recretae, scaling
  * **Execution:** Running

  ![scheduling_effinity](/images/Scheduling_affinity.png)

  * affinity is based on multiple conditions, where as Nodename and node selector works based on single condition.

  ```yml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: req-deploy
    spec:
    selector:
        matchLabels:
        app: nginx
    replicas: 2
    template:
        metadata:
        labels:
            app: nginx
        spec:
        containers:
        -  image: nginx
            name: nginx
            ports:
            -  containerPort:80
        affinity:
            nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                -  matchExpressions:
                -  key: disktype
                    operator: I
                    values:
                        - ssd
                        - thin
  ```

* using below command, add label to existing node.
  ```
  kubectl label node worker-1 disktype=ssd --overwrite
  ```

  ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: pref-deploy
    spec:
    selector:
        matchLabels:
        app: nginx
    replicas: 2
    templated:
        metadata:
        labels:
            app: nginx
        spec:
        containers:
        -  image: nginx
            name: nginx
            ports:
            -  containerPort:80
        affinity:
            nodeAffinity:
            preferredDuringSchedulingIgnoredDuringExecution:
              -  weight: 1
                 prefereence:
                   matchExpressions:
                   -  key: disktype
                      operator: I
                      values:
                        - ssd
                        
  ```

  ```
  kubectl api-resources
  ```
---

  In Kubernetes, **affinity and anti-affinity rules** are used to influence the placement of pods within a cluster. These rules are defined in the pod's specification and help manage how pods are scheduled on nodes based on various criteria. There are two main types of these rules: **node affinity** and **pod affinity/anti-affinity**. Both types have similar components: `preferredDuringSchedulingIgnoredDuringExecution` and `requiredDuringSchedulingIgnoredDuringExecution`.

### preferredDuringSchedulingIgnoredDuringExecution vs. requiredDuringSchedulingIgnoredDuringExecution

These terms define the behavior of affinity rules concerning pod scheduling and runtime conditions.

#### preferredDuringSchedulingIgnoredDuringExecution

- **Description:** Specifies a preference (soft requirement) for pod placement but does not mandate it. This means Kubernetes will try to place the pod on nodes that match the criteria specified in the rule, but it won't prevent the pod from being scheduled if those nodes are not available.
- **Behavior:** 
  - **During Scheduling:** The scheduler attempts to place the pod on a node that matches the affinity rule, but if no such nodes are available, it will still schedule the pod on a node that does not match the criteria.
  - **Ignored During Execution:** Once a pod is running, the rule does not affect the pod's placement, even if conditions change (e.g., other pods move or are deleted).

- **Use Case:** Suitable for optimizing resource usage or performance without strict requirements. For example, you might prefer that certain pods are co-located on the same node for performance reasons, but it's not critical if they aren't.

#### requiredDuringSchedulingIgnoredDuringExecution

- **Description:** Specifies a strict requirement (hard requirement) for pod placement. This means that Kubernetes will only schedule the pod on a node that satisfies the criteria specified in the rule.
- **Behavior:** 
  - **During Scheduling:** The scheduler will only place the pod on nodes that match the required conditions. If no such nodes are available, the pod will remain unscheduled.
  - **Ignored During Execution:** Similar to `preferredDuringSchedulingIgnoredDuringExecution`, these rules are ignored once the pod is running. If the conditions change after the pod has been scheduled, it will not be rescheduled based on this rule.

- **Use Case:** Necessary when the placement of pods must strictly adhere to certain conditions, such as **compliance**, **data locality**, or **specific hardware** requirements.

### Example Scenarios

- **Node Affinity Example:**
  ```yaml
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: "disktype"
            operator: In
            values:
            - "ssd"
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: "region"
            operator: In
            values:
            - "us-east-1"
  ```
  - In this example, `requiredDuringSchedulingIgnoredDuringExecution` ensures that the pod is only scheduled on nodes with SSD disks, while `preferredDuringSchedulingIgnoredDuringExecution` indicates a preference for nodes in the `us-east-1` region, but doesn't mandate it.


### Operators in `matchExpressions`

- **`In`**: Matches if the node label's value is in the specified list of values.
- **`NotIn`**: Matches if the node label's value is not in the specified list of values.
- **`Exists`**: Matches if the node label exists (regardless of its value).
- **`DoesNotExist`**: Matches if the node label does not exist.
- **`Gt`**: Matches if the node label's value is greater than the specified value.
- **`Lt`**: Matches if the node label's value is less than the specified value.


- **Pod Affinity Example:**
  ```yaml
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: "app"
            operator: In
            values:
            - "frontend"
        topologyKey: "kubernetes.io/hostname"
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        podAffinityTerm:
          labelSelector:
            matchExpressions:
            - key: "app"
              operator: In
              values:
              - "backend"
          topologyKey: "kubernetes.io/hostname"
  ```
  - Here, `requiredDuringSchedulingIgnoredDuringExecution` mandates that pods are scheduled on the same node (hostname) as other pods with the label `app=frontend`. Meanwhile, `preferredDuringSchedulingIgnoredDuringExecution` indicates a preference for being co-located with pods labeled `app=backend` but doesn't require it.

These rules provide flexibility in managing pod placement within a Kubernetes cluster, balancing between strict requirements and preferences based on application and operational needs.


### Types of Affinities

1. **Node Affinity**
   - Node affinity is used to control which nodes a pod can be scheduled on based on node labels.
   - This can be thought of as an advanced version of `nodeSelector`, which allows for more complex rules.
   - There are two types:
     - **`requiredDuringSchedulingIgnoredDuringExecution`**: Mandatory rules that must be met during scheduling.
     - **`preferredDuringSchedulingIgnoredDuringExecution`**: Preferred rules that the scheduler will try to satisfy but can ignore if necessary.

2. **Pod Affinity**
   - Pod affinity is used to schedule pods to be co-located on nodes with other pods based on labels.
   - This is useful when you want pods to be placed close to each other, for example, for performance reasons (e.g., caching).
   - Like node affinity, it also has two types:
     - **`requiredDuringSchedulingIgnoredDuringExecution`**: Mandatory rules for co-locating pods.
     - **`preferredDuringSchedulingIgnoredDuringExecution`**: Preferences for co-locating pods that are not mandatory.

3. **Pod Anti-Affinity**
   - Pod anti-affinity is the opposite of pod affinity. It is used to avoid scheduling pods on the same nodes as other pods based on labels.
   - This is useful for spreading pods across nodes for high availability (e.g., ensuring that replicas of a pod are not placed on the same node).
   - It also has two types:
     - **`requiredDuringSchedulingIgnoredDuringExecution`**: Mandatory rules to avoid co-locating pods.
     - **`preferredDuringSchedulingIgnoredDuringExecution`**: Preferences to avoid co-locating pods that are not mandatory.


### When to Use Which Affinity?

- **Node Affinity**: Use when you need to control pod placement based on the characteristics of the nodes themselves (e.g., hardware, location).
- **Pod Affinity**: Use when you need pods to be placed near other pods (e.g., for performance, data locality).
- **Pod Anti-Affinity**: Use when you need to spread pods across nodes for high availability (e.g., to avoid having all replicas of a service on the same node).

### Practical Use Cases

- **Node Affinity**: Deploy a pod only on nodes with SSD storage.
- **Pod Affinity**: Deploy pods in the same node or zone for better network latency.
- **Pod Anti-Affinity**: Distribute replicas of a service across different nodes to ensure availability.

### `Taints & Tolerations`

  * Is node is in the positions to take the certain pods? is the criteria to consider for Taintns

  * Nodes can tainted to decide wether to accept the pod or not
  * Taints are applied on node level
  * Tolerations are set on Pods
  * Nodes can have labels as well.
  * Nodeselector at Pod level.

* Basic deployment command
```yaml

# To create a Kubernetes Deployment using the kubectl command, you can use the following command syntax:

kubectl create deployment <deployment-name> --image=<image-name> --replicas=<number-of-replicas> --dry-run=client -o yaml > deployment.yaml


kubectl create deployment nginx-deployment --image=nginx --replicas=3

kubectl create deploy nginx-deploy --image nginx --replicas 10
```

* Update the Image in the Deployment:

```yaml
kubectl set image deployment/nginx-deployment nginx=nginx:1.19
```
* Scale the Deployment:
```yaml
 kubectl scale deployment nginx-deployment --replicas=5
```
* When cluster is created through kubeadm, master node is tainted by default with `"NoSchedule"`. That's why nodes are not deployed on master node. Where as worker nodes won't be having any taints by default.

* Places a taint on node node1. The taint has key key1, value value1 and taint effect NoSchedule.
```yml

# The kubectl taint command is used to add a taint to a node, which influences the scheduling of pods on that node. When you taint a node, it tells Kubernetes not to schedule pods on that node unless they tolerate the taint.

kubectl taint node worker-1 color=blue:NoSchedule

```

```
kubectl create deploy nginx-deploy --image nginx --replicas 5
```

```yaml
 apiVersion: v1
 kind: Pod
 metadata: 
   name: bluepod
spec:
  nodeSelector:
    color: blue
  containers:
  -  image: nginx
     name: nginx
  tolerations:
  -  key: "color"
     operator: "Equal" # "Exists"
     value: "blue"
     effect:"NoSchedule"
---
 apiVersion: v1
 kind: Pod
 metadata: 
   name: greenpod
spec:
  nodeSelector:
    color: green
  containers:
  -  image: nginx
     name: nginx
  tolerations:
  -  key: "color"
     operator: "Equal" # "Exists"
     value: "green"
     effect:"NoSchedule"
```
To taint a node with multiple labels, you can apply multiple taints to the same node. Each taint is applied individually using the `kubectl taint` command. Here's how you can do it:

### Applying Multiple Taints to a Node

```bash
kubectl taint node worker-1 key1=value1:NoSchedule key2=value2:NoExecute
```

### Example Explanation:

- **`worker-1`**: The name of the node you are tainting.
- **`key1=value1:NoSchedule`**: First taint with key `key1`, value `value1`, and effect `NoSchedule`. This prevents new pods that do not tolerate this taint from being scheduled on the node.
- **`key2=value2:NoExecute`**: Second taint with key `key2`, value `value2`, and effect `NoExecute`. This will evict existing pods that do not tolerate this taint and prevent new ones from being scheduled.

### Example with Three Taints

```bash
kubectl taint node worker-1 environment=production:NoSchedule region=us-west:NoExecute storage=ssd:PreferNoSchedule
```

- **`environment=production:NoSchedule`**: Prevents pods that don't tolerate this taint from being scheduled on the node unless they have a toleration for `environment=production`.
- **`region=us-west:NoExecute`**: Evicts pods that don't tolerate this taint and prevents new pods from being scheduled.
- **`storage=ssd:PreferNoSchedule`**: Kubernetes will try to avoid scheduling pods that don't tolerate this taint on this node, but it's not a strict requirement.

### Removing Multiple Taints

To remove specific taints, you can specify the taints with a `-` at the end:

```bash
kubectl taint node worker-1 environment=production:NoSchedule- region=us-west:NoExecute-
```

This removes the taints with keys `environment=production` and `region=us-west`.

### Adding Tolerations for Multiple Taints in a Pod Spec

If you have multiple taints on a node, you need to add tolerations for each taint in the pod's spec if you want the pod to be scheduled on that node.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: nginx
  tolerations:
  - key: "environment"
    operator: "Equal"
    value: "production"
    effect: "NoSchedule"
  - key: "region"
    operator: "Equal"
    value: "us-west"
    effect: "NoExecute"
  - key: "storage"
    operator: "Equal"
    value: "ssd"
    effect: "PreferNoSchedule"
```

This pod spec allows the pod to tolerate all three taints on the node `worker-1` and can be scheduled there accordingly.
- **Below commands are to add lable to node, observe that no `create` in below command to create the label.**

```
kubectl label node worker-1 color=blue
kubectl label node worker-2 color=green
```

* Below command is used to edit the existing pod using imperative command.

```
kubectl edit pod test-pod
```

Labels in Kubernetes are key-value pairs attached to objects like nodes and pods, providing a powerful way to organize, manage, and select resources. They help in categorizing resources and are used extensively in scheduling, scaling, and monitoring. Below are some practical examples of how labels are helpful in nodes and pods:

### 1. **Node Labels**
Node labels are used to define the characteristics or roles of a node in a cluster. These labels are often used in conjunction with node affinity or node selectors to ensure that specific workloads are scheduled on appropriate nodes.

#### Practical Examples:

- **Role-Based Scheduling:**
  If you have dedicated nodes for different purposes (e.g., frontend, backend, database), you can label them accordingly:
  
  ```bash
  kubectl label node node1 role=frontend
  kubectl label node node2 role=backend
  kubectl label node node3 role=database
  ```

  You can then use a `nodeSelector` in your pod spec to schedule pods on nodes with specific roles:

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: frontend-pod
  spec:
    nodeSelector:
      role: frontend
    containers:
    - name: frontend
      image: nginx
  ```

- **Hardware-Specific Scheduling:**
  If certain workloads require specific hardware (e.g., GPUs or SSD storage), you can label nodes with the relevant hardware information:

  ```bash
  kubectl label node node4 hardware=gpu
  kubectl label node node5 storage=ssd
  ```

  Use node affinity to ensure pods that require these resources are scheduled on the correct nodes:

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: gpu-pod
  spec:
    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
          - matchExpressions:
            - key: hardware
              operator: In
              values:
              - gpu
    containers:
    - name: gpu-container
      image: cuda
  ```

### 2. **Pod Labels**
Pod labels are commonly used to group and select pods for different operations such as service discovery, load balancing, scaling, and monitoring.

#### Practical Examples:

- **Service Discovery:**
  Labels are crucial for services to discover the right set of pods to route traffic to. For example, labeling your pods as `app=web` allows a service to select all web application pods:

  ```bash
  kubectl label pod pod1 app=web
  kubectl label pod pod2 app=web
  ```

  Create a service that selects pods with the label `app=web`:

  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: web-service
  spec:
    selector:
      app: web
    ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  ```

- **Deployment & Scaling:**
  Labels are used in Deployments to identify which pods are part of the deployment. This allows Kubernetes to manage scaling and rolling updates:

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: web-deployment
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: web
    template:
      metadata:
        labels:
          app: web
      spec:
        containers:
        - name: web-container
          image: nginx
  ```

  Here, the deployment ensures that three replicas of the `web` application are running. The `selector` matches pods with the label `app=web`.

- **Environment-Specific Labels:**
  You can use labels to distinguish between different environments like development, staging, and production:

  ```bash
  kubectl label pod pod1 environment=development
  kubectl label pod pod2 environment=production
  ```

  This allows you to easily filter pods based on their environment:

  ```bash
  kubectl get pods -l environment=production
  ```

- **Monitoring and Alerts:**
  Labels can be used by monitoring tools (e.g., Prometheus) to scrape metrics from specific pods or nodes:

  ```bash
  kubectl label pod pod1 monitoring=enabled
  ```

  This label tells the monitoring system to scrape metrics from this pod.

### 3. **Combining Node and Pod Labels:**

Labels on nodes and pods can be combined to achieve more sophisticated scheduling and operational strategies:

- **Compliance and Security Policies:**
  Label certain nodes as compliant for specific workloads (e.g., GDPR compliant nodes):

  ```bash
  kubectl label node node6 compliance=gdpr
  ```

  Ensure that sensitive pods are only scheduled on these compliant nodes:

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
    name: secure-pod
  spec:
    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
          - matchExpressions:
            - key: compliance
              operator: In
              values:
              - gdpr
    containers:
    - name: secure-container
      image: secure-app
  ```

### Summary:

- **Node Labels**: Used for hardware, roles, compliance, and more to control where pods are scheduled.
- **Pod Labels**: Used for grouping, selecting, and managing pods for services, deployments, scaling, and monitoring.
- **Combined Use**: Enables complex scheduling policies, resource management, and operational efficiency.

These examples show how labels are a fundamental feature in Kubernetes that enable flexible, powerful ways to manage workloads in your cluster.