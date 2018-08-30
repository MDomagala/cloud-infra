data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.role.id}"
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["arn:aws:s3:::me-and-myself-s3-bucket"]
      },
      {
        "Effect": "Allow",
        "Action": ["s3:GetObject"],
        "Resource": ["arn:aws:s3:::me-and-myself-s3-bucket/*"]
      }
    ]
  }
EOF
}

resource "aws_iam_role" "role" {
  name = "test_role"
  assume_role_policy = <<EOF
{
    "Version": "2018-08-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

data "template_file" "user_data" {
  template = "${file("userdata.sh")}"
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.sn1.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.icmp.id}"]
  key_name = "${aws_key_pair.keypair.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  user_data = "${data.template_file.user_data.template}"

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 1
    volume_type = "gp2"
    delete_on_termination = false
  }

  tags {
    Name = "HelloWorld"
  }
}



