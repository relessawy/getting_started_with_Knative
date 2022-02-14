# getting_started_with_Knative
Getting started with Knative

## 1 Configure and Start Minikube

Before installing Knative and its components, we need to create a Minikube virtual machine and deploy Kubernetes into it. To download minikube and and it's command-line tool kubectl follow the instructions in this [link](https://kubernetes.io/docs/tasks/tools/).

## 2 Deploy Registry

We will need to install an internal container registry first to push and pull container images. To set up an internal container registry inside of minikube, run:
```sh
minikube addons enable registry
```

## 3 Install Knative

>`kubectl apply \
  --filename https://github.com/knative/serving/releases/download/knative-v1.1.0/serving-crds.yaml \
  --filename https://github.com/knative/eventing/releases/download/knative-v1.1.0/eventing-crds.yaml`
