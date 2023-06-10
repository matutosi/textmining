
# textmining2

The goal of textmining is to support textmining visualization of
Japanese.

textmining2はテキストマイニングの図化を支援するツールです．
2023年6月時点では，バイグラムの分析・図化ができます．

## How to use on we, Webで実行 (shinyapps.io)

ウエブ上で使用するには，以下のページをご利用ください．
利用制限等は定めていませんが，使用中のサーバに25時間/月という制限があります．
そのため，急に利用できなくなる可能性があります(他のツールも同じサーバで公開)．

<https://matutosi.shinyapps.io/textmining2>

参考：textmining2の中では，Web茶まめを利用して形態素解析を実行します．

<https://chamame.ninjal.ac.jp/>

バイグラムの図示では，以下の設定が可能です．

- 詳細図の範囲  
- 表示するバイグラムの数  
- 軸の有無  
- 矢印・単語頻度の●のサイズ・色  
- 文字サイズ

さらに，バイグラムの解析結果は表として表示されるとともに，CSVファイルでのダウンロードが可能です．

## How to use on your local PC, ローカル環境で実行

Rを利用されている方は，以下を参考に自身のパソコン上で実行してください．

### ライブラリのインストール(初回のみ実行)

``` r
  # Install and load packages
if(!require("shiny")){
  install.packages("shiny")
}
if(!require("devtools"))         install.packages("devtools")
if(!require("moranajp")){
  devtools::install_github("matutosi/moranajp", upgrade = "never")
}else if(compareVersion("0.9.6.9100", as.character(packageVersion("moranajp"))) > 0){
  detach("package:moranajp")
  devtools::install_github("matutosi/moranajp", upgrade = "never")
}
if(!require("colourpicker"))      install.packages("colourpicker")
if(!require("shinycssloaders"))   install.packages("shinycssloaders")
if(!require("reactable"))         install.packages("reactable")
if(!require("dplyr"))             install.packages("dplyr")
if(!require("ggplot2"))           install.packages("ggplot2")
if(!require("tibble"))            install.packages("tibble")
if(!require("readr"))             install.packages("readr")
```

### textminingの起動

``` r
  # Run app
shiny::runGitHub("matutosi/textmining", subdir = "R")
```

### Web( <https://matutosi.shinyapps.io/textmining2> )版との違い

- Combine wordsが設定可能  
- Stop wordが設定可能  
- Synonymが設定可能

### Combine words

形態素解析実行後に，結合したい単語を指定可能です．
例えば，「半自然」はWeb茶豆の形態素解析では「半」と「自然」に分割されますが，これを「半自然」としたい場合は，「半-自然」として指定します．
3つ以上に分割されたものには，対応していません．
多くの組み合わせのを結合したい場合は，ファイルでの入力が可能です．

### Stop word

バイグラム作成前に，解析から除外するStop
wordとして，exampleでは以下を使用しています．

<http://svn.sourceforge.jp/svnroot/slothlib/CSharp/Version1/SlothLib/NLP/Filter/StopWord/word/Japanese.txt>

これ以外のStop wordを使いたい場合は，カンマ区切りで直接入力するか，Stop
wordを1行ずつに入力したファイルを用意して，アップロード可能です．

### Synonym

入力した文章の表記ゆれがあるものの，実質的にはほぼ同じ意味合いの単語を置換することでまとめます．
例えば，「出来る」と「できる」などです．
タブ区切りのファイルで，1列目(from)には置換前の文字列，2列目(to)には置換後の文字列を入力します．

## MeCab, Sudachi, Ginzaの利用

MeCab, Sudachi,
Ginzaを利用して，ローカル環境で形態素解析を実行する場合は，moranajp::moranajp_all()を使ってください．

<https://github.com/matutosi/moranajp>

なお，textmining2は主要な処理でmoranajpを使っています．
Rをそれなりに使える方は，moranajp(\>=
0.9.6)をインストールしてコードを改良してみてください．

## Citation, 引用

Toshikazu Matsumura (2022) Textmining visualization tools with R and
shiny. <https://matutosi.shinyapps.io/textmining/> .

松村 俊和 (2022)
RとShinyを使ったテキストマイニングの図化ツール．<https://matutosi.shinyapps.io/textmining/>
.

# Make your shiny app

- Home: <https://shiny.rstudio.com/>
- Gallery: <https://shiny.rstudio.com/gallery/>
- Tutorial: <https://shiny.rstudio.com/tutorial/>
- shinyapps.io: <https://www.shinyapps.io/>
- Book: <https://mastering-shiny.org/>
- Book (in Japanese): <https://www.amazon.co.jp/dp/4863542577/>
