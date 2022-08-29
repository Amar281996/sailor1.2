resource "aws_secretsmanager_secret" "creds" {
  name = "srssec"
}
/*variable "events" {
  default = {
    events_service_mysql_user_id = "amar"
    events_service_mysql_password = "Amar123"
  }

  type = map(string)
}
resource "aws_secretsmanager_secret_version" "secret-events" {
  secret_id     = aws_secretsmanager_secret.usersecrets.id
  secret_string = jsonencode(var.events)
}*/

variable "email" {
  default = {
    email_service_mysql_user_id = "chowdary"
    email_service_mysql_password = "chowdary123"
    events_service_mysql_user_id = "amar"
    events_service_mysql_password = "Amar123"
  }

  type = map(string)
}

resource "aws_secretsmanager_secret_version" "secret-email" {
  secret_id     = aws_secretsmanager_secret.creds.id
  secret_string = jsonencode(var.email)
}

resource "aws_eks_identity_provider_config" "eks_oidc" {
  cluster_name = aws_eks_cluster.eks.name

  oidc {
    client_id                     = "demo.c2id"
    identity_provider_config_name = "webidentity"
    issuer_url                    = "https://demo.c2id.com"
  }
}

resource "aws_iam_openid_connect_provider" "cluster" {
  url             = aws_eks_cluster.eks.identity.0.oidc.0.issuer
  client_id_list  = [ "sts.amazonaws.com" ]
  thumbprint_list = [ "9E99A48A9960B14926BB7F3B02E22DA2B0AB7280" ]

 }


#policy for secret manager
resource "aws_iam_policy" "secret_policy" {
  name = "webidentity_policy"
  policy = jsonencode({

    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "${aws_secretsmanager_secret.creds.arn}"
        }
    ]
})
}


resource "aws_iam_role" "secret_role" {
  name = "webidentity_role"
  assume_role_policy = jsonencode({

    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Principal": {
                "Federated": "arn:aws:iam::916547872461:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/1668B6092DE02E7A8A9BB35A247839D0"
            },
            "Condition": {
                "StringEquals": {
                    "oidc.eks.us-east-2.amazonaws.com/id/1668B6092DE02E7A8A9BB35A247839D0:sub": [
                        "system:serviceaccount:production:nginx"
                    ]
                }
            }
        }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.secret_role.name
  policy_arn = aws_iam_policy.secret_policy.arn
}

output "ASCP_installation" {
  value = "${aws_secretsmanager_secret_version.secret-email.arn}"
}
output "secret_arn" {
  value = "${aws_secretsmanager_secret_version.secret-email.arn}"
}
output "csi-driver" {
  value = "${null_resource.csi_installation}"
}
output "csi_driver_status" {
  value = "${null_resource.csi_installation}"
}

output "pod_logs" {
  value = "${null_resource.file_verfication}"
}
output "pod_file" {
  value = "${null_resource.file_verfication}"
}




