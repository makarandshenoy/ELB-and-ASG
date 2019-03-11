resource "aws_autoscaling_group" "MakkuASG" {
  name                 = "MakkuASG"
  launch_configuration = "${aws_launch_configuration.MV-Testing-Launch_conf.name}"
  min_size             = 2
  max_size             = 2
  vpc_zone_identifier  = ["${data.aws_subnet.makkusub.id}"]
  health_check_type = "ELB"
  
}


resource "aws_autoscaling_attachment" "asgattachmenttoELB" {
    autoscaling_group_name = "${aws_autoscaling_group.MakkuASG.id}"
    elb = "${aws_elb.ClassicELB.id}"
}