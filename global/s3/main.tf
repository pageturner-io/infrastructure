resource "aws_s3_bucket" "terraform_state" {
  bucket = "pageturner-terraform-state"
  acl    = "private"

  tags {
    Name = "Pageturner Terraform State"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "builds" {
  bucket = "pageturner-cd-builds"
  acl    = "private"

  tags {
    Name = "CI/CD pipeline artifacts"
  }
}

resource "aws_s3_bucket" "website" {
  bucket = "${var.www_domain_name}"

  acl = "public-read"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.www_domain_name}/*"]
    }
  ]
}
POLICY

  website {
    index_document = "index.html"

    error_document = "404.html"
  }
}
