# Set up BARD for Kubernetes cluster
This instructions will help you deploy a BARD instance to your local cluster. 
If you have a production k8s cluster that you want use for BARD, please have a detail look at the deployment yaml files, and `od.config` file.

## Requirements
1. Working K8s cluster
2. `kubectl` command line tool is installed
3. `openssl` and `curl` are installed

## Files

Deployment files are named with 01-XXX etc. All of these need to be deployed. 
If you have existing k8s cluster, before deployment, open each file and modify accordingly.You will need to specify your own namespace and cluster specifics inthe  yaml files.

Deployment yaml files:
- 01-pyos-role.yaml
- 02-mongodb-cm.yaml
- 03-nginx-cm.yaml
- 04-secret-mongodb.yaml
- 05-mongodb-deployment.yaml
- 06-memcached-deployment.yaml
- 07-nginx-deployment.yaml
- 08-speedtest-deployment.yaml
- 09-pyos-deployment.yaml
- 10-openldap.yaml
- 11-services.yaml

## Step 1: Create BARD namespace (optional if you already have a namespace)

    kubectl create namespace bard-desktop

You can replace `bard-desktop` with you own namespace, and make sure this namespace is specified in all yaml files. 
In the following instructions, we assume the namespace is `bard-desktop`

You should read on the output

    namespace/bard-desktop created

## Step2: Secure BARD desktop with JWT tokens

 - The JWT payload is encrypted with the BARD desktop private key by pyos
 - The JWT payload is decrypted with the BARD desktop public keys by nginx.
   
>    Do not publish the public key. This public key must stay private,  
> this is a special case, it's only a more secure option.
   
 - The JSON Web Tokens payload is signed with the BARD desktop  signing private keys
   
 - The JSON Web Tokens payload is verified with the BARD desktop signing public keys.
 - The JSON Web Tokens user is signed with the  user signing private keys by pyos.
 - The JSON Web Tokens user is verified with the user signing public keys by pyos

Create keys

    openssl genrsa -out bard_jwt_desktop_payload_private_key.pem 1024
    openssl rsa -in bard_jwt_desktop_payload_private_key.pem -outform PEM -pubout -out  _bard_jwt_desktop_payload_public_key.pem
    openssl rsa -pubin -in _bard_jwt_desktop_payload_public_key.pem -RSAPublicKey_out -out bard_jwt_desktop_payload_public_key.pem
    openssl genrsa -out bard_jwt_desktop_signing_private_key.pem 1024
    openssl rsa -in bard_jwt_desktop_signing_private_key.pem -outform PEM -pubout -out bard_jwt_desktop_signing_public_key.pem
    openssl genrsa -out bard_jwt_user_signing_private_key.pem 1024
    openssl rsa -in bard_jwt_user_signing_private_key.pem -outform PEM -pubout -out bard_jwt_user_signing_public_key.pem

Create K8s secrets from the keys

    kubectl create secret generic bardjwtdesktoppayload --from-file=bard_jwt_desktop_payload_private_key.pem --from-file=bard_jwt_desktop_payload_public_key.pem --namespace=bard-desktop
    kubectl create secret generic bardjwtdesktopsigning --from-file=bard_jwt_desktop_signing_private_key.pem --from-file=bard_jwt_desktop_signing_public_key.pem --namespace=bard-desktop
    kubectl create secret generic bardjwtusersigning --from-file=bard_jwt_user_signing_private_key.pem --from-file=bard_jwt_user_signing_public_key.pem --namespace=bard-desktop

The output should be as follow:

    secret/bardjwtdesktoppayload created 
    secret/bardjwtdesktopsigning created 
    secret/bardjwtusersigning created

Verify secrets

    kubectl get secrets -n bard-desktop
 The output should be similar to the following:

     NAME                           TYPE                                  DATA   AGE
    default-token-5zknd            kubernetes.io/service-account-token   3      6m6s
    bardjwtdesktoppayload   Opaque                                2      68s
    bardjwtdesktopsigning   Opaque                                2      68s
    bardjwtusersigning      Opaque                                2      67s

 
## Step 3: Download user pod images
This is to make sure that Kubernetes can find docker images at startup time.

    kubectl create -f https://git.embl.de/grp-cbbcs/bard-training/-/raw/main/poduser.yaml

The output should be similar to:

    pod/anonymous-74bea267-8197-4b1d-acff-019b24e778c5 created
Wait for the pod to be `Ready`, this can take some time while container images are downloading

    kubectl wait --for=condition=Ready pod/anonymous-74bea267-8197-4b1d-acff-019b24e778c5  -n bard-desktop --timeout=-1s
 
 Once it shows `condition met` you can delete the user pod.

     pod/anonymous-74bea267-8197-4b1d-acff-019b24e778c5 condition met
     
 Delete the user pod

    kubectl delete -f https://git.embl.de/grp-cbbcs/bard-training/-/raw/main/poduser.yaml

## Step 4: Download and create the bard desktop config file

Download the config file for pyos control plane

    curl https://git.embl.de/grp-cbbcs/bard-training/-/raw/main/od.config

Create configmap `bard-config` in the `bard-desktop` namespace

    kubectl create configmap bard-config --from-file=od.config -n bard-desktop

The output should be similar to 

    configmap/bard-config created

## Step 5: Create pods and services
The deployment yaml files contains definitions for all roles, service account, pods and services needed.
```
    kubectl create -f BARD_DEPLOYMENT_YAML_FILES
```
You should run this command for each yaml.

If this is successful, you should read output similar to below:

    clusterrole.rbac.authorization.k8s.io/pyos-role created
    clusterrolebinding.rbac.authorization.k8s.io/pyos-rbac created
    serviceaccount/pyos-serviceaccount created
    configmap/configmap-mongodb-scripts created
    configmap/nginx-config created
    secret/secret-mongodb created
    deployment.apps/mongodb-od created
    deployment.apps/memcached-od created
    deployment.apps/nginx-od created
    deployment.apps/speedtest-od created
    deployment.apps/pyos-od created
    endpoints/desktop created
    service/desktop created
    service/memcached created
    service/mongodb created
    service/speedtest created
    service/nginx created
    service/pyos created
    deployment.apps/openldap-od created
    service/openldap created

Note: If you are deploying to existing k8s cluster, contact your cluster administrator to make sure you have appropriate permission for service account, role bindings etc.

## Step 6: Verify Pods
Once the pods are created, all of them should be in `Running` status.

    kubectl get pods -n bard-desktop
The output should be:

    NAME                            READY   STATUS    RESTARTS   AGE
    memcached-od-57c57c4f9d-92fs2   1/1     Running   0          59m
    mongodb-od-f69ff6b5b-v6ztc      1/1     Running   0          59m
    nginx-od-58f86c4dc8-8n9lf       1/1     Running   0          59m
    openldap-od-d66d66bf4-84lg8     1/1     Running   0          59m
    pyos-od-5586b88767-6gdtk        1/1     Running   0          59m
    speedtest-od-6c59bdff75-n6s66   1/1     Running   0          59m

## Step 7: Connect to your local BARD

 1. Open your browser and navigate to http://localhost:30443 Click on
 2. Connect with Anonymous button.
 3. You should see your desktop in browser in a few seconds

## Step 8: Using ingress controller (for existing cluster)
- If your cluster has ingress controller, you will need to contact your local admin to find out the specifics.
- After you know the details about your ingress controler, modify ingress-external.yaml and deploy it.
- You may also need to ask your local admin about network policies for your k8s cluster.
- Modify netpol-default.yaml with you own network policies and deploy it.

## Step 9: GPUs (existing cluster)

- Each cluster is different and may require different configurations for GPUs.
- You may need to specify `Toleration` or `Affinity` in the deployment yaml files, if you need any of the container to use your GPU.
- If you would like use desktop to have 1 GPU, modify the od.desktop section in `od.config` file with your own `tolerations` or  `affinity`

By defaults, BARD stores the GPU ID into a ENV variable in your pod to ensure all application containres use the same GPU. 

## Step 10: Persistent Volumes (existing cluster)
- By default, BARD authenticated via Keycloak and LDAP. It assumes that users are already in LDAP, and user home folders exists.
- It also assumes that all users' home folder is a PV already exists in the cluster.
- This behavior can be changed by modifying `od.config`. For example, changing `desktop.homedirectorytype` to `hostPath` will make user home non persistent, and not requiring and PV.
- For details please have a look at the od.config file. You could also refer to `beegfs-scratch-denbi-volume.yaml` as an example of mounting PV to the BARD desktop.
- To summarize the steps you need for mounting PVs
  
    1. make sure your PV exist in your cluster
    2. Modify the `rules` section in od.config,this is to give logged in your a label. This label will then be used to mount PVs (see exmaple at line 184,185,209,210 in od.config)
    3. see exmaple at line 567,568 on how to use these labels to mount PVs

