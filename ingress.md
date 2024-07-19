
```
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

```
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
    - port: 80
      targetPort: 80
      nodePort: 30080  # Optional: specify a fixed node port if required, or let Kubernetes assign a random one
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
```
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
---
```
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
---
```
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
