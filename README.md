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
U
We need to install an ingress gateway in order to route requests to the Knative Serving Services like Istio. Follow the hereunder steps to install Istio:

Download the latest release 

```sh
curl -L https://istio.io/downloadIstio | sh -
```

Move to the downloaded folder and add istioctl to your PATH.

```sh
cd <directory>
export PATH=$PWD/bin:$PATH
```

Install the demo profile

```sh
istioctl manifest apply --set profile=demo
```

To check if Istio  pods are running execute the following command

```sh
kubectl get pods -n istio-system
```
|NAME                                   |READY   |STATUS    |RESTARTS   |AGE|
|:--------------------------------------|:------:|:--------:|:---------:|:-:|
|istio-egressgateway-599c8845c9-6t8mr   |1/1     |Running   |0          |19m|
|istio-ingressgateway-69dc56d7f-n5tct   |1/1     |Running   |0          |19m|
|istiod-8c75fcbc9-7qm6j                 |1/1     |Running   |0          |20m|


## 5 Install Knative

The Knative installation process is divided into three steps:
 1. Installing Knative Custom Resource Definitions (CRDs)
 2. Installing the Knative Serving components
 3. Installing the Knative Eventing components

### Install Knative CRDs

Knative Serving and Eventing define their own Kubernetes CRDs. We need to have the Knative Serving and Eventing CRDs installed in your Kubernetes cluster. Run the following command to do so:

```sh
kubectl apply \
  --filename https://github.com/knative/serving/releases/download/knative-v1.1.0/serving-crds.yaml \
  --filename https://github.com/knative/eventing/releases/download/knative-v1.1.0/eventing-crds.yaml
```

To verify that all CRDs were created we can query the API group called serving.knative.dev

```sh
kubectl api-resources --api-group='serving.knative.dev'
```

|NAME             |SHORTNAMES      |APIGROUP              |NAMESPACED   |KIND|
|:----------------|:--------------:|:--------------------:|:-----------:|:--:|
|configurations   |config,cfg      |serving.knative.dev   |true         |Configuration|
|domainmappings   |dm              |serving.knative.dev   |true         |DomainMapping|
|revisions        |rev             |serving.knative.dev   |true         |Revision|
|routes           |rt              |serving.knative.dev   |true         |Route|
|services         |kservice,ksvc   |serving.knative.dev   |true         |Service|