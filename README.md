# AWS気になることあれこれ

自分がたまに分からなくなること・誰かがハマりそうなポイントなどをハンズオンで学習する。

また、可能な限りハンズオンの後はTerraformでリソースを作る。

- [VPC内の異なるサブネット間の通信](./private_subnet_connection/doc.md)
- [CloudFrontとS3とACMでHTTPS通信](./cloudfront_s3_acm/doc.md)
    - こだわりポイント
        - 独自ドメインを取得してCloudFrontに適用
        - SSL通信を可能にする
        - かつCloudFront経由でしかS3のオブジェクトを取得できないように設定
- [TerraformでRDSを起動。セキュアにパスワードも管理する](./aurora/doc.md)
    - zenn.devで記事公開
      - https://zenn.dev/bun913/articles/92033f05ed7907
    - こだわりポイント
      - Terraformでパスワードをセキュアに扱う
        - *.tfファイルには一旦登録するダミーパスワードが残る
        - local_execを利用してtfstateにも本当のパスワード情報を残さない
      - DB接続用EC2インスタンスはセッションマネージャーで接続し、プライベートサブネットに配置する
- [シンプルアプリをFARGATEで起動。CodePipelineでデプロイを継続的にデリバリー](./simple_ecs_app/README.md)
    - こだわりポイント
      - TerraformでECSをFARGATE実行環境で作成
      - CodePipelineでブルーグリーンデプロイを実現