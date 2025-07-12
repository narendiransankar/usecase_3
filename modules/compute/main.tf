
resource "aws_instance" "web" {
  count         = length(var.public_subnet_ids)
  ami           = "ami-020cba7c55df1f615"
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[count.index]
  associate_public_ip_address = true
  vpc_security_group_ids = [var.web_sg_id]
  key_name      = var.key_name

user_data = file("${path.module}/userdata-0.sh")

  tags = {
    Name = "${var.env}-web-${count.index}"
  }
}
