# 解決済みの事項

[CLAUDE.md](CLAUDE.md) の「TODO / 今後の候補」から，解決したものをここへ移す．
新しいものを上に足す．各項目には完了日と結果を書く．

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
