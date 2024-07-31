
* upgrade
* backup
* sts
* crd
* admission controller
* Security context

In Kubernetes, the `kubectl top` command provides resource usage statistics, such as CPU and memory, for nodes and pods. It is a useful tool for monitoring the resource consumption of your cluster and its workloads.

### `kubectl top` Command Usage

1. **Nodes:**
   - To display resource usage for all nodes:
     ```
     kubectl top nodes
     ```
   - This command shows the CPU and memory usage for each node in the cluster, along with the total capacity.

2. **Pods:**
   - To display resource usage for all pods in a specific namespace:
     ```
     kubectl top pods --namespace=<namespace>
     ```
   - To display resource usage for all pods across all namespaces:
     ```
     kubectl top pods --all-namespaces
     ```
   - This command shows the CPU and memory usage for each pod, helping you to monitor the resources consumed by individual workloads.

### Key Output Fields

- **NAME:** The name of the node or pod.
- **CPU(cores):** The amount of CPU currently being used, expressed in cores. For nodes, this includes the total CPU usage by all pods on the node. For pods, this indicates the CPU usage by that pod.
- **MEMORY(bytes):** The amount of memory currently being used, expressed in bytes. This includes the memory used by the processes running within the pods.

### Additional Options

- **--sort-by:** Allows sorting the output by specific fields, such as `cpu` or `memory`.
  ```
  kubectl top pods --sort-by=cpu
  ```
- **--containers:** Shows usage metrics at the container level within pods.
  ```
  kubectl top pods --containers
  ```

### Prerequisites

The `kubectl top` command relies on the **Metrics Server** to collect and aggregate metrics data from the kubelets running on each node. The Metrics Server must be installed and properly configured in your cluster for `kubectl top` to work. If the Metrics Server is not installed or configured, the `kubectl top` command will not be able to retrieve metrics data.

The `kubectl top` command is particularly useful for monitoring and troubleshooting resource usage in a Kubernetes cluster, providing a quick overview of resource consumption that can help in capacity planning, performance tuning, and detecting resource bottlenecks.