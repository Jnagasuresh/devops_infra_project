# ConfigMap, Secret

<p>
when we are running applications in kubernetes, you may need to pass dynamic values so your application at the run time.

These are called as application configurations
in k8s, you can store the configurational data in an object called as CONFIGMAP.
</p>

**Configmap, stores the data in the form a key-value pair. this data can be passed to your container applicaiton**

```
kubectl get cm

kubectl create cm firstcm --from-literal=key1=value1 --from-literal=key2=value2
```
* Below manifest file represents ConfifMap. The variation between other manifests and ConfigMap is Spec vs Data.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
    creationTimestamp: <datatime>
    name: firstcm
    namespace: default
data:
    key1: value1
    key2: value2
```
# Secret

```
kubectl create secret
```

* To convert value into base 64
```
echo -n 'password12345' | base64
```
* decode back to original value
 ```
 echo -n '<endocoded_value> | base64 --decode
 ```
 * Encoding|decoding vs Encryption|decryption are different
![pod mapping](/images/configmap_pod_usage.png)

<p>Below file representing multiline text inside the key</p>

 ```
 apiVersion: v1
 kind: ConfigMap
 metadata:
    name: my-config
 data:
    name: Nags
    course: k8s
    key3: |
        hello
        welcome to config maps
        Multiline config
 ```
 **Secret file**

 <p>In secret file secret values should mention in the for, base64 encoding format
 in linux encoding can be taken with below command

 > echo -n <value> | base64

 > echo -n <value> | base64 --decode
 </p>

```yaml
  apiVersion: v1
  kind: Secret
  metadata:
      name: my-secret
  data:
      secret1: <encoded_value>
      secret2: <encoded_value>
```

```
kubectl get secret

kubectl describe secret my-secret
```

* Pod manifest with configmap reference

<p> once config maps are created, one should utilize them in the real time pod, so, Below manifest representing to to utilize configmaps in pod configuration.</P>


```yaml
apiVersion: v1
kind: Pod
metadata: 
  name: env-pod
spec:
  containers:
    - image: busybox
      name: busybox
      command: ['sh', '-c', 'echo configmap is $CONFIGMAPVAR && sleep 3600']
      env:
        - name: CONFIGMAPVAR
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: name

```



```yaml
  apiVersion: v1
  kind: Pod
  metadata: 
      name: configmap-env-pod
  spec:
      containers:
          - image: busybox
            name: busybox
            command: ['sleep', '3600']
            envFrom:
              - configMapRef:
                  name: my-config
```


```yaml
  apiVersion: v1
  kind: Pod
  metadata: 
      name: configmap-secret-pod
  spec:
      containers:
          - image: busybox
            name: busybox
              - name: CONFIGMAPVAR
            command: ['sh','-c', 'while true; do echo Configmap is: $CONFIGMAPVAR and Secret is $SECRETVAR; slepp 10; done']
            env:
              - name: CONFIGMAPVAR
                valueFrom:
                  configMapKeyRef:
                      name: my-config
                      key: name
              - name: SECRETVAR
                valueFrom:
                  secretKeyRef:
                      name: my-secret
                      key: secret1
```


```yml
apiVersion: v1
kind: Pod
metadata: 
    name: my-cm-vol-pod
spec:
    restartPolicy: Never
    containers:
        - image: busybox
          name: busybox
          command: 
            - "sh"
            - "-c"
            - "echo Welcome $(cat /config/name)", you joined $(cat /config/course) && sleep 3600"
          volumeMounts:
            - name: my-vol-cm
              mountPath: /config
    volumes:
        - configMap:
            name: my-config
          name: my-vol-cm


```

* To see the kubernetes environment variables
```
kubectl exec -it <configmap-env-pod> /bin/sh

printenv
```

* **ConfigMaps are namespace scoped**

* To debug/trouble shoot with in the pod in kubernetes, use below method

```
  kubectl exec -it <my-cm-vol-pod> /bin/sh

  after that:

  cd /config/

  ls -la
```

* ConfigMap can be configure as a volume or  environment variable inside the pod
* when configmap is being used as a Environment variables, updated data in configmap won't effect immediately untill respective pod get re-created
* when configmap is being used as a volume, updated data in configmap would  effect immediately 
* Environment variables are static. This means updates you make to the ConfigMap won't show in the container and is the main reason not to use environment variable

* **ConfigMaps:** Used for non-sensitive configuration data. Easily accessible and used to pass environment-specific settings to applications.
* **Secrets:** Used for sensitive data. Provides encrypted storage and controlled access to confidential information.

* What if there is no CONFIGMAP available in kubernetes?
<p>Every time you change the configuration of any app, even a small change like fixing a type, you have to build, test, store, nd re-deploy three images
-- one for dev, one for test and for prod. 
it is also harder to trouble shoot and isolate issues when every update includes the app code and the config

</p>

**API Group**
API Group V1 is Core api, and they are stable and they have been around for a while ( new stuff never goes in the core API group).
You can define and deploy them in yaml
you can manage them with kubectl

* once ConfigMap info is stored, you can use any of the following methods to inject it into containers at run time

1. Environment variables
2. Arguments to the containers startup command
3. Files in a volume


![Configmapss](/images/configmap_arc.png)

* Imperative commands
--from-literal (Literal values on the command line)

--from-file (Files)

```
kubectl get cm

kubectl get cm <cm_name> -o yaml

```

* Imperative way of creating config map

To create a ConfigMap in Kubernetes using the `kubectl` command, you can use the `--from-literal` or `--from-file` options.

### Using `--from-literal`

The `--from-literal` option allows you to directly specify key-value pairs on the command line.

**Example**: Create a ConfigMap with values specified using `--from-literal`.

```sh
kubectl create configmap my-config --from-literal=name=example --from-literal=environment=production
```

This creates a ConfigMap named `my-config` with the following data:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  name: example
  environment: production
```

### Using `--from-file`

The `--from-file` option allows you to create a ConfigMap from files. Each file's content is stored in the ConfigMap under a key named after the file's name.

**Example**: Create a ConfigMap from files.

1. **Create Files**:
   - `config1.txt` with content `example`.
   - `config2.txt` with content `production`.

2. **Create ConfigMap**:
   ```sh
   kubectl create configmap my-config --from-file=config1.txt --from-file=config2.txt
   ```

This creates a ConfigMap named `my-config` with the following data:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  config1.txt: example
  config2.txt: production
```

### Using a Directory with `--from-file`

You can also create a ConfigMap from all files in a directory. Each file will be added as a key-value pair in the ConfigMap.

**Example**: Create a ConfigMap from a directory.

1. **Create Directory and Files**:
   - Directory: `config-dir`
   - Files: `config1.txt`, `config2.txt` (as described above).

2. **Create ConfigMap**:
   ```sh
   kubectl create configmap my-config --from-file=config-dir/
   ```

This will result in a ConfigMap named `my-config` with the contents of each file in the directory stored as key-value pairs.

### Using the ConfigMap in a Pod

You can use the created ConfigMap in your Pod definition.

**Example Pod Definition**:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: env-pod
spec:
  containers:
    - image: busybox
      name: busybox
      command: ['sh', '-c', 'echo configmap is $CONFIGMAPVAR && sleep 3600']
      env:
        - name: CONFIGMAPVAR
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: name
```

This Pod will use the value of `name` from the `my-config` ConfigMap.

### Summary

- **--from-literal**: Directly specify key-value pairs.
- **--from-file**: Create ConfigMap from files, each file's content becomes a key-value pair.
- **--from-file=<directory>**: Create ConfigMap from all files in a directory.

These methods provide flexibility for managing configuration data in Kubernetes.