# app repository
resource "aws_ecr_repository" "app" {
  name                 = "app_color"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# NOTE: アプリ側のリポジトリにimageをpushするためのスクリプトが用意されている
resource "null_resource" "frontend" {
  triggers = {
    ecr_repo = aws_ecr_repository.app.name
  }

  provisioner "local-exec" {
    # FIXME: アプリ側のリポジトリのファイルを指定しているため不恰好
    # 二重管理よりはマシだと思うがもっとスマートな方法はないか・・・
    command = "sh ${path.root}/../../webapp-color/push_image.sh"

    // スクリプト専用の環境変数
    environment = {
      AWS_REGION     = var.region
      REPO_URI       = aws_ecr_repository.app.repository_url
      TAG            = "v1"
      CONTAINER_NAME = "color"
    }
  }
}
