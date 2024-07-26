
# JOBS
* applications never use jobs


## Draining: (Drain + Cordon)
* I will gracefully terminate all the pods on the nodes and I will also make the node unschedulable
## Cordon <-> UnCordon
 * **Cordon** I will mark the node as unschedulable

* Once execute below command, you can see that **SchedulingDisabled** on the node status

```
 kubectl cordon worker-2
 ```

 * When cordon the node it won't allow new pods schedule to that particular node. but existing pods will run as usual

 
```
 kubectl uncordon worker-2
```

* using **drain** command, node will be cordon.
  - Error: unable to drainnode "worker-2" due to error: [cannot deleteDaemonSet-managedpods ( use--ignore-daemonsetsto force to override): bought/nginx-pod, default/only-pod..]
  *cannot delete pods declare no controller (use --force to override)
```
kubectl drain worker-2
```
```
 kubectl uncordon worker-2 --ignore-daemonsets --force
```
warning: deleting pods that declare nocontoller, ignoring daemonset-managed pods

---
In Kubernetes, objects are categorized based on their scope: **namespace-scoped**, **cluster-scoped**, or **non-scoped**. Here’s a breakdown of these scopes:

### Namespace-Scoped Objects

Namespace-scoped objects exist within a specific namespace. They are isolated to that namespace, and their names must be unique within that namespace.

- **Pod**: A group of one or more containers.
- **Service**: A stable network endpoint for accessing a set of pods.
- **ReplicationController**: Ensures that a specified number of pod replicas are running.
- **Deployment**: Manages a ReplicaSet and provides declarative updates to pods.
- **StatefulSet**: Manages stateful applications with persistent identities.
- **DaemonSet**: Ensures that all (or some) nodes run a copy of a pod.
- **Job**: Creates one or more pods and ensures that a specified number of them successfully terminate.
- **CronJob**: Manages jobs that run on a scheduled time.
- **ConfigMap**: Stores configuration data that can be consumed by pods.
- **Secret**: Stores sensitive data, such as passwords and tokens.
- **ResourceQuota**: Provides constraints for resource usage within a namespace.
- **LimitRange**: Sets constraints on resource usage within a namespace.
- **NetworkPolicy**: Defines network access policies for pods.

### Cluster-Scoped Objects

Cluster-scoped objects exist across the entire cluster and are not confined to any single namespace. They are unique across the cluster.

- **Node**: Represents a worker node in the cluster.
- **Namespace**: Defines a logical partitioning of cluster resources.
- **ClusterRole**: Defines permissions across the entire cluster.
- **ClusterRoleBinding**: Binds ClusterRoles to users, groups, or service accounts at the cluster level.
- **StorageClass**: Defines different classes of storage that can be used for persistent volumes.
- **PersistentVolume**: Represents storage resources in the cluster.
- **PersistentVolumeClaim**: Requests storage resources, bound to PersistentVolumes.
- **CustomResourceDefinition (CRD)**: Defines custom resources that extend Kubernetes capabilities.
- **HorizontalPodAutoscaler**: Automatically scales the number of pods in a deployment or replica set based on observed CPU utilization or other select metrics.

### Objects Not Part of Either Namespace or Cluster Scope

- **PodTemplate**: A specification for creating pods, usually defined within other resources like Deployments or StatefulSets. It does not exist independently.

- **ServiceAccount**: While it is scoped to a namespace, it is used by pods for accessing cluster resources. It is not directly tied to either a namespace or a cluster for its own existence but is associated with namespace-scoped objects.

- **ControllerRevision**: Used by StatefulSets to manage revisions of a StatefulSet's controller.

### Summary Table

| Scope          | Objects                                                            |
|----------------|--------------------------------------------------------------------|
| **Namespace-Scoped** | Pod, Service, ReplicationController, Deployment, StatefulSet, DaemonSet, Job, CronJob, ConfigMap, Secret, ResourceQuota, LimitRange, NetworkPolicy |
| **Cluster-Scoped**   | Node, Namespace, ClusterRole, ClusterRoleBinding, StorageClass, PersistentVolume, PersistentVolumeClaim, CustomResourceDefinition, HorizontalPodAutoscaler |
| **Non-Scoped**       | PodTemplate (part of other objects), ServiceAccount (used in namespaces but not a standalone scope), ControllerRevision |

This classification helps in understanding how Kubernetes objects are managed and how their scope affects resource allocation, access control, and object management within the cluster.