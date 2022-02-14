# Getting started with Knative

## 1 Clone this repo 

Start by cloning this repo to your local drive

```sh
git clone https://github.com/relessawy/getting_started_with_Knative
```
Create an environment variable MyScripts pointing to the bin folder in this repo

```sh
export MyScripts=<your local path>/getting_started_with_Knative/bin
```

## 2 Configure and Start Minikube

Before installing Knative and its components, we need to create a Minikube virtual machine and deploy Kubernetes into it. To download minikube and and it's command-line tool kubectl follow the instructions in this [link](https://kubernetes.io/docs/tasks/tools/).

## 3 Deploy Registry

We need to install an internal container registry first to push and pull container images. To set up an internal container registry inside of minikube, run:
```sh
minikube addons enable registry
```
If the registry enablement is successful, you will see two new pods in the kube-system namespace with a status of Running:
```sh
 kubectl get pods -n kube-system
```

|NAME | READY STATUS | RESTARTS | AGE |
|:-----|:--------------:|:----------:|:-----:|
|registry-l5cr9 |1/1|  Running|    0|     8m|  
|registry-proxy-q85k4|1/1| Running|    0|    8m|

## 4 Install Istio

We need to install an ingress gateway in order to route requests to the Knative Serving Services. In this tutorial we will use a minimal Istio (istio lean) installation since the ingress gateway is the only Istio component required for Knative. Use the followig script to install Istio
```sh
 $MyScripts/install-istio.sh
```


## 3 Install Knative

>`kubectl apply \
  --filename https://github.com/knative/serving/releases/download/knative-v1.1.0/serving-crds.yaml \
  --filename https://github.com/knative/eventing/releases/download/knative-v1.1.0/eventing-crds.yaml`
