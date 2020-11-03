provider "aws" {
  version = "2.33.0"

  region = var.aws_region
}

provider "random" {
  version = "2.2"
}

resource "random_pet" "table_name" {}

resource "aws_dynamodb_table" "tfc_example_table" {
  name = "${var.app_name}-${var.db_table_name}-${random_pet.table_name.id}"
  tags = {
    Name = var.app_name
    environment = var.app_environment
  }
  read_capacity  = var.db_read_capacity
  write_capacity = var.db_write_capacity
  hash_key       = "UUID"
  range_key      = "UserName"

  attribute {
    name = "UUID"
    type = "S"
  }

  attribute {
    name = "UserName"
    type = "S"
  }
}

resource "aws_instance" "basic" {
  ami           = "ami-0ee1a20d6b0c6a347"
  instance_type = "t3.nano"
  tags = {
    Name = var.app_name
    environment = var.app_environment
  }
}


resource "aws_instance" "example" {
  ami           = "ami-066663db63b3aa675"
  instance_type = "t2.micro"
  security_groups = ["aws_security_group.allow_rdp.name"]
  tags = {
    Name = var.app_name
    environment = var.app_environment
  }

}

resource "aws_security_group" "allow_rdp" {
  name        = "allow_rdp"
  description = "Allow ssh traffic"
  tags = {
    Name = var.app_name
    environment = var.app_environment
  }

  ingress {

    from_port   = 3389 #  By default, the windows server listens on TCP port 3389 for RDP
    to_port     = 3389
    protocol =   "tcp"

    cidr_blocks =  ["0.0.0.0/0"]
  }

  
}
