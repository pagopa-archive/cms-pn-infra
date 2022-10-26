## Lambda edge which add index.html at the end subpath


resource "aws_iam_role" "lambda_role" {

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        },
      },
    ]
  })
}

resource "aws_cloudwatch_log_group" "lambda_edge" {
  # The name must match what the default log group is named for the lambda function
  # in order to have the retention value applied.
  provider          = aws.us-east-1
  name              = "/lambda/cns-subdir-path"
  retention_in_days = var.logs_lambda_retention
}

resource "aws_iam_policy" "lambda_logging" {
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

data "archive_file" "cdn_index_lambda" {
  type        = "zip"
  source_file = "../lambda/cdn-index.js"
  output_path = "cdn-index-lambda.zip"
}

resource "aws_lambda_function" "cdn_index" {
  provider = aws.us-east-1

  depends_on    = [aws_iam_role_policy_attachment.lambda_logs]
  filename      = data.archive_file.cdn_index_lambda.output_path
  function_name = "cdn-index"
  role          = aws_iam_role.lambda_role.arn
  handler       = "viewer_request.handler"

  source_code_hash = filebase64sha256(data.archive_file.cdn_index_lambda.output_path)

  runtime = "nodejs16.x"

  publish = true
}