# Environment overview and configuration
Before getting started configuring our quality gate we will review the build and release process and trigger a full build from development up to production using Jenkins and our applications carts.

## Step 1 - Get into the virtual machine using ssh
In order to get into our working environment we will be using an ssh to conect to our AWS machine. 
```(bash)
 $ ssh username@aws-ip 
 use the ip and password from Dynatrace University
```

## Step 2 - Explore the different namespaces using kubectl
Out of the box we have some applications running in our Kubernetes cluster using k3s. In order to visualize the namespaces where the applications live run 
```(bash)
$ kubectl get namespaces
```
You should see something like the following 

```(bash)
NAME              STATUS   AGE
default           Active   55m
kube-system       Active   55m
kube-public       Active   55m
kube-node-lease   Active   55m
dynatrace         Active   55m
ingress-nginx     Active   55m
gitea             Active   54m
dev               Active   52m
staging           Active   52m
production        Active   52m
registry          Active   52m
jenkins           Active   52m
app-one           Active   51m
app-two           Active   51m
app-three         Active   51m
dashboard         Active   51m
```
We will be working with some of these namespaces to deploy our application across the different stages from dev > staging > production

In order to visualize what's already running in a namespace use:

```(bash)
kubectl -n dev get all 
```

## Step 3 - Review the ingress configuration


## Step 4 - Navigate into Gitea
In order


## Step 5 - Navigate into Jenkins

