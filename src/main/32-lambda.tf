resource "aws_cloudfront_function" "rewrite_uri" {
  #name    = "rewrite-request-${random_id.id.hex}"
  name    = "rewrite-request"
  runtime = "cloudfront-js-1.0"
  publish = true

  code = <<EOF
function handler(event) {
    var request = event.request;
    var uri = request.uri;
    
    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    } 
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }

    return request;
}
EOF
}