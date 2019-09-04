# ticket_18683

## Terraform required version
0.12.7

## Instructions 
- clone repo: `git clone https://github.com/berchev/ticket_18683.git`
- export credentials:
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```
- make sure variable **enabled_cluster_log_types** has value **["api", "audit"]**
- terraform init
- terraform apply

- Cloudwatch log group will be created
- In AWS Web menu type choose **Services** then **EKS** then choose cluster called **example** then scroll down to **logging**. API and AUDIT should be enabled!


- edit **main.tf** and change variable **enabled_cluster_log_types** to **default = []**
- terraform apply
- Cloudwatch log group will be destroyed. 
- In AWS Web menu type choose **Services** then **EKS** then choose cluster called **example** then scroll down to **logging**. API and AUDIT should be DISABLED!

- In AWS Web menu type choose **Services** then **CloudWatch** then in left pane **Logs** and you will notice that log group will be there! it is NOT deleted!

- make sure variable **enabled_cluster_log_types** has value **["api", "audit"]**
- terraform apply

- ERROR
```
Error: Creating CloudWatch Log Group failed: ResourceAlreadyExistsException: The specified log group already exists
	status code: 400, request id: 997b3ea5-297b-4013-bfa8-f5701876af86:  The CloudWatch Log Group '/aws/eks/example/cluster' already exists.

  on main.tf line 59, in resource "aws_cloudwatch_log_group" "example":
  59: resource "aws_cloudwatch_log_group" "example" {

```
