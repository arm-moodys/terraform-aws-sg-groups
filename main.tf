resource "aws_security_group" "main" {
  name        = var.name
  description = "${var.name} security group"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.name}"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "sg_allow_inbound" {
  for_each          = var.inbound_ports
  type              = "ingress"
  security_group_id = aws_security_group.main.id

  from_port        = each.value.port
  to_port          = each.value.port
  protocol         = "tcp"
  cidr_blocks      = var.ingress_cidr_ipv4
}

resource "aws_vpc_security_group_egress_rule" "alb_sg_allow_outbound" {
  depends_on                   = [aws_security_group.main]

  security_group_id            = aws_security_group.main.id
  ip_protocol                  = "tcp"
  from_port                    = "-1"
  to_port                      = "-1"
  cidr_ipv4                    = "0.0.0.0/0"
}
