
## Stateful sets
* Stateful sets will create pods in certain order where as deployments don't follow order
* 2nd pod will be created only after 1st pod is deployed and it is fully in running state.
* for example you have 3 pods and you want to delete one. so, last created pod will be deleted first. if you create pod again, the new pod will be created with same name as last deleted one.
* ordered and predictable deployments
* stateful sets, is required PV's and PVC's are mandatory where is pv's and pvc's are optional
* Ensuring dependencies and sequencing
![statefulset](/images/statefulset.png)

* Stateful sets are head less services. automatically POD will have IPaddress.
* Headless Service: Satefulsets automatically create a Headless service, which allows each pod to haveits own DNS entry. this enables direct communication between pods using their unique hostnames.

* STS supports both HPA and VPA.
* Ordered Termination when scaling down

### What is a StatefulSet?

A **StatefulSet** is a Kubernetes workload API object used to manage stateful applications. Unlike other Kubernetes controllers like Deployments, StatefulSets are designed to provide guarantees about the ordering and uniqueness of pods, which are essential for stateful applications that require stable network identifiers, persistent storage, or need to maintain a consistent identity across rescheduling.

**Key Characteristics of StatefulSets:**
1. **Stable, Unique Network Identifiers:** Each pod in a StatefulSet has a stable network identity, maintained across rescheduling, using a predictable hostname format (`<statefulset-name>-<ordinal>`). This stability is crucial for applications where peers need to communicate with each other using known identities.

2. **Ordered, Graceful Deployment and Scaling:** Pods in a StatefulSet are created, deleted, and scaled in a strict, ordered sequence, which helps in managing stateful applications where the sequence of operations is important.

3. **Stable Storage:** StatefulSets can provide each pod with its own persistent volume, which persists even if the pod is rescheduled. This is typically achieved using PersistentVolumeClaims (PVCs) that are uniquely associated with each pod.

4. **Pod Identity:** Pods in a StatefulSet maintain a consistent identity (hostname and storage) across restarts and rescheduling, which is crucial for many stateful applications that rely on consistent configuration or storage.

### Difference Between StatefulSets and Deployments

**1. Pod Identity and Ordering:**
   - **StatefulSet:** Pods have a stable identity (hostname) and are numbered in a sequence. This identity remains the same across restarts and rescheduling. StatefulSets ensure that the ordering of deployment, update, and scaling operations are maintained.
   - **Deployment:** Pods are interchangeable and have dynamically assigned names and identities. They do not maintain order and do not guarantee the sequence of operations.

**2. Use of Persistent Storage:**
   - **StatefulSet:** Each pod can have its own persistent storage, which is not shared with other pods. The storage remains even if the pod is deleted, and it can be reused by a new pod with the same identity.
   - **Deployment:** While Deployments can also use persistent storage, it does not provide any guarantees about pod identity or stable storage. Pods are generally expected to be stateless or to use shared storage solutions.

**3. Network Identity:**
   - **StatefulSet:** Each pod gets a unique, stable network identity. This is important for applications where each pod needs to be individually addressable and discoverable.
   - **Deployment:** Pods are not given stable network identities. They are typically accessed via a Service that balances traffic across the pod replicas.

**4. Scaling and Updates:**
   - **StatefulSet:** Scaling and updates are performed in an ordered manner, with guarantees about the sequence and consistency. For example, pods are updated or deleted one at a time, respecting the ordinal order.
   - **Deployment:** Scaling and updates are typically done in parallel without any order guarantee. This approach is suitable for stateless applications where the order does not matter.

### Real-Time Use Cases for StatefulSets

1. **Databases:**
   - Databases like MySQL, PostgreSQL, Cassandra, and MongoDB often require stable network identities and persistent storage. StatefulSets can ensure that each database instance retains its identity and data even if pods are rescheduled.

2. **Distributed Systems:**
   - Systems like Kafka, Zookeeper, and Redis, which require a known identity for each instance to maintain the correct cluster configuration and state, benefit from the ordered and stable nature of StatefulSets.

3. **Leader-Follower Systems:**
   - In leader-follower setups (e.g., certain configurations of Elasticsearch), StatefulSets can manage the leadership election and ensure the correct ordering and identity for the leader and followers.

4. **Persistent Worker Nodes:**
   - Applications that require a stable set of worker nodes, each with its own unique configuration or state (e.g., unique tasks assigned to each node), can use StatefulSets to manage these nodes.

5. **Legacy Stateful Applications:**
   - StatefulSets are particularly useful for applications that were originally designed to run on traditional infrastructure with fixed IP addresses and persistent storage, as they allow these applications to run on Kubernetes without significant modification.

StatefulSets provide a solution for managing stateful applications in Kubernetes, offering features that cater specifically to the needs of applications that require stability, consistency, and ordered operations.