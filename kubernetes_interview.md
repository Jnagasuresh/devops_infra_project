
## Kubernetes:
 * Scalability and High availability capability
 * Self Healing capability
 * It helps to run docker more efficiently
 * ContainerD is the lighter version of the Docker.
 * Below are the containerization tools.
    - CRIO
    - ContainerD
    - Docker
## Kubernetes architecture
 * **Master Node**:
   - API Server
   - ControllerManager
   - Scheduler
   - Etcd
   - Kubeproxy
   - Kubectl
   ![kubernetes](/images/k8s_arc.png)
   ![Kubernetes components](/images/kubernetes_components.svg)

 * **Worker Node**
   - Container run time (docker)
   - Kubeproxy
 
 * **API Server**: 
    All the cluster configurations are stored in .kube/config file
   > kubectl config get-context
   > kubectl config use-context <context_name>
   * api server is entry point of the cluster and it helps to authenticate the cluster.
   * AuthN and AuthZ
 * **Controller Manager**: 
 * **Schedular**: 
 * **ETCD Database**: 


KUBERNETES INTERVIEW QUESTIONS

1. What are your main Roles and Responsibilities ?
2. May I know what you did in the past in your projects in the k8s area?
3. What type of cluster creation process did you use, kubeadm, GKE, EKS?
4. Can you please explain about the architecture of k8s and the version you used?
5. Which type of container-pod (like single-pod single container, multi-pod single container) have you used and when do you choose this?
6. What is the basic difference between deployment and stateful-set in Kubernetes?
7. What is the use of a service account?
8. Once you write a deployment and you deploy it upon your cluster, how do you access your application? Is there any way to do it?
Yes, there are several ways to access your application once you have deployed it on your Kubernetes cluster. Here are some common methods:

### 1. **NodePort Service**
A `NodePort` service exposes the service on each node's IP at a static port (the NodePort). This makes the service accessible externally on the specified port.

Example:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30007
```
You can then access your application at `http://<NodeIP>:30007`.

### 2. **LoadBalancer Service**
A `LoadBalancer` service provisions an external load balancer in the cloud provider and assigns a fixed, external IP address to the service.

Example:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
```
After deploying this, the cloud provider will allocate an external IP that you can use to access your application.

### 3. **Ingress Controller**
Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.

Example of an Ingress resource:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: my-app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
```
With an Ingress controller configured, you can access your application at `http://my-app.example.com`.

### 4. **Port Forwarding**
Port forwarding allows you to access your application directly from your local machine to a pod in your cluster. This is useful for debugging purposes.

Command:
```sh
kubectl port-forward svc/my-service 8080:80
```
You can then access your application at `http://localhost:8080`.

### 5. **ExternalName Service**
An `ExternalName` service maps a service to a DNS name.

Example:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ExternalName
  externalName: my-app.example.com
```
This redirects the traffic to `my-app.example.com`.

### Summary
- **NodePort**: Exposes the service on a static port on each node.
- **LoadBalancer**: Provisions an external load balancer.
- **Ingress**: Provides HTTP and HTTPS routes.
- **Port Forwarding**: For local access and debugging.
- **ExternalName**: Maps a service to a DNS name.

Each method has its use cases and suitability depending on your needs and the environment in which your Kubernetes cluster is running.
---
9. What is the use of cluster IP in k8s?
10. How did you copy a file from local?
11. . What is the difference between secrets and config maps?
12. Could you please explain the concept of static pods in k8s?

A.
Static pods are a fundamental concept in Kubernetes that allows you to run pods directly under the control of the kubelet on individual nodes, without the involvement of the Kubernetes API server or the control plane. Here’s a detailed explanation:

### Key Characteristics of Static Pods

1. **Node-Level Management**
   - Static pods are managed by the kubelet running on each node. Unlike regular pods, they are not managed by the Kubernetes control plane.
   
2. **Direct Creation and Deletion**
   - Static pods are defined in individual configuration files placed on the nodes, typically in a specific directory. The kubelet watches this directory and creates/deletes the static pods as the configuration files are added or removed.
   
3. **No Replication Controller**
   - Static pods do not have associated controllers (such as Deployment, ReplicaSet, etc.). They are single-instance pods specific to the node on which their configuration resides.

### Use Cases for Static Pods

1. **Critical System Components**
   - Static pods are often used to run essential system components like etcd, kube-proxy, or kube-apiserver in self-hosted Kubernetes clusters.

2. **Bootstrapping a Cluster**
   - They can be used during the initial bootstrapping phase of a Kubernetes cluster to ensure that essential components are running before the control plane is fully operational.

3. **Node-Specific Tasks**
   - Running tasks that are node-specific and do not need to be replicated or managed by the Kubernetes control plane.

### How Static Pods Work

1. **Configuration Files**
   - Static pod configurations are defined in JSON or YAML files. These files must be placed in a directory specified in the kubelet’s configuration (commonly `/etc/kubernetes/manifests`).

2. **Kubelet Watches Directory**
   - The kubelet continuously monitors the specified directory for any changes to the static pod files.

3. **Pod Creation and Deletion**
   - When a new configuration file is added, the kubelet creates the pod on the node. If the file is modified, the kubelet updates the pod. If the file is deleted, the kubelet stops and removes the pod.

4. **Mirror Pods**
   - For visibility in the Kubernetes API, the kubelet creates “mirror pods.” These mirror pods reflect the state of the static pods in the API server, providing a way to monitor and view static pods using standard Kubernetes tools (`kubectl`).

### Example of a Static Pod Configuration

Here’s a simple example of a static pod configuration file:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: static-web
  namespace: kube-system
spec:
  containers:
  - name: web
    image: nginx
    ports:
    - containerPort: 80
```

To deploy this static pod, you would place the above YAML file in the directory watched by the kubelet (e.g., `/etc/kubernetes/manifests`).

### Benefits and Drawbacks

**Benefits:**
- **Simplicity**: Straightforward to set up without needing the Kubernetes control plane.
- **Bootstrap and Recovery**: Useful for bootstrapping and running critical system services.
- **Independence**: Operates independently of the Kubernetes API server, ensuring that critical services remain running even if the control plane is down.

**Drawbacks:**
- **Lack of High Availability**: No built-in mechanism for redundancy or failover.
- **Manual Management**: Requires manual updates and management.
- **Limited Integration**: Limited integration with other Kubernetes features and resources.

### Summary

Static pods provide a way to run essential and node-specific workloads directly under the management of the kubelet. They are particularly useful for bootstrapping clusters, running critical system components, and ensuring that certain services remain available independently of the Kubernetes control plane. However, they come with limitations regarding high availability and integration with the broader Kubernetes ecosystem.
---
13. Why are daemon sets required for k8s?

DaemonSets are a critical Kubernetes resource designed to ensure that a copy of a specific pod runs on all (or some) nodes within a cluster. Here are the key reasons why DaemonSets are required in Kubernetes:

### 1. **Node-Level Services**
DaemonSets are ideal for running node-level services that need to be present on every node in the cluster. Examples include:
- **Log Collection Agents**: Tools like Fluentd, Logstash, or Filebeat.
- **Monitoring Agents**: Solutions like Prometheus node exporter or Datadog agents.
- **Security Agents**: Tools like Falco for runtime security.

### 2. **System Daemons**
They are used for running daemons that provide critical system-level functionality across all nodes. These might include:
- **Networking Tools**: CNI plugins for managing network configurations.
- **Storage Management**: Tools for managing storage volumes and persistent storage access.

### 3. **Configuration Management**
DaemonSets help in deploying configuration updates or scripts that need to be applied uniformly across all nodes.

### 4. **Uniform Deployment**
When there is a requirement to run a specific task on all nodes, such as maintaining configuration consistency, DaemonSets provide a straightforward approach to ensure the task is uniformly deployed.

### 5. **Handling Node Additions**
When new nodes are added to the cluster, the DaemonSet automatically schedules the required pods on these new nodes, ensuring they also run the necessary services without additional manual intervention.

### 6. **Cluster Operations**
DaemonSets are useful in performing cluster-level operations, such as:
- **Automated Backups**: Running backup agents.
- **Cluster Health Checks**: Ensuring all nodes are being monitored and are healthy.

### Example of a DaemonSet

Here is a sample YAML file for a DaemonSet that deploys a log collection agent:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-collector
spec:
  selector:
    matchLabels:
      name: log-collector
  template:
    metadata:
      labels:
        name: log-collector
    spec:
      containers:
      - name: log-collector
        image: fluentd:latest
        ports:
        - containerPort: 24224
          name: forward
```

### Summary of Benefits
- **Consistency**: Ensures consistency by running a specific pod on all or selected nodes.
- **Automation**: Automatically handles pods on node addition/removal.
- **Resource Management**: Efficiently manages resources that need to be deployed across the entire cluster.
- **Simplification**: Simplifies the management of node-level services, reducing the need for manual intervention.

In essence, DaemonSets play a vital role in maintaining and managing node-level operations, ensuring that essential services are always up and running across the entire Kubernetes cluster.
  ---
14.  Do you know about high availability on a pod level?
15. You are the K8s admin so, in case at present my cluster is running on 1.20 version, the latest version is 1.21, you need to upgrade your k8s, what are the steps you can follow to do it?
16. Namespace and how to create one? By default how many namespaces available in k8s?
17. Why do we use networking solutions? What’s the use of them?
18. What is the use of PVC ?
19. Do you know about ingress?
20. How did you set up any monitoring tools?
21. Did you face any challenges while you were deploying applications in a Kubernetes cluster or somewhere?
22. .I am given 10 mins of time and I need to deploy 3 applications (3 tier application), which method would you follow?
23. Which one is better: Cloud or Bare metal?
24. While working on your project did you face any issues? For example, image creation like while deploying application onto kubernetes?
25. Is it possible to have a similar container like let's say my application is basically a nginx i'm just running a small application in nginx, so can i have the two instances with the same container type, is it possible in like kubernetes?
26. If it is a different container is it possible to be there in the same part?
27.  Many other containers can be there right so have you worked on any patterns like sidecar ambassador containers?
28. Let's say your container is there so now you have some two replicas, in the beginning it has
29. How many ways you can connect to cluster?

A>
You can connect to a Kubernetes cluster from your laptop using several methods. Each method serves different purposes and offers various levels of interaction with the cluster. Here are the main ways to connect to a Kubernetes cluster from your laptop:

### 1. **kubectl Command-Line Tool**
The most common and versatile way to interact with a Kubernetes cluster is using the `kubectl` command-line tool. 

- **Install kubectl**: Ensure that `kubectl` is installed on your laptop.
- **Configure kubectl**: Use a kubeconfig file to configure access to your cluster. This file typically resides in `~/.kube/config`.

```sh
kubectl config set-cluster my-cluster --server=https://my-cluster-api-server
kubectl config set-credentials my-user --token=my-token
kubectl config set-context my-context --cluster=my-cluster --user=my-user
kubectl config use-context my-context
```

- **Access the Cluster**: Once configured, you can interact with the cluster using `kubectl` commands.

```sh
kubectl get pods
```

### 2. **Kubernetes Dashboard**
Kubernetes Dashboard is a web-based UI for managing Kubernetes clusters.

- **Install the Dashboard**: Ensure the Kubernetes Dashboard is deployed in your cluster.
- **Access the Dashboard**: Typically, you access the Dashboard via a `kubectl proxy` command which opens a proxy to the cluster.

```sh
kubectl proxy
```

- **Open the Dashboard**: Access the Dashboard in your web browser at `http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/`.

### 3. **Lens IDE**
Lens is a powerful Kubernetes IDE that provides a graphical interface for managing Kubernetes clusters.

- **Install Lens**: Download and install Lens from its [official website](https://k8slens.dev/).
- **Add Cluster**: Add your Kubernetes cluster to Lens using the kubeconfig file.
- **Use Lens**: Use Lens to visually manage and interact with your cluster.

### 4. **K9s**
K9s is a terminal-based UI to interact with your Kubernetes clusters.

- **Install K9s**: Install K9s from its [GitHub repository](https://github.com/derailed/k9s).
- **Run K9s**: Simply run `k9s` in your terminal.

```sh
k9s
```

### 5. **SSH Tunneling**
If your cluster's API server is not directly accessible from your laptop, you might need to use SSH tunneling.

- **Create SSH Tunnel**: Use SSH to create a tunnel to your cluster.

```sh
ssh -L 6443:<cluster-api-server>:6443 user@bastion-host
```

- **Configure kubectl**: Point `kubectl` to use the local port.

```sh
kubectl config set-cluster my-cluster --server=https://localhost:6443
```

### 6. **Cloud Provider Interfaces**
If your Kubernetes cluster is hosted on a cloud provider (such as GKE, EKS, or AKS), you can use their interfaces and tools.

- **Google Kubernetes Engine (GKE)**: Use `gcloud` CLI to get credentials.

```sh
gcloud container clusters get-credentials my-cluster --zone my-zone --project my-project
```

- **Amazon Elastic Kubernetes Service (EKS)**: Use `aws` CLI to update kubeconfig.

```sh
aws eks update-kubeconfig --region my-region --name my-cluster
```

- **Azure Kubernetes Service (AKS)**: Use `az` CLI to get credentials.

```sh
az aks get-credentials --resource-group my-resource-group --name my-cluster
```

### 7. **REST API**
Directly interact with the Kubernetes API server using HTTP requests. This method is generally used for automation and scripting.

- **Make HTTP Requests**: Use tools like `curl` or Postman.

```sh
curl -k https://<api-server>/api/v1/pods -H "Authorization: Bearer <token>"
```

### 8. **Kube Forwarder**
Kube Forwarder is a desktop application for managing port forwarding from your clusters.

- **Install Kube Forwarder**: Download from its [official site](https://kube-forwarder.pixelpoint.io/).
- **Configure and Use**: Add your kubeconfig file and start managing port forwarding.

### Summary
- **Command-Line Tools**: `kubectl`, `k9s`
- **Graphical Interfaces**: Kubernetes Dashboard, Lens IDE, Kube Forwarder
- **SSH Tunneling**: Secure connection through an SSH bastion
- **Cloud Provider Tools**: `gcloud`, `aws`, `az` CLIs
- **REST API**: Direct interaction with Kubernetes API using HTTP requests

Each method has its use cases, and the choice of method depends on your specific needs, whether it’s for day-to-day management, development, troubleshooting, or automation.
---

30. what are the common reason to have pod in pendig state and how to solve them?


A.>
Pods in a Kubernetes cluster can enter a "Pending" state for various reasons. Here are some common reasons and how to resolve them:

### 1. **Insufficient Resources**
#### Reason:
The nodes in the cluster do not have enough CPU or memory resources to schedule the pod.

#### Solution:
- **Check Resource Requests and Limits**: Ensure your pod's resource requests and limits are reasonable and within the available resources of the nodes.
  ```sh
  kubectl describe pod <pod-name>
  ```
- **Scale the Cluster**: Add more nodes to the cluster or increase the size of existing nodes to provide more resources.
  ```sh
  kubectl scale --replicas=<desired-number-of-replicas> deployment/<deployment-name>
  ```

### 2. **Unschedulable Nodes**
#### Reason:
All nodes might be tainted in a way that prevents pods from being scheduled.

#### Solution:
- **Check Node Status**: Verify that nodes are ready and schedulable.
  ```sh
  kubectl get nodes
  ```
- **Check Node Taints**: Look for any taints applied to the nodes that could prevent scheduling.
  ```sh
  kubectl describe node <node-name>
  ```
- **Tolerations**: Add tolerations to your pod specification if necessary.
  ```yaml
  tolerations:
  - key: "key"
    operator: "Equal"
    value: "value"
    effect: "NoSchedule"
  ```

### 3. **Affinity/Anti-affinity Rules**
#### Reason:
Pod affinity or anti-affinity rules may restrict the placement of the pod.

#### Solution:
- **Check Pod Affinity/Anti-affinity Rules**: Ensure that the rules specified are achievable given the current state of the cluster.
  ```yaml
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: security
            operator: In
            values:
            - S1
        topologyKey: "kubernetes.io/hostname"
  ```

### 4. **Persistent Volume (PV) Issues**
#### Reason:
The pod is waiting for a Persistent Volume (PV) to be provisioned or bound.

#### Solution:
- **Check PV and PVC**: Ensure that a Persistent Volume Claim (PVC) is correctly bound to a Persistent Volume (PV).
  ```sh
  kubectl get pvc
  kubectl describe pvc <pvc-name>
  ```
- **Provision PVs**: Make sure there are available PVs that match the requirements of the PVC.
  ```yaml
  kind: PersistentVolume
  apiVersion: v1
  metadata:
    name: pv-example
  spec:
    capacity:
      storage: 1Gi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Retain
    storageClassName: manual
    hostPath:
      path: "/mnt/data"
  ```

### 5. **Network Policies**
#### Reason:
Network policies might restrict the pod from establishing necessary connections.

#### Solution:
- **Check Network Policies**: Ensure that the network policies allow the required traffic.
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
    name: allow-all
  spec:
    podSelector: {}
    policyTypes:
    - Ingress
    - Egress
    ingress:
    - {}
    egress:
    - {}
  ```

### 6. **Image Pull Issues**
#### Reason:
There might be issues pulling the container image specified in the pod's definition.

#### Solution:
- **Check Image Pull Policy**: Verify the image pull policy and ensure the image is available in the specified registry.
  ```yaml
  imagePullPolicy: Always
  ```
- **Check Image Secrets**: Ensure that the necessary image pull secrets are configured correctly.
  ```yaml
  imagePullSecrets:
  - name: myregistrykey
  ```

### 7. **Quota Issues**
#### Reason:
The namespace might have resource quotas that prevent additional pods from being scheduled.

#### Solution:
- **Check Resource Quotas**: Ensure that the resource quotas in the namespace allow for the scheduling of the new pod.
  ```sh
  kubectl get quota
  kubectl describe quota <quota-name>
  ```

### 8. **API Server Issues**
#### Reason:
The Kubernetes API server might be experiencing issues, preventing the scheduling of new pods.

#### Solution:
- **Check API Server Health**: Ensure the API server is running and healthy.
  ```sh
  kubectl get componentstatuses
  ```

### Summary
To resolve pods in a "Pending" state, it's essential to systematically check for common issues such as resource availability, node status, affinity rules, persistent volumes, network policies, image pull issues, quota limitations, and API server health. Using `kubectl describe pod <pod-name>` often provides valuable insights into why a pod is not being scheduled.
---

&nbsp;Architecture:

1. Why do we need Kubernetes? What problems does it solve?
    -  Answer: As soon as we decide to use docker/container as platform, we run into new issues such as:
    -           a. orchestration
    -           b. inter-container communication
    -           c. autoscaling
    -           d. observibility
    -           e. security
    -           f. persistent and/or shared volumes
2. Can you explain what the architecture of kubernetes is  ?

A.>
Kubernetes architecture is designed to be modular, scalable, and flexible, enabling efficient management and orchestration of containerized applications. It consists of a set of components that work together to maintain the desired state of your applications. Here’s an overview of the main components and their roles in the Kubernetes architecture:

### 1. **Master Components**
The master components are responsible for managing the Kubernetes cluster. They make global decisions about the cluster (like scheduling) and detect and respond to cluster events (like starting up new pods when the deployment’s `replicas` field is unsatisfied).

- **Kube-API Server**
  - The central management entity that exposes the Kubernetes API. It is the entry point for all administrative tasks.
  - It processes REST operations and updates the state of the API objects in etcd, which is a consistent and highly-available key-value store used as Kubernetes’ backing store for all cluster data.

- **Etcd**
  - A distributed key-value store used to store all cluster data. It stores configuration data, state data, and metadata, providing a consistent and reliable way to store and retrieve critical information.

- **Kube-Scheduler**
  - Responsible for scheduling pods to nodes based on resource requirements and constraints.
  - It watches for newly created pods that have no node assigned and selects a node for them to run on.

- **Kube-Controller-Manager**
  - Runs controller processes, which regulate the state of the system.
  - Includes several controllers, such as the Node Controller, Replication Controller, Endpoints Controller, and Service Account & Token Controllers.

- **Cloud-Controller-Manager (optional)**
  - Runs controllers specific to the cloud provider.
  - It allows the code for interacting with the cloud platform to be isolated from the core Kubernetes code.

### 2. **Node Components**
Node components run on every node, maintaining running pods and providing the Kubernetes runtime environment.

- **Kubelet**
  - An agent that runs on each node. It ensures that containers are running in a pod.
  - It takes a set of PodSpecs that are provided through various mechanisms and ensures that the containers described in those PodSpecs are running and healthy.

- **Kube-Proxy**
  - Maintains network rules on nodes. These rules allow network communication to your pods from network sessions inside or outside of the cluster.
  - It is responsible for implementing part of the Kubernetes Service concept.

- **Container Runtime**
  - The software responsible for running containers. Kubernetes supports several container runtimes: Docker, containerd, CRI-O, etc.

### 3. **Add-ons**
Add-ons are optional but provide essential cluster-level features.

- **DNS**
  - While not strictly part of the core Kubernetes components, DNS is a necessary cluster add-on.
  - It provides a DNS server for a given Kubernetes cluster, making services discoverable by name.

- **Dashboard**
  - A general-purpose, web-based UI for Kubernetes clusters.

- **Cluster-level Logging**
  - Helps in gathering and storing logs.

- **Monitoring**
  - Includes tools like Prometheus for collecting and querying metrics.

### Kubernetes Architecture Diagram

A high-level view of the Kubernetes architecture is typically depicted in a diagram showing the interaction between the master components and node components.

```plaintext
                +-------------------------+
                |     Master Node         |
                |                         |
                |  +------------------+   |
                |  | Kube-API Server  |   |
                |  +------------------+   |
                |           |             |
                |  +------------------+   |
                |  |  Kube-Scheduler  |   |
                |  +------------------+   |
                |           |             |
                |  +------------------+   |
                |  | Controller-Manager|  |
                |  +------------------+   |
                |           |             |
                |  +------------------+   |
                |  |      Etcd        |   |
                |  +------------------+   |
                +-------------------------+
                           |
                           |
        +------------------+------------------+
        |                  |                  |
        |                  |                  |
+-------v-------+  +-------v-------+  +-------v-------+
|   Worker Node |  |   Worker Node |  |   Worker Node |
|               |  |               |  |               |
|  +---------+  |  |  +---------+  |  |  +---------+  |
|  | Kubelet |  |  |  | Kubelet |  |  |  | Kubelet |  |
|  +---------+  |  |  +---------+  |  |  +---------+  |
|  +---------+  |  |  +---------+  |  |  +---------+  |
|  | Kube-    |  |  |  | Kube-    |  |  |  | Kube-    |  |
|  | Proxy    |  |  |  | Proxy    |  |  |  | Proxy    |  |
|  +---------+  |  |  +---------+  |  |  +---------+  |
|  +---------+  |  |  +---------+  |  |  +---------+  |
|  | Container|  |  |  | Container|  |  |  | Container|  |
|  | Runtime  |  |  |  | Runtime  |  |  |  | Runtime  |  |
|  +---------+  |  |  +---------+  |  |  +---------+  |
+---------------+  +---------------+  +---------------+
```

### Summary
Kubernetes architecture is built on a set of master and node components that work together to manage the lifecycle, deployment, and scaling of containerized applications. Master components handle global decision-making and management tasks, while node components manage the pods and containers running on individual nodes. This architecture ensures that Kubernetes can efficiently orchestrate containerized applications in a scalable, resilient, and automated manner.
---
3. What is master node configuration?
4. How many masters are there in your project
5. How many clusters are there in your project ?
6. If there are many clusters, why do we need those many clusters? What's the use of it ?
7. What way is your cluster created ?
8. What's the difference between Kubeadm, kubelet, kubectl
9. Have you ever used a managed kubernetes cluster ?

Security:

1. How are you connecting to your k8s cluster to get the nodes, where have u configured the config
2. What is SSL, and in which areas have you implemented this .
3. How can you have ssl certificates in kubernetes?
4. What's the easiest tool to switch contexts ? kubectx
5. Can you explain the https certificate process?
6. Whats a .csr ?
7. What are the areas we need to concentrate on when thinking about security ?
8. Whats a service account, and in which places have you used that .

Pods/RS/Deployment

1. What is a pod, how does it differs with containers ?
2. How many containers can be accommodated in a pod ?
3. Whats the command to list running pods in a particular namespace
4. What is a namespace and how are you implementing it in your project?
5. What happens if a pod terminates ? in your application, how are you handling this scenario ?
6. What is a Replica Set ?
7. What is a replication controller ?
8. What's the difference between RS and RC
9. In a replica set definition how do we tell the replica set that a set of pods is part of the replica set?
10. When we have Pod, RS<, RC why do we still need Deployment ?
11. If a container keeps crashing, how do you troubleshoot?
    - We can use - -previous option
12. What happens to containers, if they use too much cpu or memory?
    - If too much memory, pods are evicted
    - If too much cp , they are throttled.
13. Are you using an imperative or declarative approach while implementing k8s in your application?
14. Have you ever used explain command
15. "kubectl explain" command is great, but you must know the exact name of the resource (e.g. pod/services/persistentvolume) to get the details, unless you do recursive. How do you get the names of these resources from the command line?
    - Kubectl api-resources
16. List out 2 use cases for Daemonsets and explain why it is more appropriate to use daemonset than deployment for those use case:
17. How to move workload to the new nodepool?
18. Whats the command to run a pod with a label,
19. How can I verify if my imperative command is working or not ?
20. Whats a static pod ?
21. How does static pod differs with regular pod
22. Can k8s api server delete a static pod .
23. What the difference between static pod and mirror pod .
24. If i want to create a static pod , how do i create ?
25. Whats the by default location for static pods
26. Whats the difference between kubectl apply -f file.yaml and kubectl create -f file.yaml
27. If something went wrong with the deployment with latest image, how can we rollback.
28. How to check the status of the last deployment.
29. How can i change / upgrade a the image to a deployment.
30. If i use set image with the same tag, does doeployment triggers a new pods .
31. If you encountered that there is a issue in the deployment, and you want to pause the deployment, is it possible .

Scheduler:

1. What is a scheduler, whats the role of it in kubernetes
2. How can you bypass scheduler .
3. What the main difference between nodeName and nodeSelector in scheduling
4. How can i enforce pods to deploy in a particular node.

Services:

1. What is a Ingress controller ?
2. There are more than one way to implement Ingress? What did you use to implement Ingress?
3. Whats the difference between Ingress and Ingress controller ? Have u ever implemented Ingress in your project , if so where ?
4. Do Managed Kubernetes Custers support Nginx Ingress controller.
5. Can you list few ingress controllers ?
    - HA PROXY, Istio Ingress, Nginx Ingress , GKE Https , AKS, etc
6. How are pods been exposed to outside world, and whats the flow behind it .
7. What are the various types of service available in k8s.
8. WHats the type you have been using in your projects.
9. Why not to go with ClusterIP.
10. If i crate a svc type with ClusterIP, can i access that outside my cluster, if not then whats the way to acces them  
11. Whats the command to describe a service .

Volumes:

1. What exactly is a volume in kubernetes ? what's the main intention to use.
2. What type of data have you stored in volumes, why is that data not been stored in your containers ?
3. Can you explain what is a difference between Persistent volume and volume
4. Elaborate Persistent Volume and Persistent volume claim ?
5. Have you created pv, if so what's the underlying storage
6. How many PVC are there for your project?
7. Scenario: I have a pvc, i need to make sure logs of my dev and test namespaces are being stored in the same pvc i created, how can we do this ?
8. Is there a possibility to store more pvcs for a pod ?
9. How does a PVC find a PV ? What are the conditions ?
10. What's the difference between RWO - ReadWriteOnce, ROX - ReadOnlyMany ,RWX - ReadWriteMany
11. In what cases you generally go with RWX
12. Who creates PV in your project?
    - Admins creates PV ?
    - We gen
13. Have you ever used cloud storage for your application ? If so, what is it ?
14. How can we give different classes of storage to different app teams ?
15. Let's say you are using a pod with pvc from 1 year, suddenly the dev has reported that the storage is filled, how will you handle the situation.
    - Even after multiple attempts, the size is not increasing, what might be the possible scenario,and how u can handle it
16. What happens to pvc, what pod associated with it got deleted.
17. What happens to a pv, when a pvc associate dot it got deleted
18. What happens to the pod, when a pvc got deleted.
19. Can we add a new pvc to deployment on the fly ?
20. Can we use many claims out of a persistent volume ?

RBAC:

1. What is RBAC ?
2. What is a role ?
3. What is the cluster role ?
4. What is role binding ?
5. What is cluster role binding ?
6. How have you implement RBAC in your project ?
7. You have 10 microservices spread across various environments, how will you ensure security of accessing those microservices ?

Scalability

1. How are you managing scalability in Kubernetes
2. What types of scalability can be implemented in k8s.

EnvVariables;

1. If i want to pass some dynamic values to my container, how can i do it .
2. Have you configured Configmaps in your projects, if so how is that been implemented?
3. When to use secrets and when to go with config maps.
4. If we use secrets as imperative command, do we still need to encode it into BASE64
5. How can you encode text passwords into base 64, and how to decode.
6. How many ways can we pass the environmental variable to the container?
7. If I change any config map, will the new change reflect in the container?
8. Can i pass more than one key in config maps data.
9. Are environmental variables encrypted in K8s?

Network Policy:

1. How do pods communicate with each other?
2. Do pods in one namespace can communicate to pods in other namespace .
3. How can we stop the pods been comiinucating to other pods in other namespace.
4. If a user want to communicate to pod at port 80, do we need to open a ingress or egress.
5. Lets say i want to allow port 8080 and deny other ports, how can i implement a network policy to do that
6. In your project, how many netpol do you have, and what are the apps that are been using this .

Troubleshooting:

1. There is pod named foo. it is in crashloopbackoff state. How to find the cause using a kubectl command?
2. Scenario Question: You have a container that keeps crashing because its "command" section has a misspelling. How do you fix this?
3. How to get a yaml file out of running/crashing pod?
4. How can we terminate a pod, before the grace period.