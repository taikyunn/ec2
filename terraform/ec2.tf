# Amazon Linux 2 の最新版AMIを取得
data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# EC2作成
# サブネットの設定がないエラーになる。
resource "aws_instance" "ec2-instance-test" {
  ami                         = data.aws_ssm_parameter.amzn2_latest_ami.value
  instance_type               = "t2.micro"
  availability_zone           = "ap-northeast-1a"
  subnet_id                   = aws_subnet.subnet-test.id
  vpc_security_group_ids      = [aws_security_group.security_group-test.id]
  associate_public_ip_address = "true"

  tags = {
    "Name" = "ec2-instance-test"
  }
}
