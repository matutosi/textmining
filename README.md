
# textmining

The goal of textmining is to support textmining visualization.

textminingはテキストマイニングの図化を支援するツールです．
2022年5月時点では，バイグラムの分析・図化が主にできることです．

## How to use

Run on web (shinyapps.io).

ウエブ上で使用するには，以下のページをご利用ください．
利用制限等は定めていませんが，使用中のサーバに25時間/月という制限があります．
そのため，急に利用できなくなる可能性があります(他のツールも同じサーバで公開)．

<https://matutosi.shinyapps.io/textmining>

Run on your local PC.

Rご利用されている方は，以下のページの内容をもとにご自身のパソコン上で分析していただけると助かります．

``` r
  # Install packages (need only once)
if(!require("devtools"))        install.packages("devtools")
if(!require("moranajp"))        install.packages("moranajp")  # (>= 0.9.5)
if(!require("shiny"))           install.packages("shiny")
if(!require("shinycssloaders")) install.packages("shinycssloaders")
if(!require("tidyverse"))       install.packages("tidyverse")
if(!require("reactable"))       install.packages("reactable")
if(!require("igraph"))          install.packages("igraph")
if(!require("ggraph"))          install.packages("ggraph")
if(!require("colourpicker"))    install.packages("colourpicker")

  # Run app
shiny::runGitHub("matutosi/textmining", subdir = "R")
```

ローカル環境にMeCabがなければ，国立国語研究所の茶まめで形態素解析した結果をアップロードしてください．

<https://chamame.ninjal.ac.jp/>

結果は，UTF-8区切りのcsvファイルでダウンロードしてください．
その後，\[Read ALANYZED data\] でファイルをアップして，\[Bigram
(analyzed data)\]をクリックしてください．
ローカル環境にMeCabをインストールしれいれば，テキストデータからMeCabを実行してバイグラムの分析につなげることが可能です．

バイグラムの図示では，以下の設定が可能です．

-   詳細図の範囲
-   表示するバイグラムの数
-   軸の有無
-   矢印・単語頻度の●のサイズ・色
-   文字サイズ

さらに，バイグラムの解析結果は表として表示されるとともに，CSVファイルでのダウンロードが可能です．

## Citation

Toshikazu Matsumura (2022) Textmining visualization tools with R and
shiny. <https://matutosi.shinyapps.io/textmining/> .

松村 俊和 (2022)
RとShinyを使ったテキストマイニングの図化ツール．<https://matutosi.shinyapps.io/textmining/>
.

# Make your shiny app

-   Home: <https://shiny.rstudio.com/>
-   Gallery: <https://shiny.rstudio.com/gallery/>
-   Tutorial: <https://shiny.rstudio.com/tutorial/>
-   shinyapps.io: <https://www.shinyapps.io/>
-   Book: <https://mastering-shiny.org/>
-   Book (in Japanese): <https://www.amazon.co.jp/dp/4863542577/>
