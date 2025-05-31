Project Objective

This project demonstrates how to deploy a sample web application with canary deployment strategy using Istio service mesh on a local Kind Kubernetes cluster, managed and deployed with Helm charts.

Prerequisites

    Kind (Kubernetes in Docker) installed for local Kubernetes cluster

    Istio service mesh installed and configured on the cluster

    Helm package manager installed for Kubernetes applications

    Basic knowledge of Kubernetes, Helm charts, Istio Gateway, and VirtualServices


Summary of What Was Done

    Setup the Kubernetes Cluster with Kind

        Installed Kind and created a local Kubernetes cluster to simulate a production-like environment on a developer machine.

    Installed Istio Service Mesh

        Deployed Istio control plane and configured ingress gateways within the Kind cluster to enable service mesh capabilities like traffic routing, observability, and security.

    Configured Helm

        Installed Helm as the package manager to simplify deploying and managing Kubernetes manifests.

        Created and customized Helm charts for the sample web application and Istio Gateway resources.

    Defined Istio Gateway and VirtualService Resources

        Created an Istio Gateway resource named webapp-gateway to expose the application on port 80.

        Created VirtualService resources to define traffic routing rules, directing requests between different versions of the application (webapp-v1 and webapp-v2) to enable canary deployments.

    Deployed Application Pods and Services

        Successfully deployed the application pods for versions 1 and 2, both running and ready.

        Verified the istio-ingress service with type LoadBalancer to manage incoming traffic.

    Troubleshooting and Accessing the Service

        Initially tried accessing the service via NodePorts, which failed due to local cluster network constraints.

        Solved the access issue by forwarding the Istio ingress service port to localhost using kubectl port-forward, enabling access to the service through http://localhost:8080.

    Verified Final Access

        Confirmed the web application was reachable and functioning as expected through the forwarded port URL.

This setup provides a foundational environment to experiment with Kubernetes service mesh features, Helm deployment automation, and canary release patterns in a controlled local setting.
