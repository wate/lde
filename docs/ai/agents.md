<!-- 生成元: .github/prompts/doc-ai-agent.prompt.md -->

エージェント一覧
=========================

概要
-------------------------

このドキュメントは、.github/agents配下の29件のエージェント定義を対象に、
専門領域と活用場面を整理した一覧です。
用途に応じた選定をしやすくするため、技術領域別の一覧、使い分け、実践例をまとめています。
関連資料は[スキル一覧](skills.md)と[カスタムプロンプト一覧](prompts.md)を参照してください。

技術領域別エージェント一覧
-------------------------

### 技術開発系

| エージェント名      | 専門領域              | 主な用途                                 |
| ------------------- | --------------------- | ---------------------------------------- |
| phper               | PHPフレームワーク開発 | CakePHP/Laravel/Symfony実装と静的解析    |
| jser                | MPA向けJavaScript     | jQuery/HTMX/Vanilla JS実装とレガシー改善 |
| Pythonista          | Pythonアプリ開発      | Django/FastAPI開発とデータ処理           |
| Rubyist             | Rubyアプリ開発        | Rails系実装とTDD                         |
| gopher              | Go開発                | 高性能API・CLI・並行処理設計             |
| database-engineer   | DB設計と最適化        | スキーマ設計、クエリ改善、高可用性設計   |
| test-engineer       | テスト実装            | テスト設計、自動化、CI統合               |
| prompt-engineer     | プロンプト設計        | 指示テンプレート設計と出力品質改善       |

### インフラ・運用系

| エージェント名       | 専門領域           | 主な用途                        |
| -------------------- | ------------------ | ------------------------------- |
| cloud-engineer       | クラウド設計       | AWS/Azure/GCP設計とコスト最適化 |
| devops-engineer      | DevOpsとCI/CD      | パイプライン構築と運用自動化    |
| Ansible-specialist   | Ansible構成管理    | プレイブック設計とべき等性確保  |
| Terraform-specialist | Terraform IaC      | 宣言的リソース定義と状態管理    |
| server-engineer      | Linux/UNIX運用     | サーバー構築、運用、自動化      |
| system-engineer      | 全体アーキテクチャ | 非機能要件と運用設計の統合      |
| sre-engineer         | 信頼性向上         | 可観測性、SLI/SLO、障害対応     |
| security-engineer    | セキュリティ対策   | 脅威分析、多層防御、脆弱性対応  |

### 分析・設計系

| エージェント名     | 専門領域           | 主な用途                          |
| ------------------ | ------------------ | --------------------------------- |
| business-analyst   | 業務分析           | 業務課題の整理と要件導出          |
| system-analyst     | システム要件定義   | 業務要求を実装可能な仕様へ変換    |
| product-researcher | 市場・ユーザー調査 | 仮説検証とプロダクト企画          |
| project-manager    | プロジェクト管理   | 計画、リスク管理、関係者調整      |
| web-director       | Web進行管理        | クライアント調整と品質管理        |
| qa-engineer        | 品質戦略           | 品質基準、品質プロセス、改善設計  |
| technical-writer   | 技術文書           | API仕様、開発ガイド、利用手順整備 |
| orchestrator       | エージェント統制   | 適切な委譲と開発フロー制御        |

### デザイン・UX系

| エージェント名   | 専門領域     | 主な用途                                 |
| ---------------- | ------------ | ---------------------------------------- |
| ui-designer      | UI設計       | コンポーネント設計とデザインシステム構築 |
| ux-researcher    | UX調査       | インタビュー、テスト、行動観察           |
| web-designer     | Webデザイン  | 情報設計とビジュアル設計                 |
| graphic-designer | 図解表現     | コンセプト図、SVG、インフォグラフィック  |
| illustrator      | イラスト制作 | デジタルイラストと多媒体出力最適化       |

### 情報不足の記録

調査時点でメタデータの一部が不足していた項目は以下の通りです。

| エージェント名   | 情報不足の内容       |
| ---------------- | -------------------- |
| business-analyst | 具体的なツール・手法 |
| system-analyst   | ツール情報           |
| qa-engineer      | 具体的なツール情報   |
| test-engineer    | 自動化ツールの詳細   |
| web-designer     | デザインツールの詳細 |
| orchestrator     | 具体的なツール情報   |

使い分けの指針
-------------------------

### プロジェクトフェーズ別活用

#### 企画・設計段階

- business-analyst、product-researcher、ux-researcherで課題と需要を整理します。
- system-analyst、project-manager、web-directorで要件、制約、進行条件を固めます。
- technical-writerは要件や判断根拠の記録を整備します。

#### 設計・開発段階

- system-engineerが全体構成と非機能要件を設計します。
- ui-designer、web-designerが画面設計を具体化します。
- phper、jser、Pythonista、Rubyist、gopherは採用技術に応じて実装を担当します。
- database-engineer、security-engineerは設計段階から並行参加させると手戻りを抑えられます。

#### 実装・テスト段階

- test-engineerがテスト設計と自動化を進めます。
- qa-engineerが品質ゲートと確認観点を定義します。
- devops-engineerがビルド、検証、自動化を支えます。
- orchestratorは複数エージェントの分担が増える場面で有効です。

#### 運用・保守段階

- server-engineer、cloud-engineer、Terraform-specialist、Ansible-specialistが基盤を維持します。
- sre-engineerが監視、SLI/SLO、障害対応を継続改善します。
- security-engineerは運用時の脆弱性管理と防御設計を継続します。

### 技術領域別選択指針

#### Webアプリケーション開発

- 中核はphper、jser、ui-designer、database-engineerです。
- 企画寄りの初期段階ではbusiness-analyst、ux-researcher、product-researcherを加えます。
- リリース前後ではtest-engineer、qa-engineer、devops-engineer、sre-engineerを優先します。

#### エンタープライズシステム

- system-analyst、system-engineer、database-engineerを中心に構成します。
- project-manager、qa-engineer、technical-writerを加えると統制と文書整備が安定します。
- security-engineerは早い段階で参加させる前提で進めます。

#### スタートアップ・新規事業

- product-researcher、ux-researcher、web-designerで仮説検証を高速に回します。
- 実装はjser、phper、Pythonistaなど採用技術に合わせて最小構成に絞ります。
- devops-engineerは早期デリバリー基盤の整備に向きます。

#### サーバー構築・運用保守

- server-engineer、Ansible-specialist、Terraform-specialistが構築の主担当です。
- cloud-engineer、system-engineerは設計の整合性を担保します。
- sre-engineer、security-engineerは運用品質と安全性の維持を担当します。

実践的活用例
-------------------------

### 例1 Webアプリケーション新規開発

#### 企画・調査

- business-analystが業務課題を整理します。
- product-researcherとux-researcherが市場性と利用者像を検証します。
- project-managerが進行条件を定義します。

#### 設計・仕様策定

- system-analystが要件を仕様へ落とし込みます。
- ui-designerとweb-designerが画面設計をまとめます。
- database-engineerとsecurity-engineerが基盤要件を詰めます。

#### 開発・実装

- phperがバックエンドを実装します。
- jserが画面側の挙動を実装します。
- devops-engineerがCI/CDを整備します。

#### テスト・品質保証

- test-engineerが回帰テストと自動化を進めます。
- qa-engineerが品質観点を管理します。
- technical-writerが運用手順と利用資料を整備します。

#### デプロイ・運用

- cloud-engineerとTerraform-specialistが本番基盤を整えます。
- sre-engineerが監視と運用改善を担います。

### 例2 レガシーシステム改善

#### 現状分析・課題抽出

- business-analystが業務上の痛点を整理します。
- system-analystが現行構成と制約を可視化します。
- jserやphperが既存コードの改善余地を見極めます。

#### 改善戦略策定

- project-managerが段階移行の計画を立てます。
- qa-engineerが品質基準と移行判定基準を定めます。
- database-engineerとsecurity-engineerが高リスク箇所を洗い出します。

#### 段階的実装

- phper、jser、test-engineerで改修と回帰確認を反復します。
- devops-engineerが検証や移行の自動化を進めます。
- technical-writerが旧仕様と新仕様の差分を文書化します。

### 例3 サーバー構築・インフラ整備

#### 要件定義・設計

- system-engineerが全体構成を設計します。
- cloud-engineerまたはserver-engineerが配置方針を具体化します。
- security-engineerが防御要件を定義します。

#### サーバー構築・設定

- Terraform-specialistがIaCを実装します。
- Ansible-specialistが構成管理を整えます。
- server-engineerがOS、ミドルウェア、運用手順を固めます。

#### 運用体制構築

- sre-engineerが監視、通知、SLO運用を設計します。
- devops-engineerがデプロイや保守の自動化を継続します。
- technical-writerが運用手順書を整備します。

効率化のポイント
-------------------------

### エージェント連携による相乗効果

- 設計フェーズではbusiness-analyst、system-analyst、system-engineerを直列で使うと判断がぶれません。
- 画面系ではux-researcher、ui-designer、jserを組み合わせると調査から実装まで流れます。
- 品質面ではtest-engineer、qa-engineer、security-engineerの併用が有効です。

### プロジェクト規模別の推奨組み合わせ

#### 小規模プロジェクト

- product-researcher、ui-designer、jser、phper、devops-engineerの組み合わせが軽量です。

#### 中規模プロジェクト

- business-analyst、system-analyst、database-engineer、test-engineer、qa-engineerを加えます。

#### 大規模プロジェクト

- project-manager、web-director、orchestratorを入れて分担と意思決定を明確にします。

### 技術特化プロジェクトでの組み合わせ

#### サーバー構築・運用

- server-engineer、Terraform-specialist、Ansible-specialist、sre-engineerの組み合わせが中核です。

#### データ分析基盤

- database-engineer、Pythonista、system-engineer、devops-engineerの連携が有効です。

#### セキュアシステム

- security-engineer、qa-engineer、test-engineer、technical-writerを早期から併走させます。

まとめ
-------------------------

エージェントは、専門領域で分けて見ると選定しやすく、プロジェクトの段階で並べると連携しやすくなります。
Web開発、レガシー改善、サーバー構築のいずれでも、分析、実装、品質、運用の役割を分けて組み合わせることが重要です。
まずは主担当を1人決め、周辺領域のエージェントを必要最小限で追加すると運用しやすくなります。
