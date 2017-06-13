data "aws_route53_zone" "distribute" {
  name = "distribute.com"
}

data "aws_route53_zone" "distribute-int" {
  name = "int.distribute.com"
  vpc_id = "${data.aws_vpc.default.id}"
}

resource "aws_route53_record" "BackendServer" {
  zone_id = "${data.aws_route53_zone.distribute-int.zone_id}"
  name = "ctrl.int.distribute.com"
  type = "A"
  ttl  = "300"
  records = ["${aws_instance.ansible-ctrl.public_ip}"]
}

resource "aws_route53_record" "CeleryServer" {
  zone_id = "${data.aws_route53_zone.distribute-int.zone_id}"
  name = "load.int.distribute.com"
  type = "A"
  ttl  = "300"
  records = ["${aws_instance.load.private_ip}"]
}

