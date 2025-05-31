🎯 Project Objective

This project demonstrates how to deploy a sample web application with canary deployment strategy using Istio service mesh on a local Kind Kubernetes cluster, managed and deployed with Helm charts.

✅  Prerequisites

 🐳  Kind (Kubernetes in Docker) installed for local Kubernetes cluster

 🌐  Istio service mesh installed and configured on the cluster

 ⛵  Helm package manager installed for Kubernetes applications

 🔧  Basic knowledge of Kubernetes, Helm charts, Istio Gateway, and VirtualServices


🧱 Summary of What Was Done

 🛠️   Setup the Kubernetes Cluster with Kind

        Installed Kind and created a local Kubernetes cluster to simulate a production-like environment on a developer machine.

 🛠️  Installed Istio Service Mesh

        Deployed Istio control plane and configured ingress gateways within the Kind cluster to enable service mesh capabilities like traffic routing, observability, and security.

 📦  Configured Helm

        Installed Helm as the package manager to simplify deploying and managing Kubernetes manifests.

        Created and customized Helm charts for the sample web application and Istio Gateway resources.

 🔀  Defined Istio Gateway and VirtualService Resources

        Created an Istio Gateway resource named webapp-gateway to expose the application on port 80.

        Created VirtualService resources to define traffic routing rules, directing requests between different versions of the application (webapp-v1 and webapp-v2) to enable canary deployments.

 🔀  Deployed Application Pods and Services

        Successfully deployed the application pods for versions 1 and 2, both running and ready.

        Verified the istio-ingress service with type LoadBalancer to manage incoming traffic.

 🔍  Troubleshooting and Accessing the Service

        Initially tried accessing the service via NodePorts, which failed due to local cluster network constraints.

        Solved the access issue by forwarding the Istio ingress service port to localhost using kubectl port-forward, enabling access to the service through http://localhost:8080.

  ✅ Verified Final Access

        Confirmed the web application was reachable and functioning as expected through the forwarded port URL.

📌 This setup provides a foundational environment to experiment with Kubernetes service mesh features, Helm deployment automation, and canary release patterns in a controlled local setting.


-------------------------------------------------------------------------------------------------------------------------------------------------------

🎯 Objetivo do Projeto

O objetivo deste projeto foi criar um ambiente local com Kubernetes, configurado com Istio Service Mesh e utilizando Helm para deploy, com suporte a Canary Deployment. No final, o aplicativo deveria estar acessível via URL, com roteamento de tráfego controlado entre duas versões da aplicação (v1 e v2).

✅ Pré-requisitos instalados

Antes de começar, foi necessário instalar:
🐳 Docker

    Obrigatório para rodar clusters com Kind

🔧 Kind (Kubernetes in Docker)

    Ferramenta para rodar clusters Kubernetes localmente usando contêineres

    Instalado via:

    go install sigs.k8s.io/kind@latest

⛵ Helm

    Gerenciador de pacotes Kubernetes (usado para criar e instalar charts)

    Instalado via:

    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

🌐 Istio + istioctl

    Ferramenta para gerenciamento de malha de serviços (Service Mesh)

    Instalado via:

    curl -L https://istio.io/downloadIstio | sh -
    export PATH="$PATH:/caminho/para/istio/bin"

🧱 1. Criação do cluster Kind

    Criou um cluster com um arquivo de configuração personalizado, habilitando a exposição de portas:

    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    ...

🛠️ 2. Instalação do Istio

    Criado namespace e aplicado o operador Istio:

    istioctl install --set profile=demo -y
    kubectl label namespace default istio-injection=enabled

📦 3. Criação e deploy da aplicação com Helm

    Criado Helm Chart customizado (webapp-chart)

        Dois Deployment: webapp-v1 e webapp-v2

        Um Service expondo ambos os pods

    Instalado com:

    helm install webapp ./webapp-chart

🔀 4. Configuração do Istio Gateway e VirtualServices

    Criado recurso Gateway (webapp-gateway) para aceitar requisições HTTP externas

    Criado VirtualService webapp-ingress-vs apontando para o Gateway

    Criado VirtualService webapp-virtualservice com configuração de Canary Routing:

        Requisições HTTP para webapp são divididas entre v1 e v2 com pesos distintos (ex: 80/20)

🔍 5. Diagnóstico e verificação

    Verificou recursos criados com:

kubectl get svc -n istio-system
kubectl get gateway -A
kubectl get virtualservice -A
kubectl get pods -A

Tentativa inicial de acesso via NodePort falhou:

    curl http://localhost:32282/  # ❌ Connection refused

🔁 6. Correção com Port Forward

    Usou o seguinte comando para expor o serviço localmente:

kubectl port-forward -n istio-system svc/istio-ingress 8080:80

Com isso, acesso ao app funcionou corretamente:

    curl http://localhost:8080/

✅ Resultado final

    Aplicação acessível via http://localhost:8080/

    Canary Deployment funcionando entre v1 e v2

    Tudo gerenciado via Helm, rodando em Kind com Istio configurado

📌 Recursos usados no cluster
Recurso	Descrição
Kind	Cluster local para testes
Helm	Deploy automatizado da aplicação
Istio	Service Mesh com injeção automática de sidecar
Gateway	Exposição externa do app
VirtualService	Roteamento de tráfego e Canary Deployment
Port-forward	Solução local para expor o app