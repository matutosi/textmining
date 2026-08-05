# 引き継ぎ: moranajp を CRAN 版に切り替える

(2026-08-05 作成．moranajp プロジェクトのセッションからの引き継ぎ)

## 前提: 確認済み

**moranajp 0.9.8 は CRAN で公開されている**(確認日 2026-08-05)．

- <https://cran.r-project.org/package=moranajp> → Version: 0.9.8 / Published: 2026-08-05
- `https://cran.r-project.org/src/contrib/moranajp_0.9.8.tar.gz` → HTTP 200
- `https://cran.r-project.org/src/contrib/PACKAGES` に `Package: moranajp` / `Version: 0.9.8`

つまり**この引き継ぎの条件はすでに満たされており，すぐ着手してよい**．

再確認したいときは次で足りる．

```r
available.packages()["moranajp", "Version"]
```

なお **moranajp は純粋な R パッケージ(`src/` が無い)**なので，
Windows/macOS のバイナリ配布を待つ必要はない．
ソースからでもコンパイラなしで入る．

## やること

`remotes::install_github()` での導入を `install.packages()` に切り替える．
対象は2か所．

### 1. `R/global.R`(本体．こちらが主目的)

現状は次のようになっている(3〜13行目)．

```r
if(!require("remotes"))         install.packages("remotes")
if(!require("moranajp") |
    compareVersion("0.9.5", as.character(packageVersion("moranajp"))) < 0){
  remotes::install_github("matutosi/moranajp", ref = "develop")
  library(moranajp)
}
...
if(!require("moranajp"))          install.packages("moranajp")
```

**このコードには切り替えとは別に3つ問題がある**ので，書き換えのついでに直す．

1. **バージョン比較の向きが逆**．
   `compareVersion("0.9.5", installed) < 0` は
   「インストール済みが 0.9.5 **より新しい**」ときに真になる．
   つまり新しい版が入っているほど GitHub から入れ直す．
   起動ごとに develop を取得し直す状態になっていた(0.9.8 が入っていれば必ず該当する)．
2. **`|` が短絡しない**．
   moranajp が入っていない環境では，`require()` が FALSE でも
   右辺の `packageVersion("moranajp")` が評価されてエラーになる．`||` にする．
3. **13行目は到達しない**．
   上のブロックで `library(moranajp)` 済みなので，
   CRAN から入れる唯一の行が死んでいる．

書き換え案:

```r
library(shiny)
if(!requireNamespace("moranajp", quietly = TRUE) ||
   compareVersion(as.character(packageVersion("moranajp")), "0.9.8") < 0){
  install.packages("moranajp")
}
library(moranajp)
```

- `requireNamespace()` は attach せずに存在だけ見るので，判定に使うのに適している．
- `||` なので未インストールでも右辺は評価されない．
- 比較の向きは「入っている版 < 0.9.8 なら入れる」．
- 13行目の `if(!require("moranajp")) install.packages("moranajp")` は**削除**する
  (上のブロックに統合される)．
- `remotes` は global.R の中でここだけで使っていた．
  他で使わないなら 3行目も削除できる(README では別途使っている点に注意)．

### 2. `README.Rmd`(利用者向けの手順)

63〜68行目にも GitHub から入れる記述がある．

```r
if(!require("moranajp")){
  remotes::install_github("matutosi/moranajp", upgrade = "never")
}else if(compareVersion("0.9.6.9100", as.character(packageVersion("moranajp"))) > 0){
  detach("package:moranajp")
  remotes::install_github("matutosi/moranajp", upgrade = "never")
}
```

`install.packages("moranajp")` に置き換える．
他のパッケージと同じ1行の形に揃えられる．

```r
if(!require("moranajp"))          install.packages("moranajp")
```

- `detach()` は不要になる．
- 168行目の「moranajp(>= 0.9.6)をインストールして」も 0.9.8 に更新するか検討する．
- **`README.md` は `README.Rmd` から生成する**ので，
  `devtools::build_readme()` などで再生成すること(直接編集しない)．

## 動作確認

1. ローカルで `shiny::runApp("R")` を実行し，茶まめのタブが動くか見る．
   - **Web茶まめはインターネット資源**なので，落ちているときは
     moranajp 0.9.8 が `NULL` を返して穏当に失敗する(エラーにはならない)．
     アプリ側がその `NULL` をどう扱うかは未確認なので，ここは見ておいたほうがよい
     (`R/chamame.R` の `moranajp_all()` の呼び出し箇所)．
2. shinyapps.io へデプロイして確認する
   (`R/rsconnect/shinyapps.io/matutosi/textmining2.dcf` が既存の設定)．
   - **CRAN 版にする利点がここに出る**．
     GitHub 由来のパッケージは rsconnect が SCM の参照を記録して
     デプロイ先で再取得するため失敗しやすいが，CRAN 版なら
     Posit のパッケージマネージャから解決されて安定する．

## 注意点

- **develop の先行修正が必要になったときは戻せるようにしておく**．
  CRAN 版は 0.9.8 で固定される．moranajp 側で急ぎの修正をして
  textmining2 で先に使いたい場合は，一時的に
  `remotes::install_github("matutosi/moranajp", ref = "develop")` に戻す
  (develop は現在 `0.9.8.9000`)．
- **出力仕様は 0.9.7 から変わっていない**．
  茶まめの出力列(`表層形` `品詞` `品詞細分類1`〜`3` `原形`)は
  アーカイブ前と同じ意味に揃えてあるので，
  切り替えによって textmining2 側のコードを直す必要はない．
- moranajp 0.9.8 の変更点は同リポジトリの `NEWS.md` を参照．

## 関連

- moranajp の対応の記録: `d:\Dropbox\todo\moranajp\.claude\CLAUDE.md`
- CRAN アーカイブの経緯と解決: [done.md](done.md)
- 前回の逆方向の引き継ぎ(textmining → moranajp):
  `d:\Dropbox\todo\moranajp\.claude\HANDOFF-cran-archive.md`
