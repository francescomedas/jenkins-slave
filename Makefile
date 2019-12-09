.PHONY: all
all: install-dep terraform-cmd

# We use bashisms so this ensures stuff works as expected
SHELL := /bin/bash -l
PACKER_VERSION := 1.4.5
TERRAFORM_VERSION := 0.12.16

# Download and install required binaries files
install-dep:
	curl -o packer.zip \
	https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
	yes | unzip packer.zip
	sudo chmod +x packer && mv packer /usr/bin
	curl -o terraform.zip \
	https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
	yes | unzip terraform.zip
	sudo chmod +x terraform && mv terraform /usr/bin

# Validate the packer file configuration to bake the Jenkins AMI
packer-validate:
	@echo "===> Validating the Packer configuration"
	packer validate packer-template/packer-aws-jenkins-node.json

# Execute the packer configuration and bake the Jenkins AMI
packer-build:
	@echo "===> Building AMI"
	packer build packer-template/packer-aws-jenkins-node.json | sudo tee -a /tmp/build.log
	@echo "===> Save AmiID into /tmp/ami.txt"
	sudo tail -2 /tmp/build.log | head -2 | awk 'match($$0, /ami-.*/) { print substr($$0, RSTART, RLENGTH) }' > sudo /tmp/ami.txt
	sudo cat /tmp/ami.txt

# Run terraform commands
terraform-cmd: terraform-fmt terraform-init terraform-plan terraform-apply

# Format the terraform code
terraform-fmt:
	cd terraform-templates && \
	terraform fmt

# Perform a terraform init parametrized per environment
terraform-init:
	cd terraform-templates && \
	terraform init -backend-config=environment/${TARGET_ENV}.conf -input=false
	terraform get -update terraform-templates

# Perform a validation of the terraform files parametrized per environment
terraform-validate:
	cd terraform-templates && \
	terraform validate -var-file=vars/${TARGET_ENV}.tfvars

# Produce the terraform plan parametrized per environment
terraform-plan:
	@cd terraform-templates && \
	terraform plan -var-file=vars/${TARGET_ENV}.tfvars -var="jenkins_password=${jenkins_password}" -input=false -out=tfplan

# Apply the terraform plan parametrized per environment
terraform-apply:
	@cd terraform-templates && \
	terraform apply -input=false -auto-approve tfplan

# Destroy the infrastructure provisioned on the environment specified by the TARGET_ENV parameter
terraform-destroy:
	@cd terraform-templates && \
	terraform destroy -input=false -auto-approve -refresh=false -var="jenkins_password=${jenkins_password}" -var-file=vars/${TARGET_ENV}.tfvars

# Clear the terraform temporary files
clean:
	rm -rf terraform*
