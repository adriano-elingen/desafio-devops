provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = "${var.project_name}"
  vpc_id          = "${module.vpc.vpc_id}"
  subnets         = ["${element(module.vpc.private_subnets, 0)}", "${element(module.vpc.private_subnets, 1)}"]

  worker_groups = [
    {
      instance_type = "t3.large"
      asg_min_size  = 1
      asg_max_size  = 5
    }
  ]
}

# cria kubeconfig
resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.project_name} --profile default"
  }
  depends_on = [module.eks.cluster_id]
}

# criar namespace
resource "kubernetes_namespace" "devops-challenge" {
  metadata {
    annotations = {
      name = var.project_name
    }
    name = var.project_name
  }

  depends_on = [module.eks.cluster_id]

}

#criar deployment para teste
resource "kubernetes_deployment" "simple-nginx-deploy" {
  metadata {
    name = "simple-nginx"
    namespace = var.project_name
    labels = {
      app = "simple-nginx"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "simple-nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "simple-nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name = "simple-nginx"
        }

      }
    }
  }
  depends_on = [resource.kubernetes_namespace.devops-challenge]
}

#cria service para expor nginx
resource "kubernetes_service" "simple-nginx-service" {
  metadata {
    name = "simple-nginx"
    namespace = var.project_name
  }
  spec {
    type = "LoadBalancer"
    port {
      port = 80
      target_port = 80
    }
    selector = {
      app = kubernetes_deployment.simple-nginx-deploy.metadata.0.labels.app
    }
  }
  depends_on = [resource.kubernetes_namespace.devops-challenge]
}