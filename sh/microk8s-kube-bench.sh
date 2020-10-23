#!/bin/bash

set -e
trap 'catch $? $LINENO' EXIT
catch() {
  if [ "$1" != "0" ]; then
    echo "Error $1 occurred on line $2"
  fi
}

source "$(dirname $0)/microk8s-lib.sh"

if [[ -z ${MK8S_INSTALL+x} ]]       ; then export MK8S_INSTALL='false'      ; fi                        ; echo "mk8s install: $MK8S_INSTALL"
if [[ -z ${MK8S_VERSION+x} ]]       ; then export MK8S_VERSION='1.19'       ; fi                        ; echo "mk8s version: $MK8S_VERSION"
if [[ -z ${MK8S_KUBE_DIR+x} ]]      ; then export MK8S_KUBE_DIR='/.kube'    ; fi                        ; echo "mk8s kube dir: $MK8S_KUBE_DIR"

if [[ -z ${KUBE_BENCH_DEPLOY+x} ]]  ; then export KUBE_BENCH_DEPLOY='true'  ; fi                        ; echo "kube-bench deploy: $KUBE_BENCH_DEPLOY"

KUBE_CONFIG="kube-config"

if [[ "$MK8S_INSTALL" == 'true' ]]
then
  #make sure of greenfield
  [[ ! -d "$MK8S_KUBE_DIR" ]]
  
  echo -e "\n### installing microk8s & add-ons: "
  snap install microk8s --classic --channel="$MK8S_VERSION"
  snap list 
  #snap info microk8s
  microk8s status --wait-ready

  microk8s kubectl get nodes
  microk8s kubectl get services
  
  [[ -d "$MK8S_KUBE_DIR" ]]
  
fi 

microk8s status | grep 'microk8s is running'

microk8s config view

microk8s config > "$KUBE_CONFIG"


if [[ "$KUBE_BENCH_DEPLOY" == 'true' ]]
then
  
  echo -e "\n### deploying kube-bench: "
  microk8s kubectl apply -f "https://raw.githubusercontent.com/aquasecurity/kube-bench/master/job.yaml"
  
  microk8s kubectl get jobs
  microk8s kubectl get pods
  
  while [[ ! $(microk8s kubectl get pods | grep 'kube-bench') == *'Completed'* ]]
  do
    echo -e "waiting: $(microk8s kubectl get pods | grep 'kube-bench')"
    sleep 5s
  done
  
  echo -e "\n### final status:"
  microk8s kubectl get jobs
  microk8s kubectl get pods
  
  echo -e "\n### pod logs:"
  POD=$(microk8s kubectl get pods | grep 'kube-bench' | grep 'Completed' | awk '{print $1}')
  echo "kube-bench pod: $POD"
  microk8s kubectl logs "$POD"
  
  cat README.md > REPORT.md
  echo '```' >> REPORT.md
  microk8s kubectl logs "$POD" >> REPORT.md
  echo '```' >> REPORT.md
fi
