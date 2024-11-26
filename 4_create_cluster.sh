
aws sagemaker create-cluster \
    --cli-input-json file://cluster-config.json \
    --region $AWS_REGION

aws sagemaker list-clusters \
 --output table \
 --region $AWS_REGION
