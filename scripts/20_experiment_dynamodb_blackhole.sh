
aws iam create-role --role-name network-fis-role --assume-role-policy-document file://~//environment/workshopfiles/fis-workshop/net-experiment/fis-trust-policy.json
aws iam attach-role-policy --role-name network-fis-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorNetworkAccess
aws iam attach-role-policy --role-name network-fis-role --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess


export NETWORK_FIS_ROLE=$(aws iam get-role --role-name network-fis-role | jq -r .Role.Arn)
echo "export "NETWORK_FIS_ROLE=${NETWORK_FIS_ROLE} | tee -a ~/.bash_profile

jq --arg id $ACCOUNT_ID 'walk(if type == "string" then gsub("\\d{12}"; $id ) else . end)' ../fis-experiments/20_experiment_ddb_template.json > /tmp/template.json
export FIS_EXP_02_ID=$(aws fis create-experiment-template \
    --cli-input-json file:///tmp/template.json)

echo "export FIS_EXP_02_ID=${FIS_EXP_01_ID}" | tee -a ~/.bash_profile



