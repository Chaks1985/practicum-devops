#Configure AutoScalling group
resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"

  min_size             = 1
  desired_capacity     = 1
  max_size             = 2

  health_check_type    = "ELB"
  load_balancers = [
    "${aws_elb.web_elb.id}"
  ]

  launch_configuration = "${aws_launch_configuration.web.name}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
#Collecting the metric granularity definision
  metrics_granularity = "1Minute"

  vpc_zone_identifier  = [
    "${aws_subnet.demosubnet.id}",
    "${aws_subnet.demosubnet1.id}"
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

}
#Choosing the AMI and instance type for out RORAPI and Reach JS application
resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  key_name = "tests"

  security_groups = [ "${aws_security_group.demosg.id}" ]
  associate_public_ip_address = true
  user_data = "${file("/root/aws_resource_terraform/Terrafrom-ELB-ASG/Project_reach_RoRAPI/module/data.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

#Setting up autoscalling policy for our worklead to spin up the resouces
resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.web.name}"
}
#Scale out
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "70"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.web_policy_up.arn}" ]
}
#Scale in
resource "aws_autoscaling_policy" "web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.web.name}"
}
#Cloud watch alarm
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.web_policy_down.arn}" ]
}

# Creating key pair
resource "aws_key_pair" "demokey" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key)}"
}
