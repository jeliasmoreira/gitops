HELM_LINK="https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3"
ARGO_LINK="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml	"


install_helm:
	@ curl -fsSL -o get_helm.sh $(HELM_LINK)
	@ chmod 700 get_helm.sh
	@ ./get_helm.sh


deploy:
	@ kubectl create namespace argocd
	@ kubectl apply -n argocd -f $(ARGO_LINK)

proxy:
	@ kubectl -n argocd port-forward svc/argocd-server 8080:80 &
	@ echo "Acesse http://localhost:8080 com usuario admin e senha password "


	