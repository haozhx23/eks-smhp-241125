
cat > hyperpod-eks-policy.json << EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "${EXECUTION_ROLE_ARN}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:CreateAccessEntry",
                "eks:DescribeAccessEntry",
                "eks:DeleteAccessEntry",
                "eks:AssociateAccessPolicy",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeSecurityGroups",
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*"
        }
    ]
}
EOL

aws iam create-policy \
    --policy-name hyperpod-eks-policy \
    --policy-document file://hyperpod-eks-policy.json \
    --region $AWS_REGION


cat > cfn-stack-policy.json << EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:CreateStack",
				"ec2:AuthorizeSecurityGroupEgress",
				"ec2:AuthorizeSecurityGroupIngress",
				"ec2:CreateNatGateway",
				"ec2:CreateTags",
				"ec2:CreateVpc",
				"ec2:CreateRouteTable",
				"ec2:AttachInternetGateway",
				"ec2:AssociateVpcCidrBlock",
				"ec2:AllocateAddress",
				"ec2:AssociateRouteTable",
				"ec2:CreateFlowLogs",
				"ec2:CreateSecurityGroup",
				"ec2:CreateInternetGateway",
                "ec2:CreateSubnet",
				"eks:CreateAddon",
				"eks:CreateAccessEntry",
				"eks:CreateCluster",
                "iam:CreateRole",
				"s3:CreateBucket",
                "ecr-public:*",
                "sts:GetServiceBearerToken"

            ],
            "Resource": "*"
        }
    ]
}
EOL

aws iam create-policy \
    --policy-name cfn-stack-policy \
    --policy-document file://cfn-stack-policy.json \
    --region $AWS_REGION



ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# aws iam attach-role-policy \
#     --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/hyperpod-eks-policy \
#     --role-name $EXECUTION_ROLE_NAME \
#     --region $AWS_REGION

# aws iam attach-role-policy \
#     --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/cfn-stack-policy \
#     --role-name $EXECUTION_ROLE_NAME \
#     --region $AWS_REGION

# aws iam attach-role-policy \
#     --policy-arn arn:aws:iam::aws:policy/AmazonSageMakerClusterInstanceRolePolicy \
#     --role-name $EXECUTION_ROLE_NAME \
#     --region $AWS_REGION

# aws iam attach-role-policy \
#     --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy \
#     --role-name $EXECUTION_ROLE_NAME \
#     --region $AWS_REGION


# aws iam attach-role-policy \
#     --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess \
#     --role-name $EXECUTION_ROLE_NAME \
#     --region $AWS_REGION

# aws iam attach-role-policy \
#     --policy-arn arn:aws:iam::aws:policy/AmazonSageMakerFullAccess \
#     --role-name $EXECUTION_ROLE_NAME \
#     --region $AWS_REGION

aws iam attach-role-policy --cli-input-json '{
  "RoleName": "'$EXECUTION_ROLE_NAME'",
  "PolicyArn": [
    "arn:aws:iam::'${ACCOUNT_ID}':policy/hyperpod-eks-policy",
    "arn:aws:iam::${ACCOUNT_ID}:policy/cfn-stack-policy",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSageMakerClusterInstanceRolePolicy",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
  ]
}' --region $AWS_REGION
