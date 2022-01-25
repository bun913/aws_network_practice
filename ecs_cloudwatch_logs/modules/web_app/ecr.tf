# app repository
resource "aws_ecr_repository" "app" {
  name                 = "app_color"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

locals {
  firelens_repo_name = "color-firelens"
  firelens_tag       = "v1"
}

# Firelensカスタムイメージ
resource "aws_ecr_repository" "firelens" {
  name                 = local.firelens_repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# NOTE: アプリ側のリポジトリにimageをpushするためのスクリプトが用意されている
resource "null_resource" "app" {
  triggers = {
    ecr_repo = aws_ecr_repository.app.name
  }

  provisioner "local-exec" {
    # FIXME: アプリ側のリポジトリのファイルを指定しているため不恰好
    # 二重管理よりはマシだと思うがもっとスマートな方法はないか・・・
    command = "cd ${path.root}/../../webapp-color && sh push_image.sh"

    // スクリプト専用の環境変数
    environment = {
      AWS_REGION     = var.region
      REPO_URI       = aws_ecr_repository.app.repository_url
      TAG            = "v1"
      CONTAINER_NAME = "color"
    }
  }
}

# terraform apply時にFluent Bitのコンテナイメージプッシュ
resource "null_resource" "fluentbit" {
  triggers = {
    ecr_repo_create = aws_ecr_repository.firelens.arn
  }
  ## 認証トークンを取得し、レジストリに対して Docker クライアントを認証
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.firelens.repository_url}"
  }

  ## Dockerイメージ作成
  provisioner "local-exec" {
    working_dir = "${path.module}/fluentbit"
    command     = "docker build --platform linux/amd64 -f Dockerfile -t ${local.firelens_repo_name}:${local.firelens_tag} ."
  }

  ## ECRリポジトリにイメージをプッシュできるように、イメージにタグ付け
  provisioner "local-exec" {
    command = "docker tag ${local.firelens_repo_name}:${local.firelens_tag} ${aws_ecr_repository.firelens.repository_url}:${local.firelens_tag}"
  }

  ## ECRリポジトリにイメージをプッシュ
  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.firelens.repository_url}:${local.firelens_tag}"
  }
}
