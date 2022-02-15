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

To start minikube use the following script

```sh
$MyScripts/start-minikube.sh
```

To validate the status of minikube, run the following command

```sh
minikube status
```

>`knativetutorial`   
>`type: Control Plane`   
>`host: Running`   
>`kubelet: Running`   
>`apiserver: Running`   
>`kubeconfig: Configured`

## 3 Deploy Registry

We need to install an internal container registry first to push and pull container images. To set up an internal container registry inside of minikube, run:
```sh
minikube -p knativeTutorial addons enable registry
```
If the registry enablement is successful, you will see two new pods in the kube-system namespace with a status of Running:
```sh
kubectl get pods -n kube-system
```

|NAME | READY STATUS | RESTARTS | AGE |
|:-----|:--------------:|:----------:|:-----:|
|registry-l5cr9 |1/1|  Running|    0|     8m|  
|registry-proxy-q85k4|1/1| Running|    0|    8m|

## 4 Install Knative

The Knative installation process is divided into three steps:
 1. Installing Knative Custom Resource Definitions (CRDs)
 2. Installing the Knative Serving components
 3. Installing the Knative Eventing components

### 4.1 Install Knative CRDs

Knative Serving and Eventing define their own Kubernetes CRDs. We need to have the Knative Serving and Eventing CRDs installed in your Kubernetes cluster. Run the following command to do so:

```sh
kubectl apply \
  --filename https://github.com/knative/serving/releases/download/knative-v1.1.0/serving-crds.yaml \
  --filename https://github.com/knative/eventing/releases/download/knative-v1.1.0/eventing-crds.yaml
```

To verify that all Serving CRDs were created we can query the API group called serving.knative.dev

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

Similarly, to verify that all Eventing CRDs were created we can query the API groups called eventing.knative.dev , messaging.knative.dev , and sources.knative.dev

### 4.2 Install Knative Serving components

```sh
kkubectl apply \
  --filename \
  https://github.com/knative/serving/releases/download/knative-v1.1.0/serving-core.yaml
```

A successful deployment should show the following pods running in knative-serving namespace:

```sh
kubectl get pods -n knative-serving
```
|NAME                                     |READY   |STATUS   |RESTARTS   |AGE|
|:----------------------------------------|:------:|:-------:|:---------:|:-:|
|activator-8fff5cc7d-gxg8j                |1/1     |Running  |0        |16s|
|autoscaler-569f86d46c-fshp9              |1/1     |Running  |0          |16s|
|controller-649ddc846d-hx9jq              |1/1     |Running  |0          |16s|
|domain-mapping-7cc7b644cc-mpmrc          |1/1     |Running  |0          |16s|
|domainmapping-webhook-6c97ff57f6-m49hr   |1/1     |Running  |0          |16s|
|webhook-7f96994b9-5hgql                  |1/1     |Running  |0          |16s|

### 4.3 Install Knative Eventing

```sh
kubectl apply \
  --filename \
  https://github.com/knative/eventing/releases/download/knative-v1.1.0/eventing-core.yaml \
  --filename \
  https://github.com/knative/eventing/releases/download/knative-v1.1.0/in-memory-channel.yaml \
  --filename \
  https://github.com/knative/eventing/releases/download/knative-v1.1.0/mt-channel-broker.yaml
```

  A successful deployment should show the following pods in knative-eventing namespace:


```sh
kubectl get pods -n knative-eventing
```

|NAME                                    |READY   |STATUS    |RESTARTS   |AGE|
|:-------------------------------------|:---:|:-----:|:------:|:-:|
|eventing-controller-6cd47bff4b-hf9hq    |1/1     |Running   |0          |52s|
|eventing-webhook-87b4f6cb5-w9v76       |1/1     |Running   |0          |52s|
|imc-controller-5bd45cf5b-cxts6        |1/1     |Running   |0          |52s|
|imc-dispatcher-7b9bf546b8-rkdcc          |1/1     |Running   |0          |52s|
|mt-broker-controller-5bb47f9cf5-hftld   |1/1     |Running   |0          |52s|
|mt-broker-filter-7f468cbd7b-n6c82       |1/1     |Running   |0          |52s|
|mt-broker-ingress-57db965447-hqf4j        |1/1     |Running   |0          |52s|

## 5 Install Ingress and Ingress Gateway

### 5.1 Install Kourier Ingress Gateway

We need to install an ingress gateway like [Kourier](https://github.com/3scale-archive/kourier) in order to route requests to the Knative Serving services. Follow the hereunder steps to install Kourier:

```sh
kubectl apply \
  --filename \
    https://github.com/knative/net-kourier/releases/download/knative-v1.1.0/kourier.yaml
```

A successful Kourier Ingress Gateway should show the following pods in kourier-system and knative-serving

```sh
kubectl get pods --all-namespaces -l 'app in(3scale-kourier-gateway,3scale-kourier-control)'
```

|NAMESPACE         |NAME                                      |READY   |STATUS    |RESTARTS   |AGE|
|:-----------------|:----------------------------------------:|:------:|:--------:|:---------:|:-:|
|kourier-system    |3scale-kourier-gateway-bf9cb68c8-g5m74   |1/1     |Running   |1          |3h|

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

Now configure Knative serving to use Kourier as the ingress:

```sh
kubectl patch configmap/config-network \
  -n knative-serving \
  --type merge \
  -p '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'
  ```

  ### 5.2 Install and Configure Ingress Controller

  To access the Knative Serving services from the minikube host, it will be easier to have [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) deployed and configured. To install and configure Contour as the Ingress Controller.

```sh
  kubectl apply \
  --filename https://projectcontour.io/quickstart/contour.yaml
```

To check deployment success, run the following command

```sh
kubectl get pods -n projectcontour
```

|NAME                       |READY   |STATUS    |RESTARTS   |AGE|
|:----------------------|:----:|:------:|:------:|:-:|
|contour-79bdf94f8-5g25x    |1/1     |Running   |0          |14s|
|contour-79bdf94f8-jrlfl    |1/1     |Running   |0          |14s|
|envoy-2bqw4               |2/2     |Running   |0          |14s|


Now let create an Ingress to Kourier Ingress Gateway:

```sh
cat <<EOF | kubectl apply -n kourier-system -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kourier-ingress
  namespace: kourier-system
spec:
  rules:
  - http:
     paths:
       - path: /
         pathType: Prefix
         backend:
           service:
             name: kourier
             port:
               number: 80
EOF
```

Configure Knative to use the kourier-ingress Gateway:

```sh
ksvc_domain="\"data\":{\""$(minikube -p knativetutorial ip)".nip.io\": \"\"}"
kubectl patch configmap/config-domain \
    -n knative-serving \
    --type merge \
    -p "{$ksvc_domain}"
```

## 6 Install Knative client

Install [Knative Client](https://knative.dev/docs/install/client/) and add it to your PATH.

Verify installation by running the command:

```sh
kn version
```

The above command will return a response like

>'Version:      v1.1.0
Build Date:   2021-12-14 13:59:14
Git Revision: 530841f1
Supported APIs:
* Serving
  - serving.knative.dev/v1 (knative-serving v0.28.0)
* Eventing
  - sources.knative.dev/v1 (knative-eventing v0.28.0)
'