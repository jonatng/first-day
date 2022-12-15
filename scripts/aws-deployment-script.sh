---
AWSTemplateFormatVersion: '2022-10-11'
Description: 'AWS CloudFormation template for deploying changes to a Salesforce org'

Resources:
  # IAM role for deploying changes to the Salesforce org
  DeploymentRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2022-10-11'
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - 'codebuild.amazonaws.com'
            Action:
              - 'sts:AssumeRole'
      Path: /
      Policies:
        - PolicyName: 'salesforce-deployment'
          PolicyDocument:
            Version: '2022-10-11'
            Statement:
              - Effect: Allow
                Action:
                  - 's3:GetObject'
                  - 's3:PutObject'
                Resource:
                  - 'arn:aws:s3:::${S3Bucket}/*'
              - Effect: Allow
                Action:
                  - 's3:ListBucket'
                Resource:
                  - 'arn:aws:s3:::${S3Bucket}'

  # CodeBuild project for deploying changes to the Salesforce org
  DeploymentProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        ComputeType: BUILD_GENERAL1_SMALL
        Image: 'aws/codebuild/salesforce-dx:2.0'
        Type: LINUX_CONTAINER
        EnvironmentVariables:
          - Name: SF_USERNAME
            Value: 'your_username'
          - Name: SF_PASSWORD
            Value: 'your_password_and_security_token'
          - Name: SF_DEPLOY_ON_BUILD
            Value: 'true'
      Source:
        Type: CODEPIPELINE
      ServiceRole: !GetAtt 'DeploymentRole.Arn'

  # CodePipeline pipeline for deploying changes to the Salesforce org
  DeploymentPipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      RoleArn: !GetAtt 'DeploymentRole.Arn'
      Stages:
        - Name: 'Source'
          Actions:
            - Name: 'Source'
              ActionTypeId:
                Category: 'Source'
                Owner: 'AWS'
                Provider: 'S3'
                Version: '1'
              OutputArtifacts:
                - Name: 'SourceArtifact'
              Configuration:
                S3Bucket: 'your_source_bucket_name'
                S3ObjectKey: 'your_source_zip_file.zip'
        - Name: 'Build'
          Actions:
            - Name: 'Build'
              ActionTypeId:
                Category: 'Build'
                Owner: 'AWS'
                Provider: 'CodeBuild'
                Version: '1'
              InputArtifacts:
                - Name: 'SourceArtifact'
              OutputArtifacts:
                - Name: 'BuildArtifact'
