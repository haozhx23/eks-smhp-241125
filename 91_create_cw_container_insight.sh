aws iam attach-role-policy \
--role-name $EXECUTION_ROLE_NAME \
--policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

aws eks create-addon --addon-name amazon-cloudwatch-observability --cluster-name $EKS_CLUSTER_NAME