# 検査結果解析AI(n8n版)

[検査結果解析AI](https://github.com/m3yama/kensa-kekka-ai)(Dify版)と対になる、監視・通知を担当するn8nワークフロー。

Dify版が「撮影 → OCR → LLM転記 → DB保存」というデータの取り込みを担当するのに対し、
本ワークフローは**保存済みのデータを毎日自動で確認し、新しい検査結果があれば
所見コメントとレポートを生成して通知する**役割を担う。

## 処理の流れ

```
定時実行(毎日8時) / 手動実行
  → HTTP Request(/trend_n8n から最新の検査結果を取得)
  → 新着判定 → 新しい検査結果か
       ├─ No  → 新着なし(何もしない)
       └─ Yes → AIパラメータ生成 → Ollamaへ問い合わせ(AIノード)
                  → 生成OKか(NGなら試行上限までリトライ)
                  → 免責文判定 → 結果文書編集 → PDFレポート生成
                  → スプレッドシート更新
                  → 通知対象の絞り込み → Discordへ送信
                  → 通知済みを記録
```

## 役割分担

| 項目 | Dify版(kensa-kekka-ai) | n8n版(本リポジトリ) |
|---|---|---|
| 用途 | 対話型(検査票の取り込み) | 監視通知型(定時実行) |
| 入力 | 検査報告書の写真 | Dify版が保存したDB |
| 出力 | DB保存 | 所見コメント・PDFレポート・Discord通知・スプレッドシート更新 |

## 構成

ワークフローはn8nコンテナ内のSQLiteで管理しており、ソースコードとしては
`kensa-kekka-report.json`(エクスポートしたワークフロー定義)のみを本リポジトリで管理する。

n8nの画面から「Import from File」で読み込むことで復元できる。バックエンド(FastAPI、
`/trend_n8n`等)はDify版と共通のため、[kensa-kekka-ai](https://github.com/m3yama/kensa-kekka-ai)を参照。

## 使用技術

- n8n(ワークフロー自動化、Docker)
- Ollama(所見コメント生成)
- Google Sheets API(記録更新)
- Discord Webhook(通知)
