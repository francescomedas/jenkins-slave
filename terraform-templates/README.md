# AWS infrastructure building

Terraform is the tool to plan/apply the infrastructure hosting the Jenkins slaves infrastructure and it is composed by:

  * 1 EC2 instance in autoscaling group with min, max and desired value defined as parameters

## Environment switching

The Terraform code uses the backend config option to switch from dev to prod environment using the same configuration files.

```
terraform {
  backend "s3" {
    # settings defined in backend/{target_env}.conf
  }
}
```

While at `terraform init` issue time, environment is referred with the command

```
terraform init -backend-config=environment/${TARGET_ENV}.conf -input=false
```

## Note:
Before to run this terraform code please make sure the following requirements are satisfied:
- CSRF Protection into the Jenkins Master has to be disabled (this has to be fixed)
- The key passed as variable key_name has to be added to the Jenkins Vault and its credential id should be passed as jenkins_credential_id parameter