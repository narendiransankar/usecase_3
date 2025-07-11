
resource "aws_instance" "web" {
  count         = length(var.public_subnet_ids)
  ami           = "ami-020cba7c55df1f615"
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [var.web_sg_id]
  key_name      = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Hello from ${var.env} Web Server ${count.index + 1}</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.env}-web-${count.index}"
  }
}
