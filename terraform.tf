data "aws_ami" "ami" {
    owners = ["amazon"]
    most_recent      = true
    name_regex = "amzn-ami-hvm"

}

output "amis" {
  value = "${data.aws_ami.ami.id}"
}


data "aws_vpc" "Makkuvpc" {
    filter = {
         name = "tag:Name"
         values = ["MakkuVPC"]
    }
}

output "Makkuvpc" {
  value = "${data.aws_vpc.Makkuvpc.id}"
}

data "aws_subnet_ids" "mysubnets" {
  vpc_id = "${data.aws_vpc.Makkuvpc.id}"
}

output "mysubnets" {
  value = "${data.aws_subnet_ids.mysubnets.ids}"
}

data "aws_subnet" "makkusub" {
    vpc_id = "${data.aws_vpc.Makkuvpc.id}"
   filter {
       name = "availability-zone"
       values = ["us-east-1c"]
   }
}

output "makkusub" {
  value = "${data.aws_subnet.makkusub.id}"
}

resource "aws_security_group" "makkusg" {
  name        = "makku_sg"
  description = "Allow TLS inbound traffic"
  vpc_id="${data.aws_vpc.Makkuvpc.id}"

  ingress {   
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { 
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { 
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

data "aws_instances" "ASGInstances" {
  filter {
    name = "tag:aws:autoscaling:groupName"
    values = ["${aws_autoscaling_group.MakkuASG.name}"]
  }
}

output "instanceIDs" {
  value = "${data.aws_instances.ASGInstances.ids}"
}
