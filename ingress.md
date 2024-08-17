
## Zerodowntime 

* Zonal cluster
* Regional cluster

---

## Ingress Controller
An ingress controller is a key component in Kubernetes for managing external access to services within a Kubernetes cluster. It provides HTTP and HTTPS routing to services based on various routing rules.

### Key Concepts

1. **Ingress Resource**: 
   - A Kubernetes resource that defines the rules for routing external HTTP/HTTPS traffic to services within the cluster. 
   - These rules can include hostnames, paths, and more.

2. **Ingress Controller**: 
   - A specialized load balancer for Kubernetes that implements the Ingress resource.
   - It monitors Ingress resources and configures the underlying load balancer to route traffic according to the defined rules.

### How Ingress Controller Works

1. **Deployment**:
   - Ingress controllers are deployed as pods within the Kubernetes cluster.
   - Examples include NGINX Ingress Controller, Traefik, and HAProxy.

2. **Configuration**:
   - The controller watches for changes to Ingress resources and adjusts the routing rules accordingly.
   - It updates the load balancer's configuration to match the desired state defined in the Ingress resource.

### Benefits

1. **Centralized Routing**:
   - Simplifies managing external access to services by centralizing routing rules.
   - Reduces the need for multiple LoadBalancer services, saving costs.

2. **SSL/TLS Termination**:
   - Ingress controllers can handle SSL/TLS termination, providing a secure entry point to the cluster.

3. **Advanced Routing**:
   - Supports path-based and host-based routing.
   - Can integrate with external authentication, rate limiting, and other advanced features.


### Managing Ingress Controllers

1. **Monitoring**:
   - Use Kubernetes monitoring tools like Prometheus and Grafana to keep an eye on the performance and health of the ingress controller.

2. **Logging**:
   - Enable detailed logging for troubleshooting and auditing purposes.

### Conclusion

Ingress controllers play a vital role in managing external traffic to services in a Kubernetes cluster, offering centralized routing, SSL termination, and advanced routing capabilities. Deploying and configuring an ingress controller is a common task in Kubernetes administration.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blue-app-dep
  labels:
    app: blue-app
spec:
  selector:
    matchLabels:
      app: blue-app
  template:
    metadata:
      labels:
        app: blue-app
    spec:
      containers:
        - name: bluepod
          image: devopswithcloudhub/nginx:blue
          ports:
            - containerPort: 80
```
---

```yaml
apiVersion: v1
kind: Service
metadata:
  name: blue-app-svc
  labels:
    app: blue-app
spec:
  type: NodePort
  selector:
    app: blue-app
  ports:
    - port: 80    # Service Port
      targetPort: 80 # Container Port (application port), most of the times Service port and container ports are same
      nodePort: 30080  # Optional: specify a fixed node port if required, or let Kubernetes assign a random one
```   

### Service Port

**Definition**: The `service port` is the port on the Kubernetes Service that is exposed to other resources within the cluster.

**Usage**:
- It allows other services, pods, or external clients (if using a type like LoadBalancer) to access the Service.
- The service port defines how the Service is exposed and what port clients should use to access it.


### Node Port

**Definition**: The `node port` is a port on each node in the Kubernetes cluster. It allows external traffic to access the service from outside the cluster by exposing the Service on the same port on each node's IP.

**Usage**:
- It provides a way to expose the Service to the outside world on a specific port on each node.
- It is a higher range port (default 30000-32767) that maps to the Service port.


### Target Port

**Definition**: The `target port` is the port on the Pod that the Service forwards traffic to. This is the actual port on which the application is running inside the container.

**Usage**:
- It maps the service port to the container port, allowing the Service to forward incoming traffic to the correct port on the Pods.


### How They Work Together

1. **Service Port**: Exposes the Service to other resources.
2. **Node Port**: Allows external access to the Service via a specific port on each node.
3. **Target Port**: The destination port on the Pod where the application is running.

### Example Flow

1. **Internal Access**: Other Pods or Services access `example-service` on port 80.
2. **External Access**: External clients access the Service on port 30080 on any node's IP.
3. **Traffic Routing**: The Service routes the incoming traffic to port 8080 on the target Pods.


### Visual Representation

```plaintext
+----------------------+       +------------------+
|  External Client     |       |  Internal Client |
|  (Accesses NodePort) |       |  (Accesses Service Port)|
+----------+-----------+       +----------+-----------+
           |                              |
           |                              |
           |                              |
+----------v------------------------------v-----------+
|  Kubernetes Node (NodePort: 30080)                   |
|  +-------------------+      +-------------------+    |
|  |  Service (Port: 80)      |  Service (Port: 80)    |
|  |  +---------------+       |  +---------------+     |
|  |  |  Pod (Target Port: 8080) |  Pod (Target Port: 8080) |
|  |  |                       |  |  |               |
|  +--+-----------------------+  +--+---------------+
+---------------------------------------------------+
```

---

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: green-app-dep
  labels:
    app: green-app
spec:
  selector:
    matchLabels:
      app: green-app
  template:
    metadata:
      labels:
        app: green-app
    spec:
      containers:
        - name: greenpod
          image: devopswithcloudhub/nginx:green
          ports:
            - containerPort: 80
```
---
```
apiVersion: v1
kind: Service
metadata:
  name: green-app-svc
  labels:
    app: green-app
spec:
  type: NodePort
  selector:
    app: green-app
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080  # Optional: specify a fixed node port if required, or let Kubernetes assign a random one
```  
---
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: orange-app-dep
  labels:
    app: orange-app
spec:
  selector:
    matchLabels:
      app: orange-app
  template:
    metadata:
      labels:
        app: orange-app
    spec:
      containers:
        - name: orangepod
          image: devopswithcloudhub/nginx:orange
          ports:
            - containerPort: 80
```
![cloud-ingress-flow](/images/cloud_ingress.png)

* When service is created, automatically network loadbalancer (L4) will be created ( it is not application load balancer)
* When ingress controller is created, application load balancer (L7) will be created.

---
```yaml
apiVersion: v1
kind: Service
metadata:
  name: orange-app-svc
  labels:
    app: orange-app
spec:
  type: NodePort
  selector:
    app: orange-app
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080  # Optional: specify a fixed node port if required, or let Kubernetes assign a random one
```
![Load Balancer](/images/LB.png)
![Ingress controller](/images/ingress.svg)
---
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: context-ingress
  annotations:
    kubernetes.io/ingress.class: "gce"
spec:
  defaultBackend:
    service:
      name: orange-app-svc
      port:
        number: 80
  rules:
    - http:
        paths:
          - path: /blue
            pathType: Prefix
            backend:
              service:
                name: blue-app-svc
                port:
                  number: 80
          - path: /green
            pathType: Prefix
            backend:
              service:
                name: green-app-svc
                port:
                  number: 80

```

* to get load of the cpu's, below command will be usefull.
```
kubectl top pod
```

* HPA vs VPA
* Horizontal Pod autoscalaer vs vertical Pod auto scaler