
### Networking
* Hostport to container port mapping
  - Host (Port customization is not possible)
  - Bridge Network (Port customization is possible)
  - None (No communication)

* Docker Images can be created using running container or using docker file
* Ideal way to create image is using docker file.

## Volumes
> docker ps -a -q
> docker rm $(docker ps -a -q)
> docker run -dit --name web01 -p 8000:800 my-sample-app

* Image is readonly, Image does not have life like
* Container will have life like start, stop, terminate, enter inside the container

### Type of Volumes
* Anonymous volume -(k8s: EmptyDir)
* Named Volume -(k8s: hostpath)
 - Docker will set default path
 - Volume will have specific name and name will be referred in later use

```
 docker volume create volume01
 docker volume inspect volume01

 docker run -dit --name web05 -p 8008:8000 -v volume01:/named_volume_data my-sample-app

 docker exec -it web05 /bin/bash
 ```
* Host Volume -(k8s: hostpath)
   - It can have custom path
* TempFS Volumes  (In memory Database)
    - Redis 
    - Sap HANA

 >   docker run -dit --name web07 -p 8010:8000 --tmpfs /tempfs_data my-sample-app

   - This volume is temporary and it will be wiped of either container terminated or docker server re-start.
   - not useful for prod scenarios


* Azure defender for scanning images
* qualys tools for image scan
* Nessus.

* Cloud Native computing foundation
* cncf.io