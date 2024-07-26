
# Liveness Probe & Readiness Probe

* Container (Application) health is defined with probs concept
* Probe means Health

* Along with pod readiness, we need to tell k8s that container also ready to accepts the requests

* Application livenes probe will help to restart the pod. (**Restart Policy**)
* Readiness probe will help to check helth of the applicaiton. **traffic** will be stopped to particular pad
* based on probes, Service will start redirecting traffic.

* actuator endpoint to check health

* endpoints may return 400, 500 status codes while checking the health

* there are 2 ways to check health
 - Exec way # container ====> command === >
 - http get

 * Dev will check multiple restarts are there in, dev will check memory leaks...active connections to db

 ```
  apiVersion: v1
  kind: Pod
  metadata: 
    name: liveness-pod
  spec:
    containers:
    -  image: busybox
       name: busybox
       command:
       -  'sh'
       -  '-c'
       -  'echo liveness probe && slepp 3600'
       livenessProbe:
         initialDelaySeconds: 5
         exec:
           command: ["echo", "helloworld!"]
 ```

 ```
  apiVersion: v1
  kind: Pod
  metadata: 
    name: liveness-pod-nginx
  spec:
    containers:
    -  image: nginx
       name: nginx
       livenessProbe:
         initialDelaySeconds: 5
         httpGet:
           path: / # /actuator, # health_z
           port: 80 # 8080
 ```

 
 ```
  apiVersion: v1
  kind: Pod
  metadata: 
    name: readiness-pod-nginx
  spec:
    containers:
    -  image: nginx
       name: nginx
       readinessProbe:
         initialDelaySeconds: 5
         httpGet:
           path: /healthy # /actuator, # health_z
           port: 80 # 8080
 ```


>  kubectl describe Pod <podname>
---
## Resources & Requests

* Resources: CPU and Memory considered as a resouces
* Memory -> Bytes
* CPU -> CPU units

* Resources Requests
  - This will allow you to define the amount of resources (CPU, Memory) you expect a container to use.
  - The k8s scheduler will use resources requests to avoid scheduling the pods on the nodes that do not have enough available resources
* Resources Requests & Limits:
  -  this will povide a way for you to limit the amount of resources your container can use.
  -  the container runtime, is responsible for enforcing the limits..

  ```
   apiVersion: v1
   kind: Pod
   metadata:
     name: regular-pod
   spec:
     containers:
     -  image: busybox
        name: busybox
        command:
          -  'sh'
          -  '-c'
          -  'echo k8s!!! && sleep 3600'
        resources:
          requests:
            memory: "128Mi"
            cpu: "250m"
          limits:
           memory: 256 # burstable pods
           cpu: 500 # burstable pods
  ```

  ```
   apiVersion: v1
   kind: Pod
   metadata:
     name: big-pod
   spec:
     containers:
     -  image: busybox
        name: busybox
        command:
          -  'sh'
          -  '-c'
          -  'echo k8s!!! && sleep 3600'
        resources:
          requests:
            memory: "128Mi"
            cpu: "10000m" #10cpus
  ```
## QOS (Quality of service)
  * **your apps will get terminated depending on the requests and limits, and this been managed by a service called Quality of Service (QOS)**
    - Best Effort: pods that does not specify requests and limits into their containers, those pods are considered as lowest priority and these are the one that are most likely to be killed first.
    **BestEffort QoS** is the lowest QoS class. A pod is classified as BestEffort if it does not have any resource requests or limits set. These pods do not have guaranteed resources and will be the first to be evicted under resource pressure.


       #### Use Case for BestEffort QoS

        - **Non-Critical Workloads**: For applications or services that can tolerate interruptions or performance variability, such as batch jobs, development environments, or background tasks.
        - **Resource-Constrained Environments**: In scenarios where resource conservation is crucial, BestEffort pods allow for maximizing resource usage without committing guarantees.

    - **Burstable**:  is assigned to pods that have resource requests and limits set for one or more resources, but the values are not identical, or not all containers have resource requests and limits. This allows the pod to "burst" above its requested resources, up to the specified limits.

        - Pods that has requests and limits defined (obvisouly, limits are larger than request). such pods will be having minimal resource guarenty.
        - when the node is having very pressure, these burstable pods will be terminated when there are no best effort pods 

     

        #### Use Case for Burstable QoS

        - **Flexible Workloads**: For applications that have variable workloads, such as web servers or API endpoints, where traffic can fluctuate, Burstable QoS allows the pod to use additional resources during peak times.
        - **Cost-Sensitive Applications**: Applications that need to balance cost and performance can use Burstable QoS to guarantee a baseline level of resources while allowing for occasional bursts when needed.

    - **Guaranteed**:
      - The pods that have equal amount of resourcesand limits
      - These type of pods are highest priority pods and guaranteed pods not be killed before the above 2
      - Every container in the pod has both cpu and memory resource requests and limits set.
      - The resource requests and limits for cpu and memory are equal for every container in the pod.
       #### Use Case for Guaranteed QoS
          - **Critical Workloads**: For applications that require consistent and reliable performance, such as databases, core services, or critical microservices, using Guaranteed QoS ensures that the necessary resources are always available.
          - **Performance-Sensitive Applications**: Workloads with strict performance requirements, such as high-frequency trading applications or real-time data processing systems, benefit from the resource guarantees provided by this QoS class. 

   * Vertical scalling is prefferrable whne statefull pods are deployed
   * Horizontal scaling is prefferrable when stateless pods are deployed. 


   * Besteffort POD:
    - note: we don't mention QOS explaitly, kubernetes will take based on the manifest, you can see the details in **describe** pod
   ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: best-effort-pod
    spec:
     containers:
     -  image: nginx
        name: nginx
        ports:
        -  containerPort: 80
           protocol: TCP
   ```
* Burstable-pod
  - below pod, request request stated explicitly. now k8s will take QOS class as burstable

   ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: burstable-pod
    spec:
     containers:
     -  image: nginx
        name: nginx
        ports:
        -  containerPort: 80
           protocol: TCP
        resources:
          cpu: 100m
          memory: 100MI
        limits:
          cpu: 200m
          memory: 200Mi # Note that resources and requests are not same here
   ```

   * Guranteed QOS

   ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: guaranteed-pod
    spec:
     containers:
     -  image: nginx
        name: nginx
        ports:
        -  containerPort: 80
           protocol: TCP
        resources:
          cpu: 100m
          memory: 100Mi
        limits:
          cpu: 100m
          memory: 100Mi # **Note that resources and requests are same here**
   ```
---
# Restart Policy
 * **Always (default)**: we shall use this policy for applications that should always be running
 ```
   apiVersion: v1
   kind: Pod
   metadata:
     name: always-pod
   spec:
     restartPolicy: Always
     containers:
     -  image: busybox
        name: busybox
        command:
        - "sh"
        - "-c"
        - "sleep 10"

 ```
 * **OnFailure**: The onfailure policy will restart containers only if the container process exits with an error code. then the container will be determined as unhealthy. We shall use this policy for applications that needs to run succesfully and then stop because of n error.
 ```
   apiVersion: v1
   kind: Pod
   metadata:
     name: onfailure-pod
   spec:
     restartPolicy: OnFailure
     containers:
     -  image: busybox
        name: busybox
        command:
        - "sh"
        - "-c"
        - "sleep 10"
        # - "sleep 10 & randomm" # randomm is not valid command
        
 ```
 * **Never**

  ```
   apiVersion: v1
   kind: Pod
   metadata:
     name: never-pod
   spec:
     restartPolicy: Never
     containers:
     -  image: busybox
        name: busybox
        command:
        - "sh"
        - "-c"
        - "sleep 10 && randomefdf"
        
        
 ```
---
**Can you give me scenarios where Pod is healthy and application is not healthy for any restapi applcation or web application?**

Certainly! In Kubernetes, a pod can be considered "healthy" if it is running and the liveness probe is passing. However, the applications within the pod might not be healthy or fully operational, leading to situations where the pod is up but the application is not functioning as expected. This discrepancy can arise in several scenarios, especially for REST API or web applications:

### Scenarios Where Pod Is Healthy but Application Is Not

1. **Application Initialization Issues**:
   - **Scenario**: The pod is running, but the application requires some initialization steps (e.g., loading configuration, establishing database connections) that haven't completed successfully. The pod is considered healthy because it is running, but the application is not ready to handle requests.
   - **Solution**: Implement a readiness probe to check if the application is fully initialized and ready to accept traffic.

2. **Configuration or Environment Mismatches**:
   - **Scenario**: The application starts but fails to work properly because of misconfigurations, such as incorrect database connection strings, missing environment variables, or incorrect API keys. The pod remains healthy because the container is running, but the application fails to provide its intended service.
   - **Solution**: Use readiness probes to verify critical configuration or perform checks that ensure the application can connect to necessary services.

3. **Partial Failure or Degraded Performance**:
   - **Scenario**: The application experiences a partial failure, such as some endpoints not responding or some functionalities being unavailable due to issues like service dependency failures, resource exhaustion, or internal errors. The liveness probe might still pass if it checks a simple health endpoint, but users experience problems.
   - **Solution**: Implement more comprehensive readiness probes that test the actual availability of essential features or services.

4. **Data Store or External Service Failures**:
   - **Scenario**: The application relies on external services (e.g., databases, third-party APIs) that are down or unreachable. The application itself may not be able to fulfill its responsibilities, but the container and hence the pod might still be considered healthy.
   - **Solution**: Use readiness probes to check connectivity to essential external services and mark the pod as not ready if these services are unavailable.

5. **Resource Constraints Leading to Degraded Performance**:
   - **Scenario**: The application is experiencing performance issues due to CPU, memory, or I/O constraints but has not completely failed. This can result in slow responses or timeouts for users while the pod remains healthy.
   - **Solution**: Implement resource monitoring and auto-scaling policies to ensure the application has adequate resources. Use readiness probes to detect performance degradation and signal unavailability if necessary.

6. **Dependency Misconfigurations or Updates**:
   - **Scenario**: An application may depend on specific versions of dependencies or configurations that have changed unexpectedly, causing runtime errors or degraded functionality. The pod remains healthy because the container is running.
   - **Solution**: Use configuration management tools and readiness probes to ensure that dependencies are correctly configured and functioning.

7. **Bug in Readiness Probe Implementation**:
   - **Scenario**: The readiness probe may not accurately reflect the application's state, either due to a bug in the probe's logic or a change in the application that the probe does not account for.
   - **Solution**: Regularly review and update readiness probes to ensure they correctly assess the application's health and readiness.

### Mitigation Strategies

- **Detailed Readiness Probes**: Use detailed readiness probes that not only check if the application is running but also verify that essential services and endpoints are functional.
- **Monitoring and Alerts**: Implement comprehensive monitoring and alerting systems that go beyond the status of pods to include application-specific metrics and logs.
- **Graceful Degradation**: Design applications to handle failures gracefully, possibly by returning error messages or providing limited functionality instead of failing completely.
- **Health Checks and Circuit Breakers**: Use health checks and circuit breaker patterns to detect and isolate failing services or components within the application.

By carefully designing readiness probes and implementing robust monitoring and error-handling mechanisms, you can better align the perceived health of pods with the actual operational state of the applications they host.
---
In Kubernetes, **liveness probes** and **readiness probes** are mechanisms used to monitor the health and availability of containers within a pod. These probes help Kubernetes manage the lifecycle of pods and ensure that applications are running smoothly and can handle traffic appropriately.

### Liveness Probe

**Liveness probes** are used to determine if a container is still alive and should be kept running. If a liveness probe fails, Kubernetes will restart the container, assuming that something has gone wrong and that restarting the container might solve the issue.

#### Use Cases for Liveness Probes

- **Detecting Deadlocks**: If an application has deadlocked and is no longer able to process requests, a liveness probe can detect this and trigger a restart.
- **Recovering from Non-Recoverable Errors**: If an application enters a state from which it cannot recover (e.g., a serious error that leaves it inoperable), a liveness probe can help by restarting the container.

#### Types of Liveness Probes

1. **HTTP GET**: The kubelet sends an HTTP GET request to the specified path and port. If the response has a status code greater than or equal to 200 and less than 400, the probe is considered successful.
2. **TCP Socket**: The kubelet attempts to establish a TCP connection to the specified port of the container. If it can establish a connection, the probe is successful.
3. **Exec Command**: The kubelet runs a specified command inside the container. If the command exits with a status code of 0, the probe is considered successful.

### Readiness Probe

**Readiness probes** are used to determine if a container is ready to start accepting traffic. If a readiness probe fails, Kubernetes will remove the pod's IP address from the service's endpoints, meaning the pod will not receive any traffic until the readiness probe succeeds.

#### Use Cases for Readiness Probes

- **Startup Delays**: Some applications need time to initialize before they can handle requests (e.g., loading data, initializing caches). A readiness probe ensures that the application only starts receiving traffic when it's ready.
- **Graceful Maintenance**: During updates or maintenance, an application can signal that it's temporarily unable to handle traffic without being terminated.

#### Types of Readiness Probes

The types of readiness probes are the same as those for liveness probes:

1. **HTTP GET**: The kubelet performs an HTTP GET request to check if the application is ready.
2. **TCP Socket**: The kubelet checks if a TCP port is available for the application.
3. **Exec Command**: The kubelet runs a command inside the container to determine readiness.

### Differences Between Liveness and Readiness Probes

| Feature              | Liveness Probe                      | Readiness Probe                      |
|----------------------|-------------------------------------|--------------------------------------|
| **Purpose**          | Checks if the container is alive    | Checks if the container is ready to serve requests |
| **Action on Failure**| Restarts the container              | Marks the pod as not ready, removing it from service endpoints |
| **Scope**            | Lifecycle management                | Traffic management                   |

### Configuration Examples

#### Liveness Probe Example (HTTP GET)

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 3
  periodSeconds: 3
```

#### Readiness Probe Example (Exec Command)

```yaml
readinessProbe:
  exec:
    command: ["cat", "/tmp/healthy"]
  initialDelaySeconds: 5
  periodSeconds: 5
```

In the above examples:
- The liveness probe checks the `/healthz` endpoint every 3 seconds, starting 3 seconds after the container starts.
- The readiness probe checks the existence of the `/tmp/healthy` file every 5 seconds, starting 5 seconds after the container starts.

### Summary

Liveness and readiness probes are essential tools in Kubernetes for ensuring that applications are running correctly and are available to handle traffic. Liveness probes help maintain application availability by restarting containers that are not functioning correctly, while readiness probes ensure that traffic is only sent to containers that are ready to handle it. These probes provide mechanisms for self-healing and graceful handling of application states, contributing to the resilience and robustness of applications deployed in Kubernetes.