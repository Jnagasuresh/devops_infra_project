KUBERNETES INTERVIEW QUESTIONS 

1. What are your main Roles and Responsibilities ? 
1. May I know what you did in the past in your projects in the k8s area? 
1. What type of cluster creation process did you use, kubeadm, GKE, EKS?
1. Can you please explain about the architecture of k8s and the version you used?
1. Which type of container-pod (like single-pod single container, multi-pod single container) have you used and when do you choose this?
1. What is the basic difference between deployment and stateful-set in Kubernetes? 
1. What is the use of a service account?
1. Once you write a deployment and you deploy it upon your cluster, how do you access your application? Is there any way to do it? 
1. What is the use of cluster IP in k8s?
1. How did you copy a file from local? 
1. . What is the difference between secrets and config maps?
1. Could you please explain the concept of static pods in k8s?
1. Why are daemon sets required for k8s?
1. ` `Do you know about high availability on a pod level?
1. You are the K8s admin so, in case at present my cluster is running on 1.20 version, the latest version is 1.21, you need to upgrade your k8s, what are the steps you can follow to do it? 
1. Namespace and how to create one? By default how many namespaces available in k8s?
1. Why do we use networking solutions? What’s the use of them?
1. What is the use of PVC ?
1. Do you know about ingress?
1. How did you set up any monitoring tools?
1. Did you face any challenges while you were deploying applications in a Kubernetes cluster or somewhere?
1. .I am given 10 mins of time and I need to deploy 3 applications (3 tier application), which method would you follow?
1. Which one is better: Cloud or Bare metal?
1. While working on your project did you face any issues? For example, image creation like while deploying application onto kubernetes?
1. Is it possible to have a similar container like let's say my application is basically a nginx i'm just running a small application in nginx, so can i have the two instances with the same container type, is it possible in like kubernetes? 
1. If it is a different container is it possible to be there in the same part?
1. ` `Many other containers can be there right so have you worked on any patterns like sidecar ambassador containers? 
1. Let's say your container is there so now you have some two replicas, in the beginning it has

` `Architecture:

1. Why do we need Kubernetes? What problems does it solve?
   1. ` `Answer: As soon as we decide to use docker/container as platform, we run into new issues such as:
   1. `          `a. orchestration
   1. `          `b. inter-container communication
   1. `          `c. autoscaling
   1. `          `d. observibility
   1. `          `e. security
   1. `          `f. persistent and/or shared volumes
1. Can you explain what the architecture of kubernetes is  ? 
1. What is master node configuration?
1. How many masters are there in your project 
1. How many clusters are there in your project ? 
1. If there are many clusters, why do we need those many clusters? What's the use of it ?
1. What way is your cluster created ?
1. What's the difference between Kubeadm, kubelet, kubectl 
1. Have you ever used a managed kubernetes cluster ? 

Security:

10. How are you connecting to your k8s cluster to get the nodes, where have u configured the config 
10. What is SSL, and in which areas have you implemented this . 
10. How can you have ssl certificates in kubernetes? 
10. What's the easiest tool to switch contexts ? kubectx
10. Can you explain the https certificate process? 
10. Whats a .csr ? 
10. What are the areas we need to concentrate on when thinking about security ?
10. Whats a service account, and in which places have you used that .

    Pods/RS/Deployment

18. What is a pod, how does it differs with containers ? 
18. How many containers can be accommodated in a pod ?
18. Whats the command to list running pods in a particular namespace
18. What is a namespace and how are you implementing it in your project? 
18. What happens if a pod terminates ? in your application, how are you handling this scenario ?
18. What is a Replica Set ?
18. What is a replication controller ? 
18. What's the difference between RS and RC 
18. In a replica set definition how do we tell the replica set that a set of pods is part of the replica set?

18. When we have Pod, RS<, RC why do we still need Deployment ? 
18. If a container keeps crashing, how do you troubleshoot?
    1. We can use - -previous option
18. What happens to containers, if they use too much cpu or memory?
    1. If too much memory, pods are evicted
    1. If too much cp , they are throttled. 
18. Are you using an imperative or declarative approach while implementing k8s in your application? 
18. Have you ever used explain command 
18. "kubectl explain" command is great, but you must know the exact name of the resource (e.g. pod/services/persistentvolume) to get the details, unless you do recursive. How do you get the names of these resources from the command line?
    1. Kubectl api-resources
18. List out 2 use cases for Daemonsets and explain why it is more appropriate to use daemonset than deployment for those use case:
18. How to move workload to the new nodepool?
18. Whats the command to run a pod with a label,
18. How can I verify if my imperative command is working or not ? 
18. Whats a static pod ? 
18. How does static pod differs with regular pod 
18. Can k8s api server delete a static pod .
18. What the difference between static pod and mirror pod . 
18. If i want to create a static pod , how do i create ? 
18. Whats the by default location for static pods
18. Whats the difference between kubectl apply -f file.yaml and kubectl create -f file.yaml
18. If something went wrong with the deployment with latest image, how can we rollback. 
18. How to check the status of the last deployment. 
18. How can i change / upgrade a the image to a deployment. 
18. If i use set image with the same tag, does doeployment triggers a new pods . 
18. If you encountered that there is a issue in the deployment, and you want to pause the deployment, is it possible . 

    Scheduler: 

51. What is a scheduler, whats the role of it in kubernetes 
51. How can you bypass scheduler . 
51. What the main difference between nodeName and nodeSelector in scheduling 
51. How can i enforce pods to deploy in a particular node. 

    Services:

55. What is a Ingress controller ? 
55. There are more than one way to implement Ingress? What did you use to implement Ingress?
55. Whats the difference between Ingress and Ingress controller ? Have u ever implemented Ingress in your project , if so where ?
55. Do Managed Kubernetes Custers support Nginx Ingress controller.
55. Can you list few ingress controllers ? 
    1. HA PROXY, Istio Ingress, Nginx Ingress , GKE Https , AKS, etc
55. How are pods been exposed to outside world, and whats the flow behind it . 
55. What are the various types of service available in k8s. 
55. WHats the type you have been using in your projects. 
55. Why not to go with ClusterIP.
55. If i crate a svc type with ClusterIP, can i access that outside my cluster, if not then whats the way to acces them  
55. Whats the command to describe a service . 

    Volumes: 

66. What exactly is a volume in kubernetes ? what's the main intention to use. 
66. What type of data have you stored in volumes, why is that data not been stored in your containers ? 
66. Can you explain what is a difference between Persistent volume and volume
66. Elaborate Persistent Volume and Persistent volume claim ?
66. Have you created pv, if so what's the underlying storage 
66. How many PVC are there for your project? 
66. Scenario: I have a pvc, i need to make sure logs of my dev and test namespaces are being stored in the same pvc i created, how can we do this ? 
66. Is there a possibility to store more pvcs for a pod ? 
66. How does a PVC find a PV ? What are the conditions ?
66. What's the difference between RWO - ReadWriteOnce, ROX - ReadOnlyMany ,RWX - ReadWriteMany
66. In what cases you generally go with RWX 
66. Who creates PV in your project? 
    1. Admins creates PV ? 
    1. We gen
66. Have you ever used cloud storage for your application ? If so, what is it ? 
66. How can we give different classes of storage to different app teams ? 
66. Let's say you are using a pod with pvc from 1 year, suddenly the dev has reported that the storage is filled, how will you handle the situation. 
    1. Even after multiple attempts, the size is not increasing, what might be the possible scenario,and how u can handle it 
66. What happens to pvc, what pod associated with it got deleted. 
66. What happens to a pv, when a pvc associate dot it got deleted 
66. What happens to the pod, when a pvc got deleted. 
66. Can we add a new pvc to deployment on the fly ? 
66. Can we use many claims out of a persistent volume ? 

    RBAC:

87. What is RBAC ? 
87. What is a role ? 
87. What is the cluster role ? 
87. What is role binding ? 
87. What is cluster role binding ? 
87. How have you implement RBAC in your project ?
87. You have 10 microservices spread across various environments, how will you ensure security of accessing those microservices ?

    Scalability

94. How are you managing scalability in Kubernetes 
94. What types of scalability can be implemented in k8s. 

    EnvVariables;

96. If i want to pass some dynamic values to my container, how can i do it . 
96. Have you configured Configmaps in your projects, if so how is that been implemented? 
96. When to use secrets and when to go with config maps. 
96. If we use secrets as imperative command, do we still need to encode it into BASE64
96. How can you encode text passwords into base 64, and how to decode. 
96. How many ways can we pass the environmental variable to the container? 
96. If I change any config map, will the new change reflect in the container? 
96. Can i pass more than one key in config maps data. 
96. Are environmental variables encrypted in K8s?

    Network Policy:

105. How do pods communicate with each other? 
105. Do pods in one namespace can communicate to pods in other namespace . 
105. How can we stop the pods been comiinucating to other pods in other namespace. 
105. If a user want to communicate to pod at port 80, do we need to open a ingress or egress.
105. Lets say i want to allow port 8080 and deny other ports, how can i implement a network policy to do that 
105. In your project, how many netpol do you have, and what are the apps that are been using this . 

     Troubleshooting:

111. There is pod named foo. it is in crashloopbackoff state. How to find the cause using a kubectl command?
111. Scenario Question: You have a container that keeps crashing because its "command" section has a misspelling. How do you fix this?
111. How to get a yaml file out of running/crashing pod?
111. How can we terminate a pod, before the grace period.

