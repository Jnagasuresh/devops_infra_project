# Volumes:

## Types of volumes
hostPath (k8s) ----- bindmount (docker)
emptydir (k8s) ----- tmpfs (docker)
volumes (k8s) ----- volumes (docker)

## Provisinings:

### there are 2 types of provisinings
 * Static type -> someone creates and I use it
 * Dynamic type

 * Persistent volumes (PV) are at cluster level
 * Persistent volume claims(pvc) are at namespace level.

 * Pv and PVC has one to one binding

 ![volume_dia1](/images/volume1.png)

 [volumes](/docs/svc_volume.pdf)
![Big Picture](/images/storage.png)

* PersistentVolumes (PV)
* PersistentVolumeClaims (PVC)
* StorageClasses (SC)

* While creating the PV, few important things I need 
    name:
    size: 10
    AccessMode: ReadWriteOnce (RWO), ReadOnlyMany, ReadWriteMany (RWX), ReadWriteOncePod

    ![Pv to Pvc flow](/images/PV-Pvc.png)

* Host Path Volume
```
apiVersion: v1
kind: Pod
metadata:
    name: host-pod
spec:
    containers:
        - image: busybox
          name: busybox
          command: ["sh","-c", "echo Success!!! > /output/success.txt"]
          volumeMounts:
            - name: my-volume
              mountPath: /output
    volumes:
        - name: my-volume
          hostPath:
            path: /var/data        
```

* PersistentVolumeReClaimPolicy
  - Retain -- Keep all data
  - Delete --> delete the underlying storage resource automatically (only work in cloud storage resource)
  - Recycle --> delete all the data inthe underlying storage resource

* Persistent Volume

```
apiVersion: v1
kind: PersistentVolume
metadata:
    name: pvvol-1
spec:
    # disk size, access mode,
    capacity:
        storage:1Gi
    accessModes:
    - ReadWriteMany
    persistentVolumeReclaimPolicy: Retain
    # Type of volume for underlying storage. hostpath, nfs, ebs...
    nfs:
        server: 35.184.125.185
        path: /opt/sfw
```

```
 kubectl get pv
```

## PVC
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: boutique-pvc
spec:
    accessModes:
    - ReadWriteMany
    resources:
        requests:
            storage: 500Mi
```

* The binding between pv and pvc is based on accessModes. if accessModes match, then pv and pvc are binded each other

## Respective deployment
![claiming pv](/images/PV-pvc-pod.png)
```
apiVersion: apps/v1
kind: Deployment
metadata: 
  name: pvc-deploy
spec:
  selector:
    matchLabels:
      app: cart
  replicas: 1
  template:
    metadata:
      labels:
        app: cart
    spec:
      containers:
      - image: busybox
        name: busybox
        command: ["sh", "-c", "while true; do echo Siva!!! >> /output/output.txt; sleep 5; done"]
        volumeMounts:
        - name: my-volume
          mountPath: /output
      volumes:
      - name: my-volume
        persistentVolumeClaim:
          claimName: boutique-pv

```

* to debug inside the pod use below command
```
kubectl exec -it <pod_name> /bin/bash

to debug inside output directory
cd /output/
```

## Dynamic provisiong

### Storage Class
  - it will allo k8s admin to specifigy the type of storage service they offer on the k8s

```
  ~/.kube/config
  ```

  ## Storage Class
  ![gcp storage class object by default](/images/gcp_storageclass.png)

* below snipppet it for Storage class
  ```
    apiVersion: storage.k8s.ip/v1
    kind: StorageClass
    metadata:
    name: gold
    provisioner: kubernetes.io/gce-pd
    allowVolumeExpansion: true
    parameters:
    type: pd-ssd

  ```

  ```
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-claim
  spec:
    accessModes:
    -  ReadWriteOnce
    resources:
      requests:
        storage: 20Gi
  ```
  ```
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: pvc-claim
  spec:
    storageClassName: "gold"
    accessModes:
    -  ReadWriteOnce
    resources:
      requests:
        storage: 20Gi
  ```

  ```
apiVersion: v1
kind: Pod
metadatq:
  name: busybox-pod-default
spec:
  Containers:
  -  image: busybox
     name: busybox
     command:['sh','-c','while true; do echo nagas!!! >> /output/output.txt; sleep 5; done']
     volumeMounts:
     -  mountPath: /output/
        name: my-cloud
  volumes:
  -  name: my-cloud
     persistentVolumeClaim:
       claimName: pvc-claim
  ```

  * K8s CICD
  ![Kubernetes Ci CD](/images/cicd.gif)