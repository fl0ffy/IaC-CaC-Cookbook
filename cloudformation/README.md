# AWS CloudFormation Templates


### AWS CLI commands

Create stack <br>
`aws cloudformation create-stack --stack-name simpleEC2 --template-body file://cf-ec2.yaml`

Update stack <br>
`aws cloudformation update-stack --stack-name simpleEC2 --template-body file://cf-ec2.yaml`

Delete stack <br>
`aws cloudformation delete-stack --stack-name simpleEC2`


### Resources

[AWS CloudFormation Docs](https://docs.aws.amazon.com/cloudformation/)