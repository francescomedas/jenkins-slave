instance_type      = "t2.micro"
key_name           = "jenkinstest"
vpc_id             = "vpc-0ffa66d9200fd3961"
vpc_cidr           = ["10.1.0.0/16"]
private_subnet_ids = ["subnet-037cc4ee4bfef184c", "subnet-05dfe70a48a0463a6", "subnet-0899dfd618e904306"]
public_subnet_ids  = ["subnet-01f6e371859e8a22c", "subnet-0c04ebe7529ae7197", "subnet-08090d03198666c24"]

jenkins_url="http://jenkins-master-44df1b7df8e10bb9.elb.eu-west-1.amazonaws.com/"
// INSERT CREDENTIALS BEFORE
jenkins_credentials_id="slave_keypair"
// DISABLE CSRF Protection
jenkins_username="admin"

slaves_max_size = 5
slaves_min_size = 1
slaves_desired_capacity = 3

resources_tags = {
    Name = "jenkins-master",
    Application = "Jenkins",
    Owner = "DevOps Platform"
}