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

(2026-08-04 更新)

- Claude Code 用のプロジェクト管理ファイル(本ファイル)を新規作成．
  プロジェクト概要・構成・作業上の注意・進捗欄を整備した．
- アプリ本体は 7タブ構成で一通り動作する状態．
  作業ツリーはクリーン(未コミットの変更なし)．

### 直近のコミット履歴

- `2600ceb` fix: update textmining2.dcf with correct username, appId, and bundleId
- `ce073f3` fix: reorder source calls to include cleanup.R
- `10e7708` update
- `f5fd29d` update with moranajp

### TODO / 今後の候補

- (未着手) 3単語以上の結合(「半-自然-草原」)への対応
- (未着手) 共起ネットワーク・ワードクラウドなどバイグラム以外の図化
- (未着手) `tools/bigram_bak.R` の整理(不要なら削除)
