#!/usr/bin/env python3
"""
Generate a beautified GCP architecture diagram with official GCP resource icons.
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.gcp.compute import GKE
from diagrams.gcp.network import LoadBalancing, NAT
from diagrams.gcp.storage import Storage
from diagrams.gcp.analytics import BigQuery
from diagrams.gcp.devtools import ContainerRegistry, Build
from diagrams.onprem.client import Users
from diagrams.onprem.vcs import Git
from diagrams.k8s.compute import Pod
from diagrams.k8s.network import Ingress
from diagrams.k8s.group import NS
from diagrams.custom import Custom
from diagrams.programming.flowchart import Database

# Create custom nodes for services without official icons
def create_text_node(label, color="#4285f4"):
    """Create a text-based node with GCP styling"""
    # Use a simple icon path or empty string - diagrams will create a text node
    # Pass attributes as keyword arguments
    return Custom(label, icon_path="", shape="box", style="rounded,filled", 
                  fillcolor=color, fontcolor="white", fontsize="10", penwidth="2")

# Create the diagram with beautiful styling
with Diagram("Qureos Architecture - GCP", 
             filename="qureos-arch-beautified", 
             show=False, 
             direction="TB",
             graph_attr={
                 "bgcolor": "#f8f9fa",
                 "pad": "2.0",
                 "splines": "ortho",
                 "fontname": "Arial",
                 "fontsize": "14",
                 "rankdir": "TB"
             },
             node_attr={
                 "fontsize": "11",
                 "fontname": "Arial",
                 "style": "rounded,filled",
                 "fillcolor": "white",
                 "penwidth": "2"
             },
             edge_attr={
                 "fontsize": "9",
                 "fontname": "Arial"
             }):
    
    # Users and Load Balancer
    users = Users("Users")
    lb = LoadBalancing("Load Balancer")
    
    # VPC Cluster containing GKE
    with Cluster("VPC Network", graph_attr={"bgcolor": "#e8f0fe", "style": "rounded,dashed", 
                                            "penwidth": "3", "fontsize": "12", "fontname": "Arial Bold"}):
        with Cluster("GKE Cluster", graph_attr={"bgcolor": "#fff3e0", "style": "rounded,solid", 
                                                "penwidth": "2", "fontsize": "11"}):
            ingress = Ingress("Kubernetes\nIngress")
            
            with Cluster("Services", graph_attr={"bgcolor": "#f1f8e9", "style": "rounded"}):
                frontend_svc = NS("Frontend\nService")
                backend_svc = NS("Backend\nService")
            
            with Cluster("Pods", graph_attr={"bgcolor": "#fce4ec", "style": "rounded"}):
                frontend_pod = Pod("Frontend\nPod")
                backend_pod = Pod("Backend\nPod")
            
            hpa = create_text_node("Horizontal Pod\nAutoscaler", "#ff9800")
            argocd = create_text_node("ArgoCD", "#ef5350")
        
        nat = NAT("NAT Gateway")
    
    # CI/CD Pipeline
    with Cluster("CI/CD Pipeline", graph_attr={"bgcolor": "#fff9c4", "style": "rounded", 
                                                "penwidth": "2", "fontsize": "11"}):
        git_repo = Git("Git Repo")
        cloud_build = Build("Cloud Build")
        doppler = create_text_node("Doppler\nSecrets", "#ff6f00")
        container_registry = ContainerRegistry("Container\nRegistry")
    
    # External Data Services
    with Cluster("External Data Services", graph_attr={"bgcolor": "#e1f5fe", "style": "rounded", 
                                                        "penwidth": "2", "fontsize": "11"}):
        mongodb = Database("Atlas\nMongoDB")
        elasticsearch = create_text_node("GCP\nElasticSearch", "#4285f4")
        cloud_storage = Storage("Cloud\nStorage")
        bigquery = BigQuery("BigQuery")
    
    # User traffic flow
    users >> Edge(label="HTTPS", style="bold", color="#1976d2", penwidth="3") >> lb
    lb >> Edge(style="bold", color="#1976d2", penwidth="2") >> ingress
    ingress >> Edge(style="solid", color="#388e3c", penwidth="2") >> frontend_svc
    ingress >> Edge(style="solid", color="#388e3c", penwidth="2") >> backend_svc
    frontend_svc >> Edge(style="solid", color="#388e3c", penwidth="1.5") >> frontend_pod
    backend_svc >> Edge(style="solid", color="#388e3c", penwidth="1.5") >> backend_pod
    frontend_pod >> Edge(label="API", style="dashed", color="#7b1fa2", penwidth="2") >> backend_pod
    backend_pod >> Edge(style="dotted", color="#f57c00", penwidth="2") >> hpa
    
    # ArgoCD deployment connections
    argocd >> Edge(label="Deploy", style="curved", color="#d32f2f", penwidth="2") >> frontend_pod
    argocd >> Edge(label="Deploy", style="curved", color="#d32f2f", penwidth="2") >> backend_pod
    
    # CI/CD Pipeline flow
    git_repo >> Edge(label="Push", style="bold", color="#1976d2", penwidth="2.5") >> cloud_build
    cloud_build >> Edge(label="Secrets", style="dashed", color="#f57c00", penwidth="2") >> doppler
    cloud_build >> Edge(label="Build & Push", style="bold", color="#388e3c", penwidth="2.5") >> container_registry
    container_registry >> Edge(label="Deploy", style="bold", color="#d32f2f", penwidth="2.5") >> argocd
    
    # External services connections
    backend_pod >> Edge(style="dashed", color="#616161", penwidth="2") >> nat
    nat >> Edge(style="solid", color="#1976d2", penwidth="2") >> mongodb
    nat >> Edge(style="solid", color="#1976d2", penwidth="2") >> elasticsearch
    nat >> Edge(style="solid", color="#1976d2", penwidth="2") >> cloud_storage
    nat >> Edge(style="solid", color="#1976d2", penwidth="2") >> bigquery
