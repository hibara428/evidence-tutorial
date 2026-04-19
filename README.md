# evidence-tutorial

BigQueryパブリックデータセットを使ったEvidence BIチュートリアルプロジェクト。

## セットアップ

**1. BigQuery認証**
```bash
gcloud auth application-default login
```

**2. 環境変数**

`.env` をプロジェクトルートに作成：
```env
EVIDENCE_SOURCE__bq_public__project=<your-gcp-project-id>
```

**3. 依存関係インストールとデータ取得**
```bash
npm install
npm run sources
npm run dev   # http://localhost:3000
```

## データソース

| ソース名 | テーブル |
|--------|--------|
| `bq_public` | `bigquery-public-data.chicago_taxi_trips.taxi_trips` |

## レポート

| ページ | 内容 |
|--------|------|
| `/chicago-taxi` | Chicago Taxi Trips 2023 — 月別トリップ数・運賃・支払い方法別分析 |
