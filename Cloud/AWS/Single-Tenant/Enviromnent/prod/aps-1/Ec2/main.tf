######################## public Instance #####################################

resource "aws_instance" "factoryfeed-pub" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.security_groups] ### calling this from VPC workspace ##########
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnets_id        ### calling this from VPC workspace ##########
  tags = {
    Name        = "${var.Name}-prod-1"
    Environment = "${var.Environment}"
  }
}

####################### private Instance #####################################

resource "aws_instance" "factoryfeed-prv" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [data.terraform_remote_state.SG.outputs.security_group] ### calling this from security group workspace ##########
  subnet_id              = data.terraform_remote_state.SG.outputs.subnet_id        ### calling this from security group workspace ##########
  tags = {
    Name        = "${var.Name}-prod-2"
    Environment = "${var.Environment}"
  }
}

################## EIP for Public Instance ###################################
resource "aws_eip" "TF_EIP1" {
  instance = aws_instance.factoryfeed-pub.id
  # vpc      = true
  domain = "vpc"
}

################## EIP for Private Instance ###################################
# resource "aws_eip" "TF_EIP2" {
#   instance = aws_instance.instance2.id
#   # vpc      = true
#   domain = "vpc"
# }

################### EBS Public Instance #####################################
resource "aws_ebs_volume" "factoryfeed-EBS1" {
  availability_zone = var.availability_zone
  size              = 100
  type              = "gp3"

  tags = {
    Name        = "TF_Demo_EBS"
    Environment = var.Environment
  }
}

################### EBS Private Instance #####################################
# resource "aws_ebs_volume" "factoryfeed-EBS2" {
#   availability_zone = var.availability_zone
#   size              = 50
#   type              = "gp3"

#   tags = {
#     Name        = "TF_Demo_EBS"
#     Environment = var.Environment
#   }
# }

##################### EBS attachment for Public Instance ##########################
resource "aws_volume_attachment" "EBS_attach1" {
  volume_id   = aws_ebs_volume.factoryfeed-EBS1.id
  instance_id = aws_instance.factoryfeed-pub.id
  device_name = "/dev/sdh"
}

##################### EBS attachment for Private Instance ##########################
# resource "aws_volume_attachment" "EBS_attach2" {
#   volume_id   = aws_ebs_volume.factoryfeed-EBS2.id
#   instance_id = aws_instance.instance2.id
#   device_name = "/dev/sdh"
# }