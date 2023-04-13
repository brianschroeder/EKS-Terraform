param([string]$eks_cluster_region,[string]$eks_cluster_name)

$EKS_CONTEXT = aws eks update-kubeconfig --region $eks_cluster_region --name $eks_cluster_name 2>&1

if ($EKS_CONTEXT -like '*Updated context*') { 
    Write-Host "$eks_cluster_name already exist in $eks_cluster_region."
    exit 1
} else {
    Write-Host "Confirmed $eks_cluster_name in $eks_cluster_region is not present, continuing."
}