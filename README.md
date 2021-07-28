# etcd-cluster

[![Build docker and push](https://github.com/iliadmitriev/etcd-cluster/actions/workflows/docker-build-push.yml/badge.svg)](https://github.com/iliadmitriev/etcd-cluster/actions/workflows/docker-build-push.yml)

simple cluster of etcd instances
for deploy in kubernetes

## Build image

```shell
docker build -t etcd ./
```

## Deploy to kubernetes

```shell
kubectl apply -f etcd-cluster.yaml
```