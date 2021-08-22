include vars.make


################## Install targets################
install_cli:
	@ sudo curl -sSL -o /usr/local/bin/argocd $(ARGO_CLI_LINK)
	@ sudo chmod +x /usr/local/bin/argocd
	@ echo "ArgoCD CLI Instalado com sucesso"

################## Deploy targets################
deploy_eks:
	@ cd $(TF_FOLDER)/eks/ && terraform init && terraform validate && terraform apply -auto-approve
	@ echo "Gerando o kubeconfig do cluster EKS GitOps" && sleep 10s
	@ aws eks --region us-east-1 update-kubeconfig --name gitops-lab
	@ kubectl get nodes -o wide

deploy_manifests:
	@ kubectl get nodes || echo "Configure a comunicacao com o cluster k8s" ; exit 0
	@ kubectl create namespace argocd || true
	@ kubectl apply -n $(ARGO_NAMESPACE) -f $(ARGO_INSTALL_LINK)

deploy_helm:
	@ kubectl create namespace $(ARGO_NAMESPACE) || true
	@ echo "Instalando repositorio Helm para ArgoCD"	
	@ helm repo add argo https://argoproj.github.io/argo-helm
	@ echo "Instalando ArgoCD via helm"
	@ helm install $(ARGO_HELM_RELEASE_NAME) argo/argo-cd -n $(ARGO_NAMESPACE)

deploy_app_sample:
	@ argocd repo add $(GIT_REPO) --insecure-ignore-host-key --ssh-private-key-path $(PRIVATE_KEY) --upsert
	@ argocd app create $(APP_NAME) --repo $(GIT_REPO) --path $(APP_GIT_PATH) --directory-recurse --dest-server $(ARGO_KUBE_SERVER) 
	@ argocd app sync $(APP_NAME)
	@ sleep 20s
	@ echo "Em alguns minutos, acesse via HTTP o endereço do AWS Load Balancer que foi criado"
	@ kubectl -n $(APP_SAMPLE_NAMESPACE) get svc | awk '{print $$4}'|grep 'elb.amazonaws.com'

################## Conf targets################
conf_pass:
	@ echo "Setando senha do usuario admin (gitops)"
	@ sleep 15
	@ bash -c $(ARGO_DEPLOY_FOLDER)/patch.sh $(ARGOCD_USER) $(ARGOCD_PASSWORD)

conf_proxy:
	@ kubectl -n argocd port-forward svc/argocd-server 8080:80 &
	@ echo "Acesse http://localhost:8080 com usuario $(ARGOCD_USER) e senha $(ARGOCD_PASSWORD)"

conf_argocd_context:
	@ echo "Logando no servidor ArgoCD via Kube PortForward"
	@ argocd login $(ARGOCD_LOGIN_SERVER) --username $(ARGOCD_USER) --insecure

################## Undeploy targets################
undeploy_app_sample:
	@ argocd app delete $(APP_NAME) -y	

undeploy_eks:
	@ cd $(TF_FOLDER)/eks/ && terraform destroy -auto-approve
	@ echo "EKS removido"

undeploy:
	@ kubectl delete namespace argocd
	@ echo "ArgoCD removido"

undeploy_helm:
	@ helm delete $(ARGO_HELM_RELEASE_NAME) -n $(ARGO_NAMESPACE)
	@ echo "ArgoCD removido via helm delete"

undeploy_all: undeploy_eks