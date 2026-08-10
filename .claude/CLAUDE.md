# textmining2 プロジェクト

## 概要

日本語テキストマイニングの図化を支援する Shiny アプリ．
形態素解析(Web茶まめ)からバイグラムの作図までを，ブラウザ上の操作だけで実行できる．

- 公開先: <https://matutosi.shinyapps.io/textmining2>
- リポジトリ: <https://github.com/matutosi/textmining> (ブランチ: main)
- 引用: 松村 俊和 (2022) RとShinyを使ったテキストマイニングの図化ツール．

主要な処理は自作パッケージ [moranajp](https://github.com/matutosi/moranajp) に依存する
(`global.R` で develop ブランチを `remotes::install_github()` する)．

## ディレクトリ構成

```
R/            Shiny アプリ本体(shiny::runApp("R") で起動)
  global.R      パッケージ導入・source・OS 判定・フォント選択
  ui.R          navbarPage: 7タブ(Upload text / Chamame / Combine words /
                Stop words / Synonym / Cleanup / Bigram)
  server.R      各モジュールの結線
  upload_file.R   ファイルアップロード + 表表示のモジュール
  download_data.R ダウンロードボタンのモジュール
  example_data.R  サンプルデータ(text / combine / stop_words / synonym)
  chamame.R       Web茶まめ(https://chamame.ninjal.ac.jp/)で形態素解析
  cleanup.R       結合語・stop word・synonym を適用して整形
  bigram.R        バイグラムの算出と ggplot2 での作図(拡大図・全体図)
  utils.R         get_os() などの補助関数
  use_*_font.sh   shinyapps.io(Linux)向け日本語フォント導入スクリプト
  rsconnect/      shinyapps.io へのデプロイ記録(dcf)
tools/        作業用の一時ファイル・バックアップ(.gitignore 済み，コミット対象外)
README.Rmd    README の生成元．README.md は Rmd から生成する
```

## アーキテクチャの要点

- Shiny モジュール構成．各モジュールは `xxxUI(id)` / `xxxServer(id, ...)` の組で，
  Server はリアクティブ値を返し，`server.R` で次のモジュールへ渡す．
  データの流れ: text → chamame → cleanup → bigram．
- `upload_file.R` の `uploaded_fileServer()` は，「Use example data」の
  チェック状態でサンプルとアップロードファイルを切り替える．
- Web版とローカル版で機能が異なる(ローカル版のみ Combine words / Stop word / Synonym)．
  README にこの差分を明記しているので，機能追加時は README も更新する．

## 作業上の注意

- **`global.R` の `source()` の順序**: `cleanup.R` を含め，
  ui.R/server.R から参照する前にすべて `source` されていること．
- **文字コード**: 日本語を含む R ファイルは UTF-8 で保存する．
- **フォント**: OS ごとに `font_choices` が切り替わる(win/linux/mac)．
  shinyapps.io は linux 扱いになるため，フォント名を変えるときは
  `use_*_font.sh` で導入済みのものを指定する．
- **README**: `README.Rmd` を編集し，knit して `README.md` を再生成する
  (`README.md` を直接編集しない)．
- **tools/** は .gitignore 済み．大きな CSV があるのでコミットしない．
- **デプロイ**: `rsconnect::deployApp("R")` で shinyapps.io へ．
  `R/rsconnect/` 以下の dcf が更新される．無料枠は 25時間/月．

## 進捗状況

### 現在の状態

(2026-08-10 更新)

- 2026-08-10，新パッケージの**名前を `sujimichi`(筋道)に決定**し，
  **新規リポジトリ `matutosi/sujimichi`** として作ることにした．
  CRAN・PyPI とも名前の空きを確認済み．
  2回目の単語の表示方法と段階3のラベル付けの手段は，
  [design-sentence-connection.md](design-sentence-connection.md) に提案を書いて未決のまま．
- 役目を終えた `HANDOFF-moranajp-cran.md` を [done.md](done.md) に統合して削除した．
- git を整理した．remote は `origin` のみ(同じ URL を指す `develop` を削除)，
  ローカルブランチは `main` のみ(2023年で止まっていた `develop` を削除)．
- Claude Code 用のプロジェクト管理ファイル(本ファイル)を新規作成．
  プロジェクト概要・構成・作業上の注意・進捗欄を整備した．
- アプリ本体は 7タブ構成で一通り動作する状態．コードの変更はしていない．
- 新パッケージ「単語のつながりで文章の論理構造を可視化する」の構想を
  ユーザから聞き取り，[design-sentence-connection.md](design-sentence-connection.md) に整理した．
  同一語の判定・さかのぼる範囲・代表語の選び方・入力形式・
  形態素解析のバックエンド・デッドコード検出の方針が決定．
  置き場所と2回目の単語の表示方法は保留．
- moranajp が CRAN からアーカイブされている件を課題として登録．
  ユーザから CRAN のメールが共有され，原因が判明した
  (`web_chamame()` の Examples が Web茶まめに接続できず check がエラー．
  インターネット資源は穏当に失敗させよ，という CRAN ポリシー違反)．
  TODO 欄に原因と修正方針を追記したうえで，
  実際の修正作業は moranajp リポジトリ側へ引き継いだ
  (`d:\Dropbox\todo\moranajp\.claude\HANDOFF-cran-archive.md`)．
- 翌 2026-08-05，moranajp 0.9.8 が **CRAN に受理され，アーカイブから復帰した**．
  あわせて Web茶まめの 2025年の仕様変更(項目番号のずれ・`dic_version` 必須化・
  出力列のずれ)にも追随し，茶まめ経由の解析が動く状態に戻した．
  詳細は [done.md](done.md)．
  この課題は解決したので，残るのは導入方法を CRAN 版に切り替えるかの判断だけだった．
- 2026-08-06，**moranajp の導入を CRAN 版に切り替えた**(`global.R` / `README.Rmd`)．
  あわせて `global.R` のバージョン判定のバグ3件も直した．詳細は [done.md](done.md)．
  切り替えの検証中に見つかった次の2件も直した(詳細は [done.md](done.md))．
  - 茶まめに接続できないときの `moranajp_all()` の `NULL` を `chamame.R` で受け止める．
  - `cleanup.R` の先頭に BOM があり，`source()` が失敗していた
    (**アプリが起動しない状態だった**)．
  そのうえで `shiny::runApp("R")` での起動と
  **shinyapps.io へのデプロイまで完了**した(<https://matutosi.shinyapps.io/textmining2/>)．

### 直近のコミット履歴

- `2600ceb` fix: update textmining2.dcf with correct username, appId, and bundleId
- `ce073f3` fix: reorder source calls to include cleanup.R
- `10e7708` update
- `f5fd29d` update with moranajp

### 関連する構想

- [design-sentence-connection.md](design-sentence-connection.md):
  単語のつながりで文章の論理構造を可視化するパッケージ **`sujimichi`** の構想．
  新規リポジトリ `matutosi/sujimichi` として作る(このリポジトリでは開発しない)．

### TODO / 今後の候補

> 解決済みになった項目は，この節から [done.md](done.md) へ移す
> (完了日と結果を添える)．このファイルには進行中のものだけを残す．

- (未着手) 茶まめタブに実データを通す確認(ブラウザ操作が要る)．
  作図までは `neko_chamame` で確認済み．
- 新パッケージの構想([design-sentence-connection.md](design-sentence-connection.md))も
  同じ形態素解析バックエンドを前提にしているので，方針は moranajp と揃える．
  CRAN に出すなら最初から穏当な失敗の作りにしておく．
- (未着手) 3単語以上の結合(「半-自然-草原」)への対応
- (未着手) 共起ネットワーク・ワードクラウドなどバイグラム以外の図化
- (未着手) `tools/bigram_bak.R` の整理(不要なら削除)
