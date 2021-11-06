#!/usr/bin/bash

image=$1

[[ "" -eq "$1" ]] && image="fernandoalmeida/photoready:latest"

nerdctl -n k8s.io build -t $image . && \
cd kustomize/base && \
kustomize edit set image photoready=$image && \
cd -
