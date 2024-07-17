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

 ![volume_dia1](/images/volume1.png)

 [volumes](/docs/svc_volume.pdf)
