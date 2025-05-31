#!/bin/bash

set -e

mkdir -p webapp-chart/templates

# Chart.yaml
cat > webapp-chart/Chart.yaml <<EOF
apiVersion: v2
name: webapp-istio-demo
version: 0.1.0
dependencies: []
EOF

# values.yaml
cat > webapp-chart/values.yaml <<EOF
image:
  repository: docker.io/kennethreitz/httpbin
  tag: latest
  pullPolicy: IfNotPresent
replicaCount: 1

service:
  name: webapp
  port: 80

istio:
  gatewayPort: 80
  gatewayName: webapp-gateway
  host: "*"
  canary:
    v1Weight: 90
    v2Weight: 10
EOF

# templates/deployment-v1.yaml
cat > webapp-chart/templates/deployment-v1.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-v1
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: webapp
      version: v1
  template:
    metadata:
      labels:
        app: webapp
        version: v1
    spec:
      containers:
      - name: webapp
        image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - containerPort: 80
EOF

# templates/deployment-v2.yaml
cat > webapp-chart/templates/deployment-v2.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-v2
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: webapp
      version: v2
  template:
    metadata:
      labels:
        app: webapp
        version: v2
    spec:
      containers:
      - name: webapp
        image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - containerPort: 80
EOF

# templates/service.yaml
cat > webapp-chart/templates/service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.name }}
spec:
  selector:
    app: webapp
  ports:
  - port: {{ .Values.service.port }}
    targetPort: 80
EOF

# templates/destinationrule.yaml
cat > webapp-chart/templates/destinationrule.yaml <<EOF
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: webapp-destination
spec:
  host: {{ .Values.service.name }}
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
EOF

# templates/virtualservice.yaml
cat > webapp-chart/templates/virtualservice.yaml <<EOF
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: webapp-virtualservice
spec:
  hosts:
  - "{{ .Values.service.name }}"
  http:
  - route:
    - destination:
        host: {{ .Values.service.name }}
        subset: v1
      weight: {{ .Values.istio.canary.v1Weight }}
    - destination:
        host: {{ .Values.service.name }}
        subset: v2
      weight: {{ .Values.istio.canary.v2Weight }}
EOF

# templates/gateway.yaml
cat > webapp-chart/templates/gateway.yaml <<EOF
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: {{ .Values.istio.gatewayName }}
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: {{ .Values.istio.gatewayPort }}
      name: http
      protocol: HTTP
    hosts:
    - "{{ .Values.istio.host }}"
EOF

# templates/ingress-virtualservice.yaml
cat > webapp-chart/templates/ingress-virtualservice.yaml <<EOF
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: webapp-ingress-vs
spec:
  hosts:
  - "{{ .Values.istio.host }}"
  gateways:
  - {{ .Values.istio.gatewayName }}
  http:
  - match:
    - uri:
        prefix: "/"
    route:
    - destination:
        host: {{ .Values.service.name }}
        port:
          number: {{ .Values.service.port }}
EOF

echo "✅ Helm chart 'webapp-chart' criado com sucesso!"