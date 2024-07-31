### How to connect to the respective cluster?

* There will be multiple clusters across project. How can I connect to the correct cluster

* Ingenral, we will connect cluster either from Laptops or Jump Servers

[security context doc](/docks/14.pdf)
Below concepts are very important.
- KubeConfig
- RBAC
- Role/ClusterBindings
- NetworkPolicy

## Authentication and Authorization
There are multiple ways to authenticate to the cluster
  - File -> username/Pwd
  - Username/tokens
  - Certificates
  - LDAP

  * ~/.kube/config
    - clusters
    - contexts
    - users
   #### Use kubeconfig files to organize information about clusters, users, namespaces, and authentication mechanisms. The kubectl command-line tool uses kubeconfig files to find the information it needs to choose a cluster and communicate with the API server of a cluster.

* Symmetric encryption vs Asymmetric encryption
* pki -> public key infrastructure


* To connect the cluster from either laptop or jumbserver, follow below steps
  - Genereate a private key for maha user and certificate signing request as well
  - Generate a self signed certificate. use the CA keys which are provided by the cluster

* To generate private key, use below command
   > openssl genrsa -out maha.key 2048

* To create CSR, use below command, we need to use previously generated key to create CSR
    > openssl req -new -key maha.key -out maha.csr -subj "/CN=maha/O=development"

 * Copy ca.crt and ca.key from cluster to maha user home foler in laptop or jumpserver

> scp ca.crt maha@34.171.18.121:/home/maha
 > scp ca.key maha@34.171.18.121:/home/maha

 * Now generate self signed certificate
   > sudo openssl x509 -req -in maha.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out maha.crt -days 45

 ![CA Cert](/images/cacert.png)

 ---
Creating a self-signed certificate to authenticate and connect to a Kubernetes cluster involves several steps. This process includes generating a private key, creating a Certificate Signing Request (CSR), and then generating a certificate that can be used for Kubernetes authentication. Here’s a step-by-step guide:

### Step 1: Generate a Private Key

First, generate a private key. This key will be used to create a CSR and should be kept secure.

```bash
openssl genrsa -out client.key 2048
```

This command creates a 2048-bit RSA private key and saves it as `client.key`.

### Step 2: Create a Certificate Signing Request (CSR)

Next, create a CSR using the private key. This CSR will include information about the subject (the client, in this case) and will be used to generate the certificate.

```bash
openssl req -new -key client.key -out client.csr -subj "/CN=your-username"
```

Replace `your-username` with the desired Common Name (CN), which typically represents the username that will use the certificate.

### Step 3: Generate a Self-Signed Certificate

Generate a self-signed certificate using the CSR and private key. This certificate will be used for client authentication.

```bash
openssl x509 -req -in client.csr -signkey client.key -out client.crt -days 365
```

This command creates a certificate valid for 365 days. The certificate and key are stored in `client.crt` and `client.key`, respectively.

### Step 4: Configure Kubernetes to Use the Certificate

To use the self-signed certificate for authentication with a Kubernetes cluster, you'll need to configure the Kubernetes `kubectl` command-line tool to use the certificate and key. This involves editing the `kubeconfig` file, usually located at `~/.kube/config`.

You can manually edit the `kubeconfig` file or use `kubectl` commands to set the configuration. Here’s an example of how to do it manually:

#### Example `kubeconfig` Entry

Add or modify a user entry in your `~/.kube/config` file to include the new certificate and key:

```yaml
users:
- name: your-username
  user:
    client-certificate: /path/to/client.crt
    client-key: /path/to/client.key
```

Replace `/path/to/client.crt` and `/path/to/client.key` with the actual paths to your certificate and key files.

#### Using `kubectl` Commands

Alternatively, use `kubectl` to add the user:

```bash
kubectl config set-credentials your-username --client-certificate=/path/to/client.crt --client-key=/path/to/client.key
```

Replace `your-username` with the appropriate username and specify the correct paths to your certificate and key files.

### Step 5: Update Context (if necessary)

If you're using multiple contexts in your `kubeconfig`, make sure to update the context to use the new user credentials:

```bash
kubectl config set-context your-context --user=your-username
```

Replace `your-context` with the name of your context and `your-username` with the username specified in the `users` section.

### Step 6: Test the Configuration

To verify that everything is set up correctly, test your configuration by running a `kubectl` command that requires authentication, such as:

```bash
kubectl get nodes
```

If the setup is correct, you should see the list of nodes in your Kubernetes cluster.

### Important Considerations

- **Security**: Keep your private key (`client.key`) secure and do not share it. Anyone with access to this key can authenticate as the user.
- **Cluster Configuration**: The Kubernetes API server must be configured to accept client certificates as a means of authentication. This typically involves setting up a `ClusterRoleBinding` to grant permissions based on the CN specified in the certificate.
- **Certificate Management**: Self-signed certificates are not trusted by default and are not recommended for production use due to the lack of a trusted certificate authority. Consider using a trusted CA for production environments.

This process sets up client certificate authentication for a Kubernetes cluster, allowing for secure connections using a self-signed certificate.
 ---

 ## kubectl config
 > kubectl config set-credentials --help

 > kubectl config set-credentials mahacreds --client-key=maha.key --client-certificate=maha.crt 

 > kubectl config set-context --help

 > kubectl config set-context dev-gke-context --cluster=ev-cluster --user=mahacreds

 > kubectl config use-context dev-gke-context 

 ## RBAC -- Role based access Control

  * Allows you to control, what users are allowed to do with in the cluster

  * <span style="color:red">Role and Cluster role are k8s objects that define a set of permissions . these permissions deterimin that users cann do in the cluster</span>

  * <span style="color:blue">**Role** : A role defines the permission within a particular namespace</span>
  * <span style="color:green">**Cluster Role**: a cluster role defines cluster-wide permissions and not specific to a particular namespace</span>
 
 * Role Binding: Binding role to user is called Role binding
 * Cluster Role Binding: Binding cluster role to user is called Role binding

 * if config file is in different location, try with below command
 > kubectl get nodes --kubeconfig config

 * **Role**
   -- Roles will have mainly 3 items, resources, verb and group

 ```
  apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata:
    namespace: bout-dev
    name: dev-role
  rules:
  -  apiGroups: [""] # "" indicates the core API group
     resources: ["pods"]
     verbs: ["get", "watch", "list", "create"]
 ```

> kubect get apply -frole.yaml

 > kubectl get roles -n bout-dev

 * Role Binding Yaml
 ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
    name: read-pods
    namespace: bout-dev
    subjects:
    - kind: User # you can mention Group as well
      name: maha # you can mention group name if Kind is Group
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: Role
      name: dev-role
      apiGroup: rbac.authorization.k8s.io
```

>kubectl apply -f rb.yaml -n bout-dev
---



### Network policies

* In k8s, network policies are acting as a firewalls
* By default, kubernetes would allow all the access between pods, as a devops engineer initially we block everything, then open required ports one by one. this will be achieved by Network policies.

* by default 2 pods can connect each other though they are in different namespaces.

* **ingress** (inbound) and **egress** (outbound)

> kubectl get netpol -n bout-dev

* Default deny all namespaces
* By default there is no network policy in k8s cluster. once first netpol is applied first time, technically all other's denied default

```
# Default deny network policy
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: default
spec:
  podSelector: {} # Applies to all the pods in the namespace mentioned
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          namespace: default-ns
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          namespace: default-ns
    ports:
    - port: 53
      protocol: TCP
    - port: 53
      protocol: UDP

```
> kubectl get netpol

```
 # Allow 80 port
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-http-traffic
  namespace: default
spec:
  podSelector: {} # Applies to all the pods in the namespace mentioned
  policyTypes:
  - Ingress
  ingress:
  -  ports:
     -  port: 80
        protocol: TCP
```

* Network policices are handled at namespace level
* Cloud level firewalls will be implemented

## DaemonSet:
 * Automatically runs a copy of a pod on each node.
 * Daemon Set respects normal scheudling rules around taints, nodelabels and tolerations

 Eg: agents like dyntrace will be placed in each node

 ```
  apiVersion: apps/v1
  kind: DaemonSet
  metadata:
    name: my-ds
  spec: 
    selector: 
      matchLabels:
        app: my-ds
    template:
      metadata:
        labels:
          app: my-ds
      spec:
        containers:
        -  image: nginx
           name: nginx
 
 ```
 
 * Automatically DaemonSet will create the pods in all nodes while scheduling rules are respected.
 * Where as Deployments default create one replicaset if you don't mention anything on it.
> kubectl get ds

* the naming convention for Daemonset pod name is start with **kube-proxy** or **weave-net** and followed by random value

In Kubernetes, a DaemonSet ensures that a copy of a specific pod runs on all or a subset of nodes in a cluster. When a new node is added to the cluster, a pod from the DaemonSet is automatically scheduled on the new node. Conversely, when a node is removed from the cluster, the pods running on that node are also deleted.

### Key Features of DaemonSets

1. **Uniform Deployment:** DaemonSets are used for deploying system-level or cluster-wide services that should run on every node.
2. **Node Affinity:** You can control which nodes run the DaemonSet's pods using node selectors, taints, and tolerations.
3. **Pod Management:** DaemonSets handle the lifecycle of pods automatically, ensuring that they are recreated if they are deleted or if a node goes down.

### Real-time Use Cases

1. **Monitoring Agents:** DaemonSets are often used to deploy monitoring agents (like Prometheus Node Exporter) that collect metrics and logs from each node.
2. **Logging Daemons:** Tools like Fluentd or Filebeat are commonly deployed as DaemonSets to aggregate logs from all nodes in the cluster.
3. **Security Agents:** Security tools, such as Intrusion Detection Systems (IDS) or virus scanners, can be run on every node using a DaemonSet.
4. **Networking Solutions:** DaemonSets can be used to deploy networking solutions, such as network proxies, CNI plugins, or VPN clients, on each node.
5. **Node Management:** Tasks like running a kube-proxy or kubelet on every node can be handled using DaemonSets.

DaemonSets provide a straightforward and efficient way to manage these essential services, ensuring they are consistently and reliably deployed across all nodes in a Kubernetes cluster.

 
 ## Static Pod

  * Static pod, is just a pod that is managed direclty by  kubelet on a node and not by kubernetes api server

  * In normal scenario, we will create a yaml file and create it from jump server or lap top to create the pods/deployments and these pods are managed by apiServer or control plane. But in **StaticPod** we need to create individual nodes to do that we need to login nodes independently

  * Kubelet automatically creates a static pod from YAML file located in the manefest path of the node

  * kubelet will create **mirrorpod** for each static pod. kubelet will communicate to apiServer about static pod through mirror pod concept.
  * in case future mirror pod delete, again it will created by kubelet. so, that means, apiserver can't perform any operatio on mirror pod. Static pods managed by kublet.

  * path for static pod yaml: /etc/kubernetes/manifest/1.yaml
  * once you place the pod yaml file in above path, kubeproxy automatically apply and create the pod and you don't need run any apply command manually

  > kubectl get pods -n kube-system

  * The naming convention for usual pod is  **deployment_name-ReplicasetValue-Randomvalue**
  * The nameing convetion for static pod ends with particular node name.
   * eg: kube-controller-manager-master, kube-apiserver-master
 * if you want to remove the static pod remove the yaml file at the path **/etc/kubernetes/manifest**

```
 apiVersion: v1
 kind: Pod
 metadata:
   name: nginx-pod
 spec:
   containers:
   -  name: nginx
      image: nginx
```
  ## Mirror Pods


## HA

Appliction level
Infrastructural level

Control plan Upgrade
Control plane
Data Plane

Zonal cluster
Regional Cluster

Non working day

![High availability](/images/Ha_cluster.png)

* what is autopilot cluster
  - billing would happen POD based not node based.

  > kubectl expose deploy nginx --port 80 --type LoadBalancer

  ![managedCluster](/images/cluster.png)