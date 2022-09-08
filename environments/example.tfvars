# Generics
region                      = "us-east-1"
env                         = "dev"
project                     = "example"
# Take care that if you set create_prefix_for_resources variable in true all the resources names will change
create_prefix_for_resources = true

# Networks
vpc              = [{ name = "vpc", cidr_block = "10.0.0.0/16", instance_tenancy = "default", enable_dns_hostnames = true, enable_dns_support = true }]
# Take care in configure the availability_zone in the same region
subnet_public    = [{ name = "subnet_public", cidr_block = "10.0.1.0/24", availability_zone = "us-east-1a", map_public_ip_on_launch = true }]
subnet_private_1 = [{ name = "subnet_private_1", cidr_block = "10.0.2.0/24", availability_zone = "us-east-1a", map_public_ip_on_launch = true }]
subnet_private_2 = [{ name = "subnet_private_2", cidr_block = "10.0.3.0/24", availability_zone = "us-east-1b", map_public_ip_on_launch = false }]

# EC2
ec2name               = "ec2-instance"
key_name              = "ec2-dev-key"
# Check that the amiid selected belongs to the region configured
amiid                 = "ami-0ab4d1e9cf9a1215a"
size                  = "t2.micro"
root_disk             = [{ volume_size = "8", volume_type = "gp2" }]
# To be run after creation
create_machine_script = "create_machine_script.tmpl"

# S3
bucket                    = [{ bucket = "bucket", acl = "private" }]
create_bucket_access_user = false
cors_rule                 = [{allowed_methods = ["GET"], allowed_origins = ["my-origin"], max_age_seconds = 3000}]

# RDS
rds-master         = [{ Name = "db-master" , engine = "postgres", engine_version = "13.4" , instance_class = "db.t3.micro" ,allocated_storage = 5, family = "postgres13"}]
db-name            = "db"
secret_password_id = "example/db/dev"
create_replica     = false
subnet_group       = "subnet_group"

# Elastic IP
# We recommend using an elastic ip unless for production
create_elastic_ip = true

# ECR
ecr_repositories       = []
# ecr_repositories     = ["repository_1", "repository_2"]
create_ecr_access_user = false
