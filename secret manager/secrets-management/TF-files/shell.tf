terraform {
  
  required_version = "> 0.8.0"
}
resource "null_resource" "eks_config" {
  triggers = {
    content = "${aws_eks_cluster.eks.id}"
  }
  
  provisioner "local-exec" {
          command = "aws eks --region us-east-2 update-kubeconfig --name eks --profile default"
          }
}

resource "null_resource" "ASCP_deployment" {
  triggers = {
    content = "${null_resource.eks_config.id}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ../My_service --recursive"
  }
  
}
resource "null_resource" "pod_deploy" {
  triggers = {
    content = "${null_resource.ASCP_deployment.id}"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f ../templet/redis.yaml"
  }
}
resource "null_resource" "copyfile" {
  triggers = {
    content = "${null_resource.pod_deploy.id}"
  }
  provisioner "local-exec" {
    command = "kubectl cp ../email.txt test-email:/opt"
    }
}
resource "null_resource" "copy_files" {
  triggers = {
    content = "${null_resource.pod_deploy.id}"
  }
  provisioner "local-exec" {
    command = "kubectl cp ../event.txt test-events:/opt"
  }   
}


resource "null_resource" "file_verfication" {
  triggers = {
    content = "${null_resource.copy_files.id}"
  }
  provisioner "local-exec" {
    command = "kubectl exec -it test-email -- cat /opt/email.txt"
  }
}
resource "null_resource" "event_verfication" {
  triggers = {
    content = "${null_resource.file_verfication.id}"
  }
  provisioner "local-exec" {
    command = "kubectl exec -it test-events -- cat /opt/event.txt"
  }
}



resource "null_resource" "csi_installation" {
  triggers = {
    content = "${null_resource.event_verfication.id}"
  }
  provisioner "local-exec" {
    command = "kubectl get csidrivers.storage.k8s.io"
    
  }
}





