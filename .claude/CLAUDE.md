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

- 2026-08-10 更新
  新パッケージ `sujimichi`(筋道)を `d:\Dropbox\todo\sujimichi` に独立プロジェクトとして作成した．
  moranajp 0.9.8 が CRAN に復帰し，導入を CRAN 版へ切り替えて shinyapps.io へのデプロイまで完了した．
  git を整理(remote は origin のみ・ローカルブランチは main のみ)．
- それ以前は [notes/history.md](notes/history.md) を見る．

### 直近のコミット履歴

- `2600ceb` fix: update textmining2.dcf with correct username, appId, and bundleId
- `ce073f3` fix: reorder source calls to include cleanup.R
- `10e7708` update
- `f5fd29d` update with moranajp

### 関連する構想

- **`sujimichi`**(筋道): 単語のつながりで文章の論理構造を可視化するパッケージ．
  2026-08-10 に `d:\Dropbox\todo\sujimichi` として独立させた．
  構想をまとめた `design-sentence-connection.md` も
  そちらの `.claude/design.md` へ移した(このリポジトリでは開発しない)．

### TODO / 今後の候補

> 解決済みになった項目は，この節から [done.md](done.md) へ移す
> (完了日と結果を添える)．このファイルには進行中のものだけを残す．

- (未着手) 茶まめタブに実データを通す確認(ブラウザ操作が要る)．
  作図までは `neko_chamame` で確認済み．
- `sujimichi` も同じ形態素解析バックエンドを前提にしているので，
  方針は moranajp と揃える(このリポジトリの作業ではない)．
- (未着手) 3単語以上の結合(「半-自然-草原」)への対応
- (未着手) 共起ネットワーク・ワードクラウドなどバイグラム以外の図化
- (未着手) `tools/bigram_bak.R` の整理(不要なら削除)
