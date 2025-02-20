kubectl auth can-i create services
kubectl auth can-i get deployments
kubectl auth can-i get pytorchjobs.kubeflow.org

aws sts get-caller-identity

kubectl get nodes "-o=custom-columns=NAME:.metadata.name,INSTANCETYPE:.metadata.labels.node\.kubernetes\.io/instance-type,GPU:.status.allocatable.nvidia\.com/gpu,EFA:.status.allocatable.vpc\.amazonaws\.com/efa"
