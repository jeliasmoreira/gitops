HELM_LINK="https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3"
ARGO_LINK="https://github.com/argoproj/argo-cd.git"
MANIFEST_FOLDER="argo-cd/manifests"
MANIFEST_CRDs_FOLER="argo-cd/manifests/crds"

install_helm:
	@ curl -fsSL -o get_helm.sh $(HELM_LINK)
	@ chmod 700 get_helm.sh
	@ ./get_helm.sh

argocd_repo:
	@ git clone $(ARGO_LINK)	

deploy:
	@ kubectl create namespace argocd
	@ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml	

# argocd_deploy:
# 	@ kubectl delete -f $(MANIFEST_FOLDER)/install.yaml
# 	@ kubectl delete -f $(MANIFEST_FOLDER)/namespace-install.yaml
# 	@ kubectl delete -k https://github.com/argoproj/argo-cd/manifests/crds\?ref\=stable

kubectl -n argocd port-forward svc/argocd-server 8080:80


	