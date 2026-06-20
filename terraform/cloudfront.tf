# ── CloudFront: free HTTPS front door ─────────────────────────────────────────
# Puts a CloudFront distribution in front of the (HTTP-only) ALB. CloudFront
# terminates TLS with its own valid certificate on a *.cloudfront.net domain, so
# the app gets HTTPS with no custom domain or paid certificate. It acts as a
# pass-through proxy (caching disabled, all headers/cookies/query strings
# forwarded) so the dynamic app and sessions work normally.

locals {
  alb_origin_id = "${var.app_name}-alb"
}

resource "aws_cloudfront_distribution" "app" {
  enabled     = true
  comment     = "${var.app_name} HTTPS front door"
  price_class = "PriceClass_100" # cheapest edge footprint (US/EU)

  origin {
    domain_name = aws_lb.main.dns_name
    origin_id   = local.alb_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # CloudFront -> ALB over HTTP (inside AWS)
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = local.alb_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]

    # AWS managed policies: CachingDisabled + AllViewer (forward everything).
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = { Name = "${var.app_name}-cdn" }
}
