/*
  The recommended approach is to use the ingress and egress blocks inline within the aws_security_group resource. This way, Terraform manages the entire set of rules as a single unit, and will add, update, or remove rules to match your configuration—removing any extra rules not defined in your code.
*/

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

  dynamic "ingress" {
    for_each = var.allow_internal_traffic ? [1] : []
    content {
      from_port   = 0
      to_port     = 0    # use 65535 for "TCP Traffic" 
      protocol    = "-1" # "tcp" for "TCP Traffic" 
      cidr_blocks = var.internal_cidr_blocks
      description = "Allow all internal traffic"
    }
  }

  dynamic "ingress" {
    for_each = var.ingress_prefix_list_rules
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      prefix_list_ids = ingress.value.prefix_list_ids
      description     = ingress.value.description
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