### **Kubernetes PDB (PodDisruptionBudget)**

A **PodDisruptionBudget (PDB)** is a Kubernetes object that ensures a certain number or percentage of Pods in a **Deployment**, **ReplicaSet**, or **StatefulSet** remain available during voluntary disruptions. Voluntary disruptions include actions like node drains for maintenance or Kubernetes cluster upgrades, as opposed to involuntary disruptions such as hardware failures.

PDBs help maintain the availability of your application during disruptions by controlling the minimum number of Pods that must be available at any time.

### **How PDB Works:**
- A **PDB** specifies the **minimum** number or percentage of Pods that must remain available during a disruption.
- Kubernetes uses the PDB to ensure that the number of Pods in a Deployment does not fall below the specified threshold during voluntary disruptions.
- A PDB does **not** prevent involuntary disruptions (e.g., node failures), but it does protect against scenarios like manual Pod evictions or node drains.

### **Key Concepts:**
- **`minAvailable`**: The minimum number of Pods that should remain running during a disruption.
- **`maxUnavailable`**: The maximum number of Pods that can be unavailable during a disruption.

### **Why Use PDB?**
- **High Availability**: PDB ensures that a sufficient number of Pods remain available to handle traffic and maintain service availability during maintenance.
- **Controlled Downtime**: When you are performing node upgrades, you can safely drain nodes without affecting service availability beyond the PDB's limits.
- **Avoid Total Outages**: By ensuring that not all Pods are evicted simultaneously, PDBs protect your services from experiencing total outages during voluntary disruptions.

### **PDB Example:**

Let’s assume you have a Deployment with 5 replicas and want to ensure that at least 3 Pods are available at any given time.

You can create a PDB for this Deployment as follows:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-app-pdb
spec:
  minAvailable: 3  # Ensure that at least 3 Pods are available at any time
  selector:
    matchLabels:
      app: my-app  # Selector to match the app's Pods
```

- **`minAvailable: 3`**: Ensures that at least 3 Pods are running and available.
- **`selector`**: Specifies the label selector to apply this PDB to the Pods of a specific application.

In this example:
- If you drain a node, Kubernetes ensures that no more than 2 Pods are disrupted at once, maintaining at least 3 Pods running at all times.
- If Kubernetes cannot meet the PDB requirements (e.g., it would cause more than 2 Pods to be unavailable), it will prevent further evictions.

### **PDB with `maxUnavailable`:**
Alternatively, you can use the `maxUnavailable` field instead of `minAvailable` to specify how many Pods can be unavailable.

Example:
```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-app-pdb
spec:
  maxUnavailable: 1  # Allow at most 1 Pod to be unavailable
  selector:
    matchLabels:
      app: my-app
```

- **`maxUnavailable: 1`**: This allows Kubernetes to evict up to 1 Pod at a time during voluntary disruptions, ensuring the other Pods remain available.

### **PDB Use Cases:**
- **Node Draining**: When draining a node for maintenance, Kubernetes will check the PDB before evicting Pods, ensuring the specified number of Pods remain available.
- **Rolling Updates**: When performing rolling updates, PDB can prevent excessive downtime by ensuring enough Pods are running during the update process.
- **Cluster Scaling**: If you scale down your cluster, Kubernetes will respect the PDB when removing Pods, ensuring service availability.

### **Checking PDBs:**
You can check the status of existing PDBs using the following command:

```bash
kubectl get pdb
```

This will show you information about the defined PDBs, including how many Pods are allowed to be disrupted at a given time.

To get detailed information about a specific PDB:

```bash
kubectl describe pdb <pdb-name>
```

### **Limitations of PDB:**
- PDBs do not prevent involuntary disruptions like node crashes or network partitions.
- If there are insufficient resources in the cluster to maintain the required Pods, the PDB cannot prevent disruptions (e.g., during resource shortages).

---

### **Summary:**
- **PodDisruptionBudget (PDB)** helps ensure that a minimum number of Pods remain available during voluntary disruptions like node upgrades, scaling, or pod eviction.
- You can specify either a minimum number of Pods that must be available (`minAvailable`) or the maximum number of Pods that can be unavailable (`maxUnavailable`).
- PDBs ensure high availability and minimize disruption during maintenance tasks while giving administrators control over pod availability in cluster operations.