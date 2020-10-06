# Learning how to use Terraform with AWS

Simply following the video(_click image to watch video_): 

[![Terraform in 2 hours](https://img.youtube.com/vi/SLB_c_ayRMo/0.jpg)](https://www.youtube.com/watch?v=SLB_c_ayRMo)

This will build a basic AWS infrastructure and install a web server with apache.

## Requirements
- Terraform.
- AWS account.
- Clone `terraform.tfvars.sample` to `terraform.tfvars` and change accordingly.

## Usage

To perform a dry run: 
```console
terraform plan
```

To run the services:
```console
terraform apply --auto-approve
```

To destroy the services
```console
terraform destroy
```


