

resource "aws_launch_configuration" "MV-Testing-Launch_conf" {
  image_id      = "${data.aws_ami.ami.id}"
  instance_type = "${var.amitype}"
  key_name = "max"
  associate_public_ip_address = "true"
  security_groups = ["${aws_security_group.makkusg.id}"]


  user_data = <<-EOF
              #!/bin/bash
              yum -y install httpd
              service httpd start
              yum -y install git
              cd /home/ec2-user
              git clone https://github.com/VijayKumarKamsali/Test1.git 
              cp /home/ec2-user/Test1/index.html /var/www/html
              EOF

  lifecycle {
      create_before_destroy = true
  }
}
