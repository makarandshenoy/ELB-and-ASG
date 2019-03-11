resource "aws_elb" "ClassicELB" {
  name               = "Testing"
  
  subnets = ["${data.aws_subnet.makkusub.id}"]
  security_groups = ["${aws_security_group.makkusg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  instances                   = ["${data.aws_instances.ASGInstances.ids}"]
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "MakkuELB"
  }
}