ARGO_INSTALL_LINK="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml	"
ARGO_CLI_LINK="https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"

install_cli:
	@ sudo curl -sSL -o /usr/local/bin/argocd $(ARGO_CLI_LINK)
	@ sudo chmod +x /usr/local/bin/argocd
	@ echo "ArgoCD CLI Instalado com sucesso"

deploy:
	@ kubectl get nodes || echo "Configure a comunicacao com o cluster k8s" ; exit 0
	@ kubectl create namespace argocd
	@ kubectl apply -n argocd -f $(ARGO_INSTALL_LINK)

proxy:
	@ kubectl -n argocd port-forward svc/argocd-server 8080:80 &
	@ echo "Acesse http://localhost:8181 com usuario admin e senha password"

deploy_eks:
	@ cd ../tf-module/eks && terraform init && terraform validate && terraform plan