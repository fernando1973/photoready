#!/usr/bin/bash

nerdctl -n k8s.io build -t $1 . && \
cd kustomize/base && \
kustomize edit set image photoready=$1 && \
cd -
