# AWS ネットワークあれこれ

自分がたまに分からなくなること・誰かがハマりそうなポイントなどをハンズオンで学習する。

また、可能な限りハンズオンの後はTerraformでリソースを作る。

- [VPC内の異なるサブネット間の通信](./private_subnet_connection/doc.md)
- [CloudFrontとS3とACMでHTTPS通信](./cloudfront_s3_acm/doc.md)
    - 独自ドメインを取得してCloudFrontに適用
    - SSL通信を可能にする
    - かつCloudFront経由でしかS3のオブジェクトを取得できないように設定