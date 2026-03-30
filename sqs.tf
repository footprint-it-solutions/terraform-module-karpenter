resource "aws_sqs_queue" "karpenter" {
  name                      = var.cluster_name
  message_retention_seconds = 300
  sqs_managed_sse_enabled   = true
}

resource "aws_sqs_queue_policy" "karpenter" {
  queue_url = aws_sqs_queue.karpenter.id

  policy = data.aws_iam_policy_document.sqs_policy.json
}

data "aws_iam_policy_document" "sqs_policy" {
  statement {
    sid    = "EC2InterruptionPolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.karpenter.arn]
  }
}

resource "aws_cloudwatch_event_rule" "rules" {
  for_each = {
    scheduled_change = {
      description   = "Karpenter interrupt - AWS Health Event"
      event_pattern = { source = ["aws.health"], detail-type = ["AWS Health Event"] }
    }
    spot_interruption = {
      description   = "Karpenter interrupt - EC2 Spot Instance Interruption Warning"
      event_pattern = { source = ["aws.ec2"], detail-type = ["EC2 Spot Instance Interruption Warning"] }
    }
    rebalance_recommendation = {
      description   = "Karpenter interrupt - EC2 Instance Rebalance Recommendation"
      event_pattern = { source = ["aws.ec2"], detail-type = ["EC2 Instance Rebalance Recommendation"] }
    }
    instance_state_change = {
      description   = "Karpenter interrupt - EC2 Instance State-change Notification"
      event_pattern = { source = ["aws.ec2"], detail-type = ["EC2 Instance State-change Notification"] }
    }
  }

  name          = "${var.cluster_name}-${each.key}"
  description   = each.value.description
  event_pattern = jsonencode(each.value.event_pattern)
}

resource "aws_cloudwatch_event_target" "targets" {
  for_each = aws_cloudwatch_event_rule.rules

  rule      = each.value.name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = aws_sqs_queue.karpenter.arn
}
