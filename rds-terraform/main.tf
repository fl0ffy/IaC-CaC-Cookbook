provider "aws" {
    region     = "${var.region}"
    # access_key = "${var.access_key}"
    # secret_key = "${var.secret_key}"
}

# AWS::KMS::Alias
resource "aws_kms_alias" "a" {
  name          = "alias/my-key-alias"
  target_key_id = aws_kms_key.a.key_id
}

# AWS::KMS::Key
#what type of key?

# AWS::SecretsManager::Secret
# Creating an AWS Secret 
# resource "random_password" "password" {
#   length           = 20
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

data "aws_secretsmanager_random_password" "password" {
  password_length     = 20
  exclude_punctuation = true
  exclude_characters  = "\"@/\\"
}


resource "aws_secretsmanager_secret" "zephyr-rds-mysql-secret" {
  name                    = "zephyr-rds-mysql-db-credentials"
  description             = "MySQL DB Credentials"
  recovery_window_in_days = 0
  tags = {
    Name        = "zephyr-rds-mysql-secret"
  }
}

#update secret with values
# multiple values
resource "aws_secretsmanager_secret_version" "zephyr-rds-mysql-secret" {
  secret_id     = aws_secretsmanager_secret.zephyr-rds-mysql-secret.id
  secret_string = aws_secretsmanager_random_password.password.random_password
}


#create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# AWS::RDS::DBSubnetGroup
#figure out how to search and use available subnets
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]

  tags = {
    Name = "My DB subnet group"
  }
}


#create a RDS Database Instance
resource "aws_db_instance" "myinstance" {
  engine               = "mysql"
  identifier           = "myrdsinstance"
  allocated_storage    =  20
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "myrdsuser"
  password             = "myrdspassword"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot  = true
  publicly_accessible =  true
}