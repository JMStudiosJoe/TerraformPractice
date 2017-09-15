resource "aws_route53_zone" "jmstudio" {
  name = "jmstud.io"
}

resource "aws_route53_record" "jmstud_record" {
  name = "jmstud_record"
  zone_id = "${aws_route53_zone.jmstudio.zone_id}" 
  type = "A"
  ttl  = "300"
  records = ["${aws_instance.JMStudiosServer.public_ip}"]
}

