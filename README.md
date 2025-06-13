# 🇺🇸 Kind + Istio + Helm - Canary Deployment Demo  
# 🇧🇷 Demonstração de Canary Deployment com Kind, Istio e Helm

> ⚙️ Mini lab local para estudo de Service Mesh, Canary Releases, Observabilidade e Segurança com Istio no Kubernetes

---

## 📚 Table of Contents | Índice

- [🎯 Project Goal | Objetivo do Projeto](#-project-goal--objetivo-do-projeto)
- [✅ Features | Funcionalidades](#-features--funcionalidades)
- [🧱 Architecture | Arquitetura](#-architecture--arquitetura)
- [📁 File Structure | Estrutura dos Arquivos](#-file-structure--estrutura-dos-arquivos)
- [🚀 Usage Guide | Guia de Uso](#-usage-guide--guia-de-uso)
- [📊 Observability | Observabilidade](#-observability--observabilidade)
- [🔐 Security Policy | Política de Segurança](#-security-policy--política-de-segurança)
- [🧪 A/B Testing](#-ab-testing)
- [🧠 Conclusion | Conclusão](#-conclusion--conclusão)

---

## 🎯 Project Goal | Objetivo do Projeto

**🇺🇸** Create a reproducible local lab to experiment with:
- Istio Service Mesh
- Helm-based deployments
- Canary releases and traffic shifting
- HTTP routing, A/B testing
- Security via `AuthorizationPolicy`
- Metrics and traffic visualization with Kiali, Prometheus, and Grafana

**🇧🇷** Criar um laboratório local reprodutível para praticar:
- Istio Service Mesh
- Deployments com Helm
- Canary releases e redirecionamento de tráfego
- Roteamento HTTP e testes A/B
- Políticas de segurança com `AuthorizationPolicy`
- Visualização de métricas com Kiali, Prometheus e Grafana

---

## ✅ Features | Funcionalidades

- 🌐 **Kind cluster** (Kubernetes local em Docker)
- ⚙️ **Helm deploy** de múltiplas versões do app
- 🎯 **Canary deployment** com Istio (VirtualService e DestinationRule)
- 🔐 **Segurança de rede** com `AuthorizationPolicy`
- 📊 **Monitoramento completo** com Kiali, Prometheus e Grafana
- 🧪 **A/B Testing** via headers HTTP

---

## 🧱 Architecture | Arquitetura

```
+-------------------+        +-------------------+
|    Prometheus     |<------->     Grafana       |
+-------------------+        +-------------------+

        ▲
        │
+-------------------+        +-------------------+
|      Kiali        |<------->   Istio Control   |
+-------------------+        |       Plane       |
                             +-------------------+
                                     |
                           +-------------------+
                           |   Istio Ingress   |
                           |    Gateway        |
                           +-------------------+
                                /         \
                    +-------------+   +-------------+
                    | webapp v1   |   | webapp v2   |
                    +-------------+   +-------------+
```

---

## 📁 File Structure | Estrutura dos Arquivos

```bash
.
├── helm/                  # Helm chart da aplicação
├── istio-config/          # VirtualService, Gateway, DestinationRule
├── addons/                # Instalação de Kiali, Prometheus e Grafana
├── authorization-policy.yaml
└── kind-config.yaml
```

---

## 🚀 Usage Guide | Guia de Uso

### 1. 🔧 Create Cluster | Criar Cluster

```bash
kind create cluster --name istio-lab --config kind-config.yaml
```

### 2. 🚀 Install Istio

```bash
istioctl install --set profile=demo -y
```

### 3. 📦 Deploy App with Helm

```bash
helm install webapp ./helm/webapp --set image.tag=v1
helm upgrade webapp ./helm/webapp --set image.tag=v2 --reuse-values
```

---

## 📊 Observability | Observabilidade

### ▶️ Kiali

```bash
kubectl apply -f addons/kiali.yaml
kubectl port-forward -n istio-system svc/kiali 20001:20001
```
Access | Acesse: http://localhost:20001

---

### 📈 Prometheus

```bash
kubectl apply -f addons/prometheus.yaml
kubectl port-forward -n istio-system svc/prometheus 9090:9090
```
Access | Acesse: http://localhost:9090

---

### 📊 Grafana

```bash
kubectl apply -f addons/grafana.yaml
kubectl port-forward -n istio-system svc/grafana 3000:3000
```
Access | Acesse: http://localhost:3000  
Credentials | Credenciais: `admin / admin`

---

## 🔐 Security Policy | Política de Segurança

```bash
kubectl apply -f authorization-policy.yaml
```

**Test**

```bash
kubectl create ns test-ns
kubectl run busybox --rm -it -n test-ns --image=busybox -- wget -qO- http://webapp.default.svc.cluster.local  # ❌ Denied

kubectl run busybox --rm -it --image=busybox -- wget -qO- http://webapp.default.svc.cluster.local  # ✅ Allowed
```

---

## 🧪 A/B Testing

```bash
kubectl apply -f istio-config/webapp-ingress-vs.yaml

curl -H "user: test-user" http://localhost:8080/  # goes to v2
curl http://localhost:8080/                      # goes to v1
```

---

## 🧠 Conclusion | Conclusão

**🇺🇸**  
This project provides a practical and educational sandbox for understanding modern delivery, security and monitoring strategies in Kubernetes environments with Istio.

**🇧🇷**  
Este projeto oferece um ambiente prático e educativo para entender estratégias modernas de entrega, segurança e monitoramento em ambientes Kubernetes com Istio.

---

📌 **Repo created for learning purposes — feel free to fork and adapt.**  
📌 **Repositório criado para fins educacionais — sinta-se à vontade para clonar e adaptar.**