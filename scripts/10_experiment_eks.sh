

## Experiment 1 prereqs for EKS
aws iam create-role --role-name eks-fis-role --assume-role-policy-document file://~/environment/workshopfiles/fis-workshop/eks-experiment/fis-trust-policy.json
aws iam attach-role-policy --role-name eks-fis-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorNetworkAccess
aws iam attach-role-policy --role-name eks-fis-role --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
aws iam attach-role-policy --role-name eks-fis-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorEKSAccess
aws iam attach-role-policy --role-name eks-fis-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorEC2Access
aws iam attach-role-policy --role-name eks-fis-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorSSMAccess
aws iam attach-role-policy --role-name eks-fis-role --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess

export FIS_EKS_ROLE=$(aws iam get-role --role-name eks-fis-role | jq -r .Role.Arn)
echo "export "FIS_EKS_ROLE=${FIS_EKS_ROLE} | tee -a ~/.bash_profile

aws eks update-kubeconfig --name PetSite --region $AWS_REGION
kubectl apply -f ~/environment/workshopfiles/fis-workshop/eks-experiment/rbac.yaml
eksctl create iamidentitymapping \
--arn arn:aws:iam::$ACCOUNT_ID:role/eks-fis-role \
--username fis-experiment \
--cluster PetSite \
--region=$AWS_REGION

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

## Create experiment 1

jq --arg id $ACCOUNT_ID 'walk(if type == "string" then gsub("\\d{12}"; $id ) else . end)' ../fis-experiments/10_experiment_eks_template.json > /tmp/template.json
export FIS_EXP_01_ID=$(aws fis create-experiment-template \
    --cli-input-json file:///tmp/template.json | jq -r .experimentTemplate.id)

echo "export FIS_EXP_01_ID=${FIS_EXP_01_ID}" | tee -a ~/.bash_profile
