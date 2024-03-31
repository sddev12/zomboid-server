resource "aws_route53_record" "A" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "rackam.ninja"
  type    = "A"
  ttl     = 300
  records = [aws_eip.eip.public_ip]
}
