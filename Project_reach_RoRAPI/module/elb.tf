#Creating ELB for our Auto Scalling VMs for RoRAPI,React JS
resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    "${aws_security_group.demosg1.id}"
  ]
  subnets = [
    "${aws_subnet.demosubnet.id}",
    "${aws_subnet.demosubnet1.id}"
  ]

  cross_zone_load_balancing   = true
 #Healthcheck is pointed to Port 22 (TCP) to avide multiple VM spin due to some readon in data.sh
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "TCP:22"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

}
