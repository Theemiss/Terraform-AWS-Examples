
output "s3_upload_bucket_name" {
  value = aws_s3_bucket_acl.s3_sqs_cloudwatch_bucket.id
}

output "s3_upload_sqs_queue_name" {
  value = aws_sqs_queue.s3_sqs_cloudwatch_queue.id
}
