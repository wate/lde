---
description: SQLファイルにおけるコーディング規約と品質基準
applyTo: '**/*.sql'
---
SQLファイル作成・編集指針
=========================

このインストラクションは、SQLファイルにおける統一されたコーディング規約と品質基準を定義します。

コーディング規約
-------------------------

以下のルールは必ず遵守してください。
違反が見つかった場合は即座に修正が必要です。

### 予約語の記述ルール

#### 予約語は大文字で記述

**【重要】SQL予約語は必ず大文字で記述する**

- すべてのSQL予約語(SELECT、FROM、WHERE、INSERT、UPDATE、DELETE等)は大文字で記述
- データ型(INT、VARCHAR、TEXT、DATETIME等)も大文字で記述
- 関数名(COUNT、SUM、MAX、NOW等)も大文字で記述

正しい例:
```sql
SELECT id, name, email
FROM users
WHERE status = 'active'
ORDER BY created_at DESC;
```

誤った例:
```sql
select id, name, email
from users
where status = 'active'
order by created_at desc;
```

### 命名規則

#### 基本原則

- プロジェクトまたはフレームワークの命名規則に従う
- 一貫性を保つ(同じプロジェクト内で命名スタイルを統一)
- 略語は避け、意味が明確な名前を使用
- SQL予約語と重複する名前は避ける

#### テーブル名

プロジェクトの命名規則に従う。
一般的な規則例: スネークケース(`users`)、キャメルケース(`Users`)、単数形/複数形等はフレームワークに準拠。

#### カラム名

プロジェクトの命名規則に従う。
一般的な規則例: スネークケース(`user_id`、`created_at`)、キャメルケース(`userId`、`createdAt`)等。

#### インデックス名・制約名

プロジェクトの命名規則に従う。
意味が明確で、対象テーブル・カラムが識別できる命名を使用。

### インデントとフォーマット

#### インデントルール

- インデントは4スペースを使用
- タブ文字は使用しない
- ネストしたクエリは適切にインデント

#### キーワードの配置

- 主要なキーワード(SELECT、FROM、WHERE、JOIN等)は行の先頭に配置
- カラムリストは適切に改行してインデント

例:
```sql
SELECT
    u.id,
    u.name,
    u.email,
    COUNT(p.id) AS post_count
FROM users AS u
LEFT JOIN blog_posts AS p
    ON u.id = p.user_id
WHERE u.status = 'active'
GROUP BY u.id, u.name, u.email
HAVING COUNT(p.id) > 0
ORDER BY post_count DESC
LIMIT 10;
```

#### カンマの配置

- カラムリストのカンマは各行の先頭に配置(trailing comma方式も許容)

先頭カンマ方式:
```sql
SELECT
    id
    , name
    , email
FROM users;
```

末尾カンマ方式:
```sql
SELECT
    id,
    name,
    email
FROM users;
```

### コメント記述

#### 行コメント

- `--`を使用して行コメントを記述
- `--`の後にスペースを1つ入れる

例:
```sql
-- ユーザー情報を取得
SELECT id, name FROM users;
```

#### ブロックコメント

- `/* */`を使用してブロックコメントを記述
- 複雑なクエリの説明や複数行の説明に使用

例:
```sql
/*
 * アクティブなユーザーの投稿数を集計
 * 投稿数が0のユーザーは除外
 */
SELECT u.id, COUNT(p.id) AS post_count
FROM users AS u
LEFT JOIN blog_posts AS p ON u.id = p.user_id
WHERE u.status = 'active'
GROUP BY u.id
HAVING COUNT(p.id) > 0;
```

### 日本語表記

- コメントは日本語で記述
- テーブル名、カラム名は英語を使用(日本語ローマ字表記は避ける)

スタイルガイド(推奨)
-------------------------

### クエリ構造

#### テーブルエイリアス

- テーブルエイリアスは意味のある短縮形を使用
- 単一文字のエイリアスは避ける(ただし、シンプルなクエリでは許容)

推奨:
```sql
SELECT u.name, p.title
FROM users AS u
JOIN blog_posts AS p ON u.id = p.user_id;
```

非推奨:
```sql
SELECT t1.name, t2.title
FROM users AS t1
JOIN blog_posts AS t2 ON t1.id = t2.user_id;
```

#### サブクエリ

- サブクエリは適切にインデントして可読性を確保
- 複雑なサブクエリはCTEの使用を検討

例:
```sql
WITH active_users AS (
    SELECT id, name
    FROM users
    WHERE status = 'active'
)
SELECT au.name, COUNT(p.id) AS post_count
FROM active_users AS au
LEFT JOIN blog_posts AS p ON au.id = p.user_id
GROUP BY au.id, au.name;
```

#### JOIN句

- JOIN条件は明示的にON句で記述
- カンマ結合ではなくJOIN構文を使用

推奨:
```sql
SELECT u.name, p.title
FROM users AS u
JOIN blog_posts AS p ON u.id = p.user_id;
```

非推奨:
```sql
SELECT u.name, p.title
FROM users AS u, blog_posts AS p
WHERE u.id = p.user_id;
```

### データ型の選択

- 適切なデータ型を選択(文字列長、数値範囲を考慮)
- VARCHAR長は必要最小限に設定
- TEXT型は大容量データのみに使用

### パフォーマンス考慮

- WHERE句に使用するカラムにはインデックスを検討
- SELECT * は避け、必要なカラムのみを指定
- 大量データの操作はLIMITを使用して段階的に実行

品質基準
-------------------------

### 基本品質

- SQL予約語の大文字表記100%準拠
- 命名規則の統一
- 適切なインデントとフォーマット
- コメントによる説明(複雑なクエリ)

### パフォーマンス

- インデックスの適切な使用
- N+1問題の回避
- 不要なカラム取得の回避

### 保守性

- 可読性の高いクエリ構造
- 意味のある命名
- 適切なコメント

禁止事項
-------------------------

### 記法・構文の禁止

- SQL予約語の小文字記述
- タブ文字の使用
- SELECT * の濫用
- カンマ結合(暗黙的JOIN)
- 日本語ローマ字表記の使用(例: `user_shimei`は避け`user_name`を使用)

### セキュリティの禁止

- 値の直接埋め込み(SQLインジェクション対策としてプレースホルダーを使用)
- パスワードの平文保存
- 機密情報のログ出力

### パフォーマンスの禁止

- 不要なサブクエリの多重ネスト
- インデックスが効かないLIKE検索(`LIKE '%keyword%'`)の濫用
- 大量データの一括更新・削除(トランザクションタイムアウトリスク)
