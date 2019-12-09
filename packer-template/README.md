# AMI image baking

## Structure
Packer is the tool to bake a source Centos 7 AMI into an initial Jenkins node one including.

### Packer configuration and installation
It is useful to describe two main components that are used by Packer to generate an AMI.
* packer-aws-jenkins-node.json: contains all packer configurations
* scripts/*.sh: provisioning scripts run on a temporary ec2 machine before ami creation 

#### tfe-aws.json
##### variables
* `aws_access_key_id`
* `aws_secret_access_key`
* `aws_region`
* `subnet_id`
* `inst_type`
* `ssh_user`

##### provisioners
It is the section in which the provisioning script is run on the newly created temporary ec2 machine. This section includes environmental variables to set on the machine before the script is executed.
