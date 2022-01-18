# ECSによるアプリデプロイ練習

## 事前設定

- ECRのレポジトリ作成は手動で行う
- ECRへのイメージプッシュは手動で行う
  - 通常はアプリ側の変更があったタイミングでCI/CIDにより最新イメージがプッシュされる想定
  - ↑の設定は別途CodeSeriesの学習で行う
- Githubに接続するためのCodeStarコネクション(Github version2)を作成しておく
  - https://tech.012grp.co.jp/entry/2021/02/15/192252#:~:text=DeploymentGroupName%20%3D%20var.codedeploy_deploy_group_name%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D-,aws_codestarconnections_connection%E3%83%AA%E3%82%BD%E3%83%BC%E3%82%B9%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6,-Terraform%E3%81%A7%E4%BF%9D%E7%95%99