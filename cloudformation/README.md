# AWS CloudFormation Templates


### AWS CLI commands

Create stack <br>
`aws cloudformation create-stack --stack-name simpleEC2 --template-body file://cf-ec2.yaml`

Update stack <br>
`aws cloudformation update-stack --stack-name simpleEC2 --template-body file://cf-ec2.yaml`

Delete stack <br>
`aws cloudformation delete-stack --stack-name simpleEC2`


### For acloudguru AWS playground setup

Add keypair <br>
`aws cloudformation create-stack --stack-name default-keypair --template-body file://keypair-cf.yaml --profile playground --parameters ParameterKey=KeyPairName,ParameterValue=default-keypair --profile playground`

Grab private key<br>
```bash
keyPairID=$(aws ec2 describe-key-pairs --filters Name=key-name,Values=default-keypair --query KeyPairs[*].KeyPairId --output text --profile playground)

aws ssm get-parameter --name /ec2/keypair/$keyPairID --with-decryption --query Parameter.Value --output text --profile playground > default-keypair.pem

chmod 400 default-keypair.pem
```

``` Powershell
$keyPairID=(aws ec2 describe-key-pairs --filters Name=key-name,Values=default-keypair --query KeyPairs[*].KeyPairId --output text --profile playground)

aws ssm get-parameter --name /ec2/keypair/$keyPairID --with-decryption --query Parameter.Value --output text --profile playground | Out-File -FilePath default-keypair.pem
```

Add SSH Security Group <br>
`aws cloudformation create-stack --stack-name ssh-sg --template-body file://securitygroup-ssh-cf.yaml --profile playground`

### command for harbor-ec2-cf.yaml
```aws cloudformation create-stack --stack-name harbor --template-body file://harbor-ec2-cf.yaml --profile playground --parameters ParameterKey=myKeyPair,ParameterValue=default-keypair ParameterKey=myImageId,ParameterValue=${AMI} ParameterKey=mySecurityGroupIds,ParameterValue="'${SG-01},${SG-02}'" ParameterKey=mySubnetId,ParameterValue=${SUBNET-ID}```



### Resources

[AWS CloudFormation Docs](https://docs.aws.amazon.com/cloudformation/)