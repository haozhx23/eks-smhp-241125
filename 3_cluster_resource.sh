
curl https://raw.githubusercontent.com/aws-samples/awsome-distributed-training/main/1.architectures/7.sagemaker-hyperpod-eks/LifecycleScripts/base-config/on_create.sh --output on_create.sh

export LIFECYCLE_S3_PATH=s3://$LIFECYCLE_S3_BUCKET/$EKS_CLUSTER_NAME/lifecycle/
aws s3 cp on_create.sh $LIFECYCLE_S3_PATH

cat > cluster-config.json << EOL
{
    "ClusterName": "SMHP-v1-$EKS_CLUSTER_NAME",
    "Orchestrator": { 
      "Eks": 
      {
        "ClusterArn": "${EKS_CLUSTER_ARN}"
      }
    },
    "InstanceGroups": [
      {
        "InstanceGroupName": "worker-group-1",
        "InstanceType": "${ACCEL_INSTANCE_TYPE}",
        "InstanceCount": ${ACCEL_COUNT},
        "InstanceStorageConfigs": [
          {
            "EbsVolumeConfig": {
              "VolumeSizeInGB": ${ACCEL_VOLUME_SIZE}
            }
          }
        ],
        "LifeCycleConfig": {
          "SourceS3Uri": "${LIFECYCLE_S3_PATH}",
          "OnCreate": "on_create.sh"
        },
        "ExecutionRole": "${EXECUTION_ROLE_ARN}",
        "ThreadsPerCore": 1,
        "OnStartDeepHealthChecks": ["InstanceStress", "InstanceConnectivity"]
      }
    ],
    "VpcConfig": {
      "SecurityGroupIds": ["$SECURITY_GROUP"],
      "Subnets":["$SUBNET_ID"]
    },
    "NodeRecovery": "${NODE_RECOVERY}"
}
EOL