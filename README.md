# Redis-operator-deployment-example

## Requirements
* Kubernetes 1.8+

## Minikube
 
 * [Install](https://kubernetes.io/docs/tasks/tools/install-minikube/)

```
# start
$ minikube start --memory 4096 --cpus 4 --mount
```

## Deploy Redis Operator 

```
$ make deploy-operator
```

## Provision Redis

```
$ make provision-redis
```

```yaml

apiVersion: storage.spotahome.com/v1alpha2
kind: RedisFailover
metadata:
  name: redisfailover
spec:
  hardAntiAffinity: false  # Optional. Value by default. If true, the pods will not be scheduled on the same node.
  sentinel:
    replicas: 3            # Optional. 3 by default, can be set higher.
    resources:             # Optional. If not set, it won't be defined on created reosurces.
      requests:
        cpu: 100m
      limits:
        memory: 100Mi
  redis:
    replicas: 2            # Optional. 3 by default, can be set higher.
    resources:             # Optional. If not set, it won't be defined on created reosurces
      requests:
        cpu: 100m
        memory: 100Mi
      limits:
        cpu: 400m
        memory: 500Mi
    exporter: false         # Optional. False by default. Adds a redis-exporter container to export metrics.
    
```
## Tearing down your Operator deployment

```
$ make clean
```

## Troubleshooting


```
Error: release redisfailover failed: namespaces "default" is forbidden: User "system:serviceaccount:kube-system:default" cannot get namespaces in the namespace "default"

# solution
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'      
helm init --service-account tiller --upgrade

````