resource "aws_sqs_queue" "fnf-solicitar-pagamento-req" {
    name = "solicitar-pagamento-req.fifo"
    fifo_queue = true
    content_based_deduplication = true
    visibility_timeout_seconds = 10
    delay_seconds = 10
    redrive_policy = jsonencode({
        deadLetterTargetArn: aws_sqs_queue.fnf-sqs-dlq-fifo.arn
        maxReceiveCount: 3
    })
}

resource "aws_sqs_queue" "fnf-preparacao-pedido-req" {
    name = "preparacao-pedido-req.fifo"
    fifo_queue = true
    content_based_deduplication = true
    visibility_timeout_seconds = 10
    delay_seconds = 10
    redrive_policy = jsonencode({
        deadLetterTargetArn: aws_sqs_queue.fnf-sqs-dlq-fifo.arn
        maxReceiveCount: 3
    })
}

resource "aws_sqs_queue" "fnf-webhook-pagamento-rejeitado-res" {
    name = "webhook-pagamento-rejeitado-res"
    visibility_timeout_seconds = 10
    delay_seconds = 10
    redrive_policy = jsonencode({
        deadLetterTargetArn=aws_sqs_queue.fnf-sqs-dlq.arn
        maxReceiveCount=3
    })
}

resource "aws_sqs_queue" "fnf-webhook-pagamento-confirmado-res" {
    name = "webhook-pagamento-confirmado-res"
    visibility_timeout_seconds = 10
    delay_seconds = 10
    redrive_policy = jsonencode({
        deadLetterTargetArn: aws_sqs_queue.fnf-sqs-dlq.arn
        maxReceiveCount: 3
    })
}

resource "aws_sqs_queue" "fnf-sqs-dlq-fifo" {
    name = "sqs-dlq.fifo"
    fifo_queue = true
}

resource "aws_sqs_queue" "fnf-sqs-dlq" {
    name = "sqs-dlq"
}

resource "aws_sqs_queue_redrive_allow_policy" "fnf-solicitar-pagamento-redrive-allow-policy" {
  queue_url = aws_sqs_queue.fnf-sqs-dlq.id
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [
        aws_sqs_queue.fnf-webhook-pagamento-rejeitado-res.arn,
        aws_sqs_queue.fnf-webhook-pagamento-confirmado-res.arn
    ]
  })
}

resource "aws_sqs_queue_redrive_allow_policy" "fnf-solicitar-pagamento-redrive-allow-policy-fifo" {
  queue_url = aws_sqs_queue.fnf-sqs-dlq-fifo.id
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [
        aws_sqs_queue.fnf-solicitar-pagamento-req.arn,
        aws_sqs_queue.fnf-preparacao-pedido-req.arn
    ]
  })
}