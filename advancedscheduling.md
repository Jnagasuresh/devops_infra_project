
To by pass the scheduler and get under your controll, you can use advanced scheduling

* below concepts are important for advanced schedulig.

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
* A node selector is used, during the placement of the pod, not during the exdecution of the pod
* when we remove the lablel of the node and then if pod is terminated due to some reason, and when the new pod is getting created, will the pods be created or not?
 - **Pod won't be created instead it will be in pending state.**

* below command would help to remove the label from the node

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
  - does the pod requests a specific node?
  - does the node have matching labes?
  - if the pod requests a port number, is it available on the node?
  - Are taints and tolerations avialable?

  ### Node Affinity -- anti affinity

  * The primary purpose of the Node affinity is to ensure that the pods are hosted on a particular node. Affinity, basically allow multiple condition to choose the node during scheduling where as **nodename** and **nodeselector** allowing the single condition. Node affinity would add more controle over other types.

  * **preferredDuringSchedulingIngnoredDuringExecution**: The scheduler tries to find a node that meets the rule. If a matching is not available, the scheduler still schedles the pod.

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

* When cluster is created through kubeadm, master node is tainted by degault with "NoSchedule". That's why nodes are not deployed on master node. Where as worker nodes won't be having any taints by default.

* Places a taint on node node1. The taint has key key1, value value1 and taint effect NoSchedule.
```
kubectl taint node worker-1 color=blue:NoSchedule

```

```
kubectl create deploy nginx-deploy --image nginx --replicas 5
```

```
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

* Below commands are to add lable to node

```
kubectl label node worker-1 color=blue
kubectl label node worker-2 color=green
```

* Below command is used to edit the existing pod using imperative command.

```
kubectl edit pod test-pod
```