resource "aws_iam_role" "cloudsre-eks-worker-iam-role" {

  name = "cloudsre-eks-worker-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cloudsre-eks-worker-iam-policy-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.cloudsre-eks-worker-iam-role.name
}

resource "aws_iam_role_policy_attachment" "cloudsre-eks-worker-iam-policy-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.cloudsre-eks-worker-iam-role.name
}

resource "aws_iam_role_policy_attachment" "cloudsre-eks-worker-iam-policy-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.cloudsre-eks-worker-iam-role.name
}

resource "aws_eks_node_group" "cloudsre-nodegroup" {
  count = var.deploy-nodegroups ? 1 : 0
  cluster_name    = aws_eks_cluster.cloudsre-eks-cluster.name
  node_group_name = "cloudsre-nodegroup"
  node_role_arn   = aws_iam_role.cloudsre-eks-worker-iam-role.arn
  subnet_ids      = tolist(data.aws_subnets.nba_private_subnets.ids)
  disk_size       = 250
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.cloudsre-eks-worker-iam-policy-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.cloudsre-eks-worker-iam-policy-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.cloudsre-eks-worker-iam-policy-AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.cloudsre-eks-cluster
  ]
}
