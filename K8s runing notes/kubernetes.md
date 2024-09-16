
* Pod will contain one or more containers
> kubectl logs nginx-pod -c httpd
> kubect delete pod 
* Bydefault There is hidden container in each pod. default container is called PAUSE container but it is hidden. The resposibility of PAUSE container is to enable network for other containers in the POD.

### Network communication:
* Container to container in same POD
* POD to POD communication with in same NODE
* POD to POD communication where PODS are spread across different Nodes

### kubernetes CNI Plugins
[CNI plugins](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/)

* **Calico** network plug in. by default, K8s will support basic networking. when 3rd party network plug in installed, it will support advanced networking

* **Cilium** -- another plugin
* **flannel** -- another plugin

* **CNI**: Container network interface
In Azure Kubernetes Service (AKS), the **Container Networking Interface (CNI)** is responsible for the networking of the containers within the Kubernetes cluster. AKS supports multiple CNI plugins, and you can choose the most suitable one depending on your needs.

### Types of CNIs Used in AKS

1. **Azure CNI (Advanced Networking)**
   - **Azure CNI** provides integration between AKS and the Azure Virtual Network (VNet). Each pod gets an IP address from the Azure VNet subnet, allowing pods to communicate directly with other resources within the VNet, like VMs, databases, and other services.
   - **Key features:**
     - Every pod gets a routable IP address from the Azure VNet.
     - It supports network security group (NSG) rules.
     - Better suited for complex networking needs where tight integration with Azure VNet is required.
     - Suitable for production workloads needing advanced networking and secure, isolated environments.
   - **Use case:** Enterprises that need complete integration with existing VNets and want their pods to have their own Azure VNet IP addresses.

2. **Kubenet (Basic Networking)**
   - **Kubenet** is the default, basic networking plugin in AKS, where each node gets an IP address from the VNet, but pods receive a separate IP address from a private IP range allocated by Kubernetes itself.
   - **Key features:**
     - Pods use Network Address Translation (NAT) to communicate with other pods or external services.
     - Pods can communicate with each other using VNet routing, but the IPs are not directly part of the VNet.
     - Easier to manage in smaller clusters with fewer networking needs.
   - **Use case:** Small-scale deployments or environments where simplicity is preferred over deep VNet integration.

3. **Azure CNI Overlay (Preview)**
   - **Azure CNI Overlay** is a new networking option that allows more IP addresses to be available for large clusters, overcoming IP exhaustion challenges seen in large clusters with many nodes.
   - **Key features:**
     - Pods get their IP addresses from an overlay network instead of directly from the VNet IP address pool.
     - Enables the creation of larger clusters without consuming as many IP addresses from the Azure VNet.
     - Still integrates with Azure VNet for VM communication, but pods use the overlay network.
   - **Use case:** Suitable for large-scale Kubernetes clusters where IP exhaustion is a concern and Azure VNet integration is still required.

### Examples of CNI Choices for AKS
- **Azure CNI**:
  ```bash
  az aks create --resource-group myResourceGroup --name myAKSCluster \
    --network-plugin azure --vnet-subnet-id /subscriptions/<sub>/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mySubnet
  ```
- **Kubenet** (default):
  ```bash
  az aks create --resource-group myResourceGroup --name myAKSCluster
  ```
- **Azure CNI Overlay (Preview)**:
  ```bash
  az aks create --resource-group myResourceGroup --name myAKSCluster \
    --network-plugin azure --network-policy azure --enable-cni-overlay
  ```

### Choosing the Right CNI:
- **Azure CNI**: Best for production environments needing full VNet integration and control over pod networking.
- **Kubenet**: Good for small clusters or dev/test environments where simplicity is key.
- **Azure CNI Overlay**: Useful for large-scale clusters to manage IP address availability efficiently.

Each of these CNIs fits different use cases based on scalability, network complexity, and integration requirements.

kubectl get pods -A

kubectl api-resources
---

### Services
 in kubernetes world, Services is the networking object which helps to expose outside world.

 * Service is the abstraction from deploymen to access from outside.
 * Service will be mapped to specific deployment

 * Types of Services
   - ClusterIP
   - NodePort
   - LoadBalancer
       - NodePort doesn’t have such sophisticated traffic management.
       - You have to manually manage security features like IP restrictions, rate limiting, or SSL termination, which requires more operational effort and increases the potential for misconfiguration.
       - Potential for Overload
       - Static Ports are Limited
       - Lack of Fine-Grained Access Control: NodePort services do not inherently provide mechanisms for fine-grained access control, such as authorization, authentication, or IP whitelisting
### Load Balancer

* Layer7 and Layer4
* Path based routing and host based routing
* Layer7 can handle to route multiple applications using path based or host based routing
* But Network load balancer can not handle multiple applications

* Layer 4 LB --> Layer 7 LB (Ingress) --> Deployments (based on routing rules)

### Ingress

* Ingress controller will be managed by Controller manager
* Monitoring current state
* Identify differences if any
* 

> Desired State -> Actual state
* Analyze -> observer -> ACT

> kubectl delete -f .
> kubectl get ingress

![desired state](..\images\desiredstate.jpeg)

## Master Node Components

* 1. API Server
     - Entry point to the cluster
     - Authentication and authrization would happend through API Server
     - Passport is authentication and visa is authorization
     - 
* 2. ETCD
* 3. Control panel
      - Self healing capacity handle by Control panel
      - Fetch the details from schedular
* 4. Schedular
     - Monitor the Worker node capacity and how many nodes are running...
* 5. Cloud component (Managed cluster)

* Kubelet
    - Provide statics about nodes, It will send heart beats, resource utilization, remaining capaciy to schedular
* KubeProxy:
   - Identify nearest pod 


> kubectl config use-context
> kubectl config get-context
