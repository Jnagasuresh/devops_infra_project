
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
```
 kubectl label node <Node_Name> disktype=ssd
 kubectl label node worker-2 disktype=ssd

 kubectl get nodes --show-labels | grep -i ssd
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
* when we remove the lablel of the node and then if pod is terminated due to some reason, and when the new pod is getting created, will the pods be created or not?
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
  - Does the node have matching labes?
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

  ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: req-deploy
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
            requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                -  matchExpressions:
                -  key: disktype
                    operator: I
                    values:
                        - ssd
                        - thin
  ```

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

- **Use Case:** Necessary when the placement of pods must strictly adhere to certain conditions, such as compliance, data locality, or specific hardware requirements.

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

  ### Taints & Tolerations

  * Is node is in the positions to take the certain pods? is the criteria to consider for Taintns

  * Nodes can tainted to decide wether to accept the pod or not
  * Taints are applied on node level
  * Tolerations are set on Pods
  * Nodes can have labels as well.
  * Nodeselector at Pod level.


```
kubectl create deploy nginx-deploy --image nginx --replicas 10
```

* When cluster is created through kubeadm, master node is tainted by default with "NoSchedule". That's why nodes are not deployed on master node. Where as worker nodes won't be having any taints by default.

* Places a taint on node node1. The taint has key key1, value value1 and taint effect NoSchedule.
```
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

* Below commands are to add lable to node, observe that no `create` in below command to create the label.

```
kubectl label node worker-1 color=blue
kubectl label node worker-2 color=green
```

* Below command is used to edit the existing pod using imperative command.

```
kubectl edit pod test-pod
```