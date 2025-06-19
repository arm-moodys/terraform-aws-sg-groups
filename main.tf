resource "aws_security_group" "main" {
  name        = var.name
  description = "${var.name} security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.inbound_ports
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidr_ipv4
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = "${var.name}"
    },
    var.tags
  )
}