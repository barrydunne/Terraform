resource "aws_lambda_event_source_mapping" "source" {
  event_source_arn                   = var.queue_arn
  function_name                      = var.function_name
  batch_size                         = var.batch_size
  maximum_batching_window_in_seconds = var.maximum_batching_window_in_seconds
  function_response_types            = var.report_batch_item_failures ? ["ReportBatchItemFailures"] : []
}