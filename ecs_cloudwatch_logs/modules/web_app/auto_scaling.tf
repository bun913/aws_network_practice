resource "aws_appautoscaling_target" "app" {
  # NOTE:本番運用では許容できる最大数をあげる
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.app.name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "app" {
  name = "scale-up"
  # CPU使用率をターゲットにしてターゲット追跡ポリシーで構築
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.app.resource_id
  scalable_dimension = aws_appautoscaling_target.app.scalable_dimension
  service_namespace  = aws_appautoscaling_target.app.service_namespace

  target_tracking_scaling_policy_configuration {

    # CPU使用率50%を基準にする
    target_value       = 50
    disable_scale_in   = false
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
    # ターゲットにするメトリクス
    predefined_metric_specification {
      # https://docs.aws.amazon.com/ja_jp/autoscaling/application/APIReference/API_PredefinedMetricSpecification.html
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
