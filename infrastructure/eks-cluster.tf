resource "aws_iam_role" "cloudsre-eks-iam-role" {

  name = "cloudsre-eks-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cloudsre-eks-iam-policy-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cloudsre-eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "cloudsre-eks-iam-policy-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cloudsre-eks-iam-role.name
}


resource "aws_eks_cluster" "cloudsre-eks-cluster" {

  name     = var.cluster-name
  role_arn = aws_iam_role.cloudsre-eks-iam-role.arn

    vpc_config {
      subnet_ids        = tolist(data.aws_subnets.nba_private_subnets.ids)
      security_group_ids = [aws_security_group.cloudsre-eks-cluster-sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cloudsre-eks-iam-policy-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cloudsre-eks-iam-policy-AmazonEKSVPCResourceController,
    aws_security_group.cloudsre-eks-cluster-sg

  ]
}

resource "aws_eks_addon" "addons" {
  count = var.deploy-eksaddons ? 1 : 0
  cluster_name      = aws_eks_cluster.cloudsre-eks-cluster.name
  addon_name        = "aws-ebs-csi-driver"
  addon_version     = "v1.13.0-eksbuild.2"
  resolve_conflicts = "OVERWRITE"
}
