# 解決済みの事項

[CLAUDE.md](CLAUDE.md) の「TODO / 今後の候補」から，解決したものをここへ移す．
新しいものを上に足す．各項目には完了日と結果を書く．

## README の「Web版との違い」の節を削除

- **完了日**: 2026-08-06
- **結果**: `README.Rmd` から「Web版との違い」の節(Combine words / Stop word / Synonym)を削除し，
  導入文も「Web版と同じ機能を使えます」に直した．`README.md` を再生成．
- **なぜ消したか**: **ローカル版だけの機能ではなく，Web にデプロイしていなかっただけ**だった．
  - 2023-03-01 に ver2(3タブ: Read text / Chamame / Bigram)をデプロイ．
  - 2023-06-08〜11 に ver3 で Cleanup・Stop words・Combine words・Synonym を追加．
  - 2023-06-09 にこの節を追加(当時は正しい記述)．
  - **2026-08-06 のデプロイで ver3 が Web に反映され，差が消えた**．
  - `R/ui.R` の `tabPanel()` は7つとも無条件で，環境による分岐は元から無い．
- **教訓**: 「Web版との違い」を書くとデプロイのたびに見直しが要る．
  同じソースを両方で使う以上，差分を文書に持たないほうがよい．
  実際の差は無料枠 25時間/月の制限だけで，これは README の前半に既にある．

## 動作確認とデプロイ(CRAN 版への切り替え後)

- **完了日**: 2026-08-06
- **ローカル起動**: `shiny::runApp("R", port = 8787)` で `Listening` まで到達し，
  HTTP 200 を確認．7タブすべてが HTML に出ている．
  起動時に判定が働き，CRAN から moranajp 0.9.8 が入った
  (Windows バイナリがあるのでビルド不要)．
- **作図の確認**: `neko_chamame` をアプリと同じ経路
  (`add_sentence_no` → `combine_words` → `clean_up` → `bigram` →
  `bigram_network` → `bigram_network_plot`)に通し，拡大図・全体図を PNG まで出力できた．
  - **ggplot2 4.0.3 でも壊れていない**ことをここで確認した(3.x からの破壊的変更があるため)．
  - 例示データは escape された状態で入っているので，
    `unescape_utf()` を列名と中身の両方にかける必要がある．
- **デプロイ**: `rsconnect::deployApp("R")` で成功
  (<https://matutosi.shinyapps.io/textmining2/>，HTTP 200)．
  bundleId は 8706928 → 12371962．
  - **デプロイ元は R 4.5.1**．moranajp 0.9.8 が入っているライブラリがここだけのため
    (4.4 は 0.9.7 かつ shinycssloaders 無し，4.2 は 0.9.6)．
    rsconnect は 4.5 に入っていなかったので導入した(1.10.1)．
  - サーバ側は 99 依存を解決し，moranajp も**ソースからビルドできている**
    (GitHub 参照が消えたので，CRAN から解決される)．

## `cleanup.R` の BOM でアプリが起動しなかった問題

- **完了日**: 2026-08-06
- **結果**: `R/cleanup.R` の先頭 3バイトの BOM(`ef bb bf`)を削除した．
- **症状**: `global.R` の `source("cleanup.R")` が
  `unexpected input` で失敗し，アプリが起動しない．
  BOM が最初の文字として読まれるため，構文エラーになる．
- **見つかった経緯**: CRAN 版への切り替えのあと，
  `R/` の全ファイルを `parse()` にかけて確認していて判明した．
- **注意**: RStudio から開くと encoding を補ってくれるので気づきにくい．
  素の R セッション(`Rscript` / `shiny::runApp()`)では失敗する．
  日本語を含む R ファイルは **BOM なしの UTF-8** で保存すること．
  現在 `R/*.R` に BOM のあるファイルは無い．

## 茶まめに接続できないときの `NULL` をアプリ側で受け止める

- **完了日**: 2026-08-06
- **結果**: [R/chamame.R](../R/chamame.R) の `chamameServer()` に `NULL` の分岐を入れた．
  接続できないときは，エラー画面ではなく
  「Cannot connect to web chamame ... Please try again later.」の1行を表として返す．
- **背景**: moranajp 0.9.8 は Web茶まめに接続できないとき，
  CRAN ポリシーに沿って `message()` を出して `NULL` を返す．
  ところがアプリは結果をそのままパイプに流していたので，
  `NULL` が `add_sentence_no()` に渡ってエラーになっていた
  (パッケージが穏当に失敗しても，アプリはエラー画面になる)．
- `nrow(data_in()) == 0` のときに空の tibble を返している既存の形に揃えた．

## moranajp の導入を CRAN 版に切り替え

- **完了日**: 2026-08-06
- **結果**: `remotes::install_github("matutosi/moranajp", ref = "develop")` をやめ，
  `install.packages("moranajp")` にした．
  手順は moranajp 側のセッションからの引き継ぎ(2026-08-05 作成)にしたがった．
  引き継ぎファイルは役目を終えたので，必要な内容をこの項目に統合して削除した．
- **`R/global.R`**: 判定を次の形にまとめ，`remotes` の導入行と
  到達しない `if(!require("moranajp")) install.packages("moranajp")` を削除した．

  ```r
  if(!requireNamespace("moranajp", quietly = TRUE) ||
     compareVersion(as.character(packageVersion("moranajp")), "0.9.8") < 0){
    install.packages("moranajp")
  }
  library(moranajp)
  ```

  - **ついでに直したバグ3件**: バージョン比較の向きが逆(新しい版ほど
    起動ごとに develop を取り直していた) / `|` が短絡せず未インストール環境でエラー /
    CRAN から入れる行が到達しない．
  - 判定を別プロセスで検証: 未インストール・0.9.5・0.9.7 は install，
    0.9.8 と **0.9.8.9000(develop)はそのまま**．
    develop 版を入れて試している環境を CRAN 版で上書きしない．
- **`README.Rmd`**: 他のパッケージと同じ1行に統一し，`detach()` を廃止．
  推奨版の記述を 0.9.6 → 0.9.8 に更新．
  `rmarkdown::render()` で `README.md` を再生成した
  (`README.md` 側には古い `devtools::install_github()` が残っていたので，これも解消)．
- **CRAN 側の確認**: `available.packages()` で 0.9.8 を確認．
- **残件**: 動作確認(`runApp` とデプロイ)と，
  茶まめ接続不可時の `NULL` を `chamame.R` で受け止める件を TODO に残した．
- **覚えておくこと**(引き継ぎファイルから統合)
  - moranajp は**純粋な R パッケージ**(`src/` が無い)なので，
    Windows/macOS のバイナリ配布を待つ必要はない．ソースからでもコンパイラなしで入る．
  - **CRAN 版は 0.9.8 で固定される**．moranajp 側で急ぎの修正をして
    textmining2 で先に使いたいときは，一時的に
    `remotes::install_github("matutosi/moranajp", ref = "develop")` に戻す
    (develop は `0.9.8.9000`)．判定は develop 版を CRAN 版で上書きしない作りにしてある．
  - CRAN 版にした利点はデプロイに出る．GitHub 由来のパッケージは
    rsconnect が SCM の参照を記録してデプロイ先で再取得するため失敗しやすいが，
    CRAN 版なら Posit のパッケージマネージャから解決されて安定する．
  - CRAN 上の版の確認は `available.packages()["moranajp", "Version"]` で足りる．
  - 関連する記録(このリポジトリの外)
    - moranajp 側の対応の記録: `d:\Dropbox\todo\moranajp\.claude\CLAUDE.md`
    - 逆方向の引き継ぎ(textmining → moranajp):
      `d:\Dropbox\todo\moranajp\.claude\HANDOFF-cran-archive.md`

## moranajp の CRAN アーカイブへの対応(CRAN 復帰まで完了)

- **完了日**: 2026-08-05(修正は 2026-08-04，投稿・受理が 2026-08-05)
- **結果**: **moranajp 0.9.8 が CRAN に受理され，アーカイブから復帰した**
  (Uwe Ligges 氏より "Thanks, on its way to CRAN.")．
  `v0.9.8` タグは CRAN へ送ったツリーと同一のコミット `7b0ddad` を指す．
- **検証した環境**(いずれも ERROR・WARNING なし)
  - local: Windows 11, R 4.5.1 → 1 NOTE(「New submission / archived on CRAN」のみ)
  - win-builder: Windows Server 2022, R-devel → 同じ 1 NOTE
  - R-hub: ubuntu-latest / windows-latest / macos-15-intel の R-devel → すべて `Status: OK`
- **アーカイブの原因への対応**
  - `web_chamame()` を穏当に失敗させた．ページ取得(`read_html_safely()`)だけでなく，
    フォーム送信・結果の解析も包み，接続不能でも応答が変わっていても
    `message()` を出して `NULL` を返す．`moranajp_all(method = "chamame")` も `NULL`．
  - ネットワークに触れる Examples を `\dontrun{}` にした．
    `make_groups()` は `@inherit moranajp_all` で例を継承しており，
    そこが `\donttest{}` のままだと CRAN の check で実行されるので，これも同時に解決した．
  - テストはネットワークを使わない(「使えないときに `NULL` を返す」テストのみ追加)．
- **副産物: Web茶まめが壊れていた原因が判明し，復旧した**
  - 2025年に Web茶まめのフォーム項目が 62 → 70 に増え，
    ハードコードしていた項目番号が全部ずれていた → **名前で選ぶ**ように変更．
  - 新設の `dic_version` を送らないと UniDic 系辞書で
    サーバが **500 Internal Server Error** を返す → これを送るようにして復旧．
    (この間，`web_chamame()` はエラー画面を表として読んでしまい，
    ゴミを返していた．今は内容も点検する．)
  - 辞書を選ぶ `dic` 引数を追加(既定 `"unidic-spoken"`)．
  - **出力列のマッピングも直した**．出力項目を多く要求すると応答の見出しとセルが
    対応しないので，必要な項目だけを要求して**列名で選ぶ**ようにした．
    `原形` は語彙素ではなく**書字形(基本形)**が正解(`で → だ`，`ある → ある`)．
    保存済み `neko_chamame` と照合し，差は茶まめ側の辞書更新による2件のみ．
    **出力仕様は変わっていないので textmining2 側の修正は不要**．
    照合用スクリプト: moranajp の `data-raw/check_chamame.R`．
- **副産物: develop に purrr 1.2.0 対応が欠けていた**ことが main へのマージで判明した．
  `is_radio()`(`web_chamame()` がフォームのラジオボタンを設定するのに使う)の
  `purrr::map_chr(`$`, "type")` は purrr 1.2.0 で壊れる．
  main 側にだけ hadley 氏の PR #1 として入っていた修正で，
  ローカルの purrr は 1.0.4 なので check では出なかった．
  main へマージしたことで，修正が入った状態で CRAN に出せている．
- **textmining2 への影響**: 出力仕様は変わっていないので**修正は不要**．
  導入方法を CRAN 版に切り替えるかの判断のみ CLAUDE.md の TODO に残した．

<!-- 以下に古い項目を足していく -->
