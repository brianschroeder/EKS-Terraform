#!/bin/bash
aws eks update-kubeconfig --region $1 --name $2
kubectl delete daemonset -n kube-system aws-node
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/calico-vxlan.yaml
kubectl -n kube-system set env daemonset/calico-node FELIX_AWSSRCDSTCHECK=Disable
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
echo 'Waiting for Metrics API Server to be created..'
sleep 100
kubectl get deployment.apps -n kube-system metrics-server -o yaml | sed "s/dnsPolicy: ClusterFirst/dnsPolicy: ClusterFirst\n      hostNetwork: true/" | kubectl replace -f -