
# Create an S3 bucket
resource "aws_s3_bucket_acl" "s3_sqs_cloudwatch_bucket" {
  bucket = "s3_sqs_cloudwatch-bucket" # Replace with your desired bucket name
}

# Create an SQS queue
resource "aws_sqs_queue" "s3_sqs_cloudwatch_queue" {
  name = "s3_sqs_cloudwatch-queue" # Replace with your desired queue name
}

# Modify the access policy of the SQS queue
resource "aws_sqs_queue_policy" "s3_sqs_cloudwatch_queue_policy" {
  queue_url = aws_sqs_queue.s3_sqs_cloudwatch_queue.url

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqsevent",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": [
        "SQS:SendMessage"
      ],
      "Resource": "${aws_sqs_queue.s3_sqs_cloudwatch_queue.arn}",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "ENTER_ARN_OF_S3_BUCKET"
        }
      }
    }
  ]
}
POLICY
}

# Configure event notifications for the S3 bucket
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket_acl.s3_sqs_cloudwatch_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.s3_sqs_cloudwatch_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".txt" # Replace with your desired file suffix
  }
}

# Create an IAM policy for the Lambda function
resource "aws_iam_policy" "lambda_policy" {
  name        = "sqs-lambda"
  description = "IAM policy for Lambda function"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "ENTER_ARN_OF_CLOUDWATCH_LOG"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "ENTER_ARN_OF_CLOUDWATCH_LOG"
      ]
    }
  ]
}
POLICY
}

# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "sqs-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "s3_sqs_cloudwatch-lambda-function" # Replace with your desired function name
  handler       = "index.handler"
  runtime       = "python3.8"
  timeout       = 10
  memory_size   = 128
  role          = aws_iam_role.lambda_role.arn
  s3_bucket     = aws_s3_bucket_acl.s3_sqs_cloudwatch_bucket.id
  s3_key        = "lambda_function.zip"
  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.s3_sqs_cloudwatch_queue.url
    }
  }
}
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
}

# Create an IAM role for the CloudWatch Logs group
resource "aws_iam_role" "log_group_role" {
  name = "log-group-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "logs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

# Attach policies to the CloudWatch Logs role
resource "aws_iam_role_policy_attachment" "log_group_policy_attachment" {
  role       = aws_iam_role.log_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Add permissions for the Lambda function to write to the CloudWatch Logs group
resource "aws_cloudwatch_log_resource_policy" "log_resource_policy" {
  policy_name     = "log-resource-policy"
  policy_document = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowLambdaToWriteLogs",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "logs:CreateLogStream",
      "Resource": "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.log_group.name}:*"
    },
    {
      "Sid": "AllowLambdaToPutLogs",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "logs:PutLogEvents",
      "Resource": "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.log_group.name}:log-stream:*"
    }
  ]
}
POLICY
}
