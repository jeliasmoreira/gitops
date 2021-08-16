TF_FOLDER="./tf-module"
ARGO_DEPLOY_FOLDER="argocd-deploy"
ARGO_INSTALL_LINK="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
ARGO_CLI_LINK="https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"

install_cli:
	@ sudo curl -sSL -o /usr/local/bin/argocd $(ARGO_CLI_LINK)
	@ sudo chmod +x /usr/local/bin/argocd
	@ echo "ArgoCD CLI Instalado com sucesso"

deploy:
	@ kubectl get nodes || echo "Configure a comunicacao com o cluster k8s" ; exit 0
	@ kubectl create namespace argocd || true
	@ kubectl apply -n argocd -f $(ARGO_INSTALL_LINK)

set_pass:
	@ echo "Setando senha do usuario admin (gitops)"
	@ bash -c $(ARGO_DEPLOY_FOLDER)/patch.sh

proxy:
	@ kubectl -n argocd port-forward svc/argocd-server 8080:80 &
	@ echo "Acesse http://localhost:8080 com usuario admin e senha password"

deploy_eks:
	@ cd $(TF_FOLDER)/eks/ && terraform init && terraform validate && terraform apply -auto-approve
	@ echo "Gerando o kubeconfig do cluster EKS GitOps"
	@ aws eks --region us-east-1 update-kubeconfig --name gitops-lab
	@ kubectl get nodes -o wide

undeploy_eks:
	@ cd $(TF_FOLDER)/eks/ && terraform destroy -auto-approve
	@ echo "EKS removido"


undeploy:
	@ kubectl delete namespace argocd
	@ echo "ArgoCD removido"

