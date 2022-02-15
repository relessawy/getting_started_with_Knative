#!/bin/bash

set -eu

PROFILE_NAME=${PROFILE_NAME:-knativeTutorial}
MEMORY=${MEMORY:-7959}
CPUS=${CPUS:-6}

EXTRA_CONFIG="apiserver.enable-admission-plugins=\
LimitRanger,\
NamespaceExists,\
NamespaceLifecycle,\
ResourceQuota,\
ServiceAccount,\
DefaultStorageClass,\
MutatingAdmissionWebhook"

minikube profile $PROFILE_NAME
minikube start --memory=$MEMORY --cpus=$CPUS \
  --disk-size=50g \
  --extra-config="$EXTRA_CONFIG" 