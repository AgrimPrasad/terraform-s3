# S3 bucket for hosting static website
resource "aws_s3_bucket" "primary_domain" {
  bucket = "${var.primary_domain}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  website {
    index_document = "index.html"
  }

  tags {
    Name = "S3-${var.primary_domain}"
  }
}

# S3 bucket for redirection
resource "aws_s3_bucket" "secondary_domain" {
  bucket = "${var.secondary_domain}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  website {
    redirect_all_requests_to = "https://${var.primary_domain}"
  }

  tags {
    Name = "S3-${var.secondary_domain}"
  }
}

# terraform state bucket
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "terraform-remote-state-backend-${var.aws_account}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "terraform-remote-state-backend-${var.aws_account}"
  }
}

# Hello, world HTML file
resource "aws_s3_bucket_object" "index_html" {
  bucket       = "${aws_s3_bucket.primary_domain.id}"
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}
