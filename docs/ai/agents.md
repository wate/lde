カスタムエージェント一覧
=========================

このドキュメントは、`.github/agents/*.agent.md` で定義された29件のカスタムエージェントを技術領域別に整理した一覧です。エージェントとは、特定の専門領域に特化したAIの役割定義であり、プロジェクトのフェーズや課題に応じて適切なエージェントを選ぶことで、作業の品質と効率を高められます。関連資料は[スキル一覧](skills.md)と[カスタムプロンプト一覧](prompts.md)を参照してください。

技術領域別エージェント一覧
--------------------------

### 技術開発系

| エージェント名      | 専門領域              | 主な用途                                                                            |
| ------------------- | --------------------- | ----------------------------------------------------------------------------------- |
| `phper`             | PHPフレームワーク開発 | CakePHP/Laravel/Symfonyによるアプリケーション設計・実装、PSR準拠と静的解析          |
| `jser`              | MPA向けJavaScript     | jQuery/HTMX/Vanilla JS実装とレガシーJavaScriptコードの保守・リファクタリング        |
| `pythonista`        | Pythonアプリ開発      | Django/Flask/FastAPIによるWebアプリケーション、データ分析、機械学習システム開発     |
| `rubyist`           | Rubyアプリ開発        | Ruby on Rails/Sinatra/HanamiによるWebアプリケーション開発、TDD                      |
| `gopher`            | Go開発                | 高性能なマイクロサービス・CLI・インフラツール開発、並行処理設計と標準ライブラリ活用 |
| `database-engineer` | DB設計と最適化        | スキーマ設計、クエリ最適化、データモデリング、高可用性設計                          |
| `test-engineer`     | テスト実装            | テスト設計・自動化・実行、テストケース作成からCI統合まで                            |
| `prompt-engineer`   | プロンプト設計        | AI向けプロンプト設計とテンプレート構築、Chain-of-Thought・Few-shot等の高度技法      |

### インフラ・運用系

| エージェント名         | 専門領域           | 主な用途                                                                         |
| ---------------------- | ------------------ | -------------------------------------------------------------------------------- |
| `cloud-engineer`       | クラウド設計       | AWS/Azure/GCPによるクラウドインフラ設計・構築・コスト最適化                      |
| `devops-engineer`      | DevOpsとCI/CD      | CI/CDパイプライン構築、ビルド・テスト・デプロイの継続的改善と運用自動化          |
| `ansible-specialist`   | Ansible構成管理    | プレイブック設計、ロール構成、べき等性確保によるプロビジョニング自動化           |
| `terraform-specialist` | Terraform IaC      | 宣言的リソース定義、状態管理、モジュール設計                                     |
| `server-engineer`      | Linux/UNIX運用     | サーバー構築・運用・自動化、シェルスクリプトとAnsibleによる安定運用              |
| `system-engineer`      | 全体アーキテクチャ | 分散システム・高可用性設計、非機能要件と運用設計の統合                           |
| `sre-engineer`         | 信頼性向上         | SLI/SLO管理、可観測性基盤構築、インシデント対応、エラーバジェット運用            |
| `security-engineer`    | セキュリティ対策   | アプリケーションとインフラの包括的セキュリティ分析、脅威モデリングと多層防御設計 |

### 分析・設計系

| エージェント名       | 専門領域           | 主な用途                                                                                         |
| -------------------- | ------------------ | ------------------------------------------------------------------------------------------------ |
| `business-analyst`   | 業務分析           | 業務プロセスの分析・改善とビジネス要件導出、現場の課題・業務フローからのシステム化判断           |
| `system-analyst`     | システム要件定義   | ビジネス要求から実装可能なシステム仕様への変換、要件定義・技術仕様策定・実現可能性評価           |
| `product-researcher` | 市場・ユーザー調査 | 市場調査とユーザー調査によるデータ駆動型プロダクト企画・改善、ビジネス価値の検証                 |
| `project-manager`    | プロジェクト管理   | アジャイル・ウォーターフォール双方のプロジェクト管理、リスク管理とステークホルダー調整           |
| `web-director`       | Web進行管理        | Webプロジェクトの進行管理・クライアント対応・品質管理、チーム調整と進捗管理                      |
| `qa-engineer`        | 品質戦略           | 品質管理プロセスの設計と品質基準の策定、テスト戦略立案と品質メトリクスによるプロセス改善         |
| `technical-writer`   | 技術文書           | 技術文書・ユーザーガイド・API仕様書の構造化された制作、情報アーキテクチャと段階的開示            |
| `orchestrator`       | エージェント統制   | 開発フロー全体の統制と専門エージェントへの適切な委譲、タスクの性質に応じた最適なエージェント選択 |

### デザイン・UX系

| エージェント名     | 専門領域     | 主な用途                                                                                                  |
| ------------------ | ------------ | --------------------------------------------------------------------------------------------------------- |
| `ui-designer`      | UI設計       | UIコンポーネント設計・デザインシステム構築・インタラクション設計、実装可能なUI仕様の提供                  |
| `ux-researcher`    | UX調査       | ユーザーインタビュー・ユーザビリティテスト・行動観察によるユーザーニーズ発見、定性調査とインサイト導出    |
| `web-designer`     | Webデザイン  | Webサイト全体のビジュアルデザインと情報設計、ブランディングとユーザビリティを両立したページレイアウト設計 |
| `graphic-designer` | 図解表現     | テキスト情報や複雑な概念のコンセプト図・インフォグラフィックとしての視覚化、SVG形式での情報構造化         |
| `illustrator`      | イラスト制作 | デジタルイラスト制作とWeb・印刷向け多媒体出力最適化、芸術的・商業的なビジュアル作品の制作                 |

使い分けの指針
-------------------------

### プロジェクトフェーズ別活用

#### 企画・設計段階

- 課題整理: `business-analyst`が業務課題を整理し、`product-researcher`と`ux-researcher`が市場性と利用者像を検証します。
- 要件確定: `system-analyst`が要件を実装可能な仕様へ変換し、`project-manager`と`web-director`が制約と進行条件を定義します。
- 記録整備: `technical-writer`が要件や判断根拠を記録し、トレーサビリティを確保します。

#### 設計・開発段階

- 全体設計: `system-engineer`が全体アーキテクチャと非機能要件を設計します。
- 画面設計: `ui-designer`と`web-designer`が画面設計とデザインシステムを具体化します。
- 実装: `phper`、`jser`、`pythonista`、`rubyist`、`gopher`は採用技術に応じて実装を担当します。
- 並行走査: `database-engineer`と`security-engineer`は設計段階から並行参加させると手戻りを抑えられます。

#### 実装・テスト段階

- テスト設計: `test-engineer`がテスト設計と自動化を進めます。
- 品質管理: `qa-engineer`が品質ゲートと確認観点を定義します。
- CI/CD: `devops-engineer`がビルド・検証・デプロイの自動化パイプラインを整備します。
- 統制: `orchestrator`は複数エージェントの分担が増える場面でタスク振り分けと進捗管理に有効です。

#### 運用・保守段階

- 基盤維持: `server-engineer`、`cloud-engineer`、`terraform-specialist`、`ansible-specialist`がインフラ基盤を維持します。
- 監視改善: `sre-engineer`が監視・通知・SLI/SLO・障害対応を継続改善します。
- セキュリティ: `security-engineer`は運用時の脆弱性管理と防御設計を継続します。

### 技術領域別選択指針

#### Webアプリケーション開発

中核は`phper`(または使用言語に応じて`pythonista`、`rubyist`、`gopher`)、`jser`、`ui-designer`、`database-engineer`です。企画寄りの初期段階では`business-analyst`、`ux-researcher`、`product-researcher`を加え、リリース前後では`test-engineer`、`qa-engineer`、`devops-engineer`、`sre-engineer`を優先します。

#### エンタープライズシステム

`system-analyst`、`system-engineer`、`database-engineer`を中心に構成します。`project-manager`、`qa-engineer`、`technical-writer`を加えると統制と文書整備が安定します。`security-engineer`は早い段階で参加させる前提で進めます。

#### スタートアップ・新規事業

`product-researcher`、`ux-researcher`、`web-designer`で仮説検証を高速に回し、実装は`jser`、`phper`、`pythonista`など採用技術に合わせて最小構成に絞ります。`devops-engineer`は早期デリバリー基盤の整備に向きます。

#### サーバー構築・運用保守

`server-engineer`、`ansible-specialist`、`terraform-specialist`が構築の主担当です。`cloud-engineer`、`system-engineer`は設計の整合性を担保し、`sre-engineer`、`security-engineer`は運用品質と安全性の維持を担当します。

実践的活用例
-------------------------

### 例1: Webアプリケーション新規開発

#### 企画・調査

- `business-analyst`が業務上の課題と現状フローを整理します。
- `product-researcher`と`ux-researcher`が市場性・競合状況・利用者像を検証します。
- `project-manager`がスコープ・スケジュール・リソースの制約条件を定義します。

#### 設計・仕様策定

- `system-analyst`が要件定義書に基づき画面仕様とデータ要件を具体化します。
- `ui-designer`と`web-designer`が画面設計とプロトタイプをまとめます。
- `database-engineer`がエンティティ設計とインデックス戦略を、`security-engineer`が認証・認可設計をそれぞれ策定します。
- `technical-writer`が設計判断とトレードオフの記録を整備します。

#### 開発・実装

- `phper`(または`pythonista`/`rubyist`/`gopher`)がバックエンドのAPIとビジネスロジックを実装します。
- `jser`がフロントエンドの画面制御とサーバーとのデータ連携を実装します。
- `devops-engineer`がCI/CDパイプラインとステージング環境を整備します。

#### テスト・品質保証

- `test-engineer`が単体テスト・結合テストの設計と自動化を進めます。
- `qa-engineer`が品質基準と受け入れ条件を定義し、テスト結果の評価を実施します。
- `technical-writer`が運用手順書とエンドユーザー向けマニュアルを整備します。

#### デプロイ・運用

- `cloud-engineer`と`terraform-specialist`が本番環境のインフラ基盤をコードで管理します。
- `sre-engineer`が監視ダッシュボードとアラートルールを設定し、リリース後の安定運用を確保します。

### 例2: レガシーシステム改善

#### 現状分析・課題抽出

- `business-analyst`が現行業務上の痛点と改善要望を整理します。
- `system-analyst`が現行システムの構成・依存関係・制約を可視化します。
- `jser`や`phper`が既存コードの品質・技術負債・改善余地をコードレベルで評価します。

#### 改善戦略策定

- `project-manager`が段階的移行のロードマップとリスク対応計画を立てます。
- `qa-engineer`が品質基準とリグレッション判定基準を定めます。
- `database-engineer`がスキーマ移行計画を、`security-engineer`が脆弱性対応の優先順位をそれぞれ策定します。

#### 段階的実装

- `phper`、`jser`、`test-engineer`で改善範囲の改修と回帰確認を反復します。
- `devops-engineer`がテスト自動化とデプロイパイプラインを整備し、リリースサイクルを短縮します。
- `technical-writer`が旧仕様と新仕様の差分を文書化し、ナレッジの散逸を防ぎます。

### 例3: サーバー構築・インフラ整備

#### 要件定義・設計

- `system-engineer`がシステム全体構成と非機能要件(性能・可用性・拡張性)を設計します。
- `cloud-engineer`または`server-engineer`が配置するクラウド/オンプレの選定と配置方針を具体化します。
- `security-engineer`がネットワーク分離・アクセス制御・暗号化の方針を定義します。

#### サーバー構築・設定

- `terraform-specialist`がIaCでサーバーリソースをコード化します。
- `ansible-specialist`がミドルウェアの構成管理と冪等性を確保したプレイブックを作成します。
- `server-engineer`がOSパラメータ調整・ミドルウェア設定・運用手順を固めます。

#### 運用体制構築

- `sre-engineer`が監視基盤・通知ルール・SLO目標値とエラーバジェットポリシーを設計します。
- `devops-engineer`がデプロイやパッチ適用の自動化を継続的に改善します。
- `technical-writer`が運用手順書・障害対応手順・バックアップリストア手順を整備します。

効率化のポイント
-------------------------

### エージェント連携による相乗効果

- 設計フェーズ: `business-analyst` → `system-analyst` → `system-engineer` を直列で使うと、要件からアーキテクチャまで判断がぶれません。
- 画面開発: `ux-researcher`(調査)→ `ui-designer`(設計)→ `jser`(実装)の流れで調査から実装までカバーできます。
- 品質保証: `test-engineer`(テスト設計)・`qa-engineer`(品質基準)・`security-engineer`(セキュリティ検証)の併用で多角的な品質保証が可能です。
- インフラ構築: `terraform-specialist`(コード化)→ `ansible-specialist`(構成管理)→ `server-engineer`(運用)→ `sre-engineer`(監視)の直列連携が効果的です。

### プロジェクト規模別の推奨組み合わせ

#### 小規模プロジェクト(3ヵ月以内、2-3人月)

`product-researcher`、`ui-designer`、`jser`、`phper`、`devops-engineer`の組み合わせが軽量です。実装寄りのエージェントに絞り、分析系はチャットベースの简易利用に留めます。

#### 中規模プロジェクト(6ヵ月程度、5-10人月)

小規模の構成に`business-analyst`、`system-analyst`、`database-engineer`、`test-engineer`、`qa-engineer`を加えます。上流工程の品質を確保し、テストの自動化まで対応します。

#### 大規模プロジェクト(1年以上、10人月超)

中規模の構成に`project-manager`、`web-director`、`orchestrator`を加えて分担と意思決定を明確化します。`technical-writer`を早い段階から参加させ、文書資産を整備します。

### 技術特化プロジェクトでの組み合わせ

#### サーバー構築・運用

`server-engineer`、`terraform-specialist`、`ansible-specialist`、`sre-engineer`の4名が中核です。`cloud-engineer`や`security-engineer`を必要に応じて追加します。

#### データ分析基盤

`database-engineer`、`pythonista`、`system-engineer`、`devops-engineer`の連携が有効です。`product-researcher`を加えると分析要件の具体化がスムーズになります。

#### セキュアシステム

`security-engineer`、`qa-engineer`、`test-engineer`、`technical-writer`を早期から併走させます。`system-engineer`と`database-engineer`の設計段階からの参加も推奨します。

まとめ
-------------------------

カスタムエージェントは、専門領域で分類して把握すると選定しやすく、プロジェクトのフェーズに沿って配置すると連携しやすくなります。Web開発・レガシー改善・サーバー構築のいずれの案件でも、分析・設計・実装・品質・運用の役割を分担し、必要最小限の構成から始めてフェーズの進行に応じてエージェントを追加するアプローチが効果的です。まずは主担当を1つ決め、周辺領域のエージェントを追加する形で運用を始めてみてください。
