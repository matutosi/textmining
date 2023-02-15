#!/bin/bash

### shinyapps.ioでグラフの日本語表示をするためのスクリプト
### Author: Kenta Tanaka (https://mana.bi/)
### 以下の記事を参考 (ほぼ丸パクり) にしました
### https://ziomatrix18.blog.fc2.com/blog-entry-853.html
###
### 使い方
### Shinyアプリ内で以下のように実行してください
### download.file("https://raw.githubusercontent.com/ltl-manabi/shinyapps.io_japanese_font/master/use_seto_font.sh", destfile = "use_seto_font.sh")
### system("bash ./use_seto_font.sh")


mkdir ~/tmp
cd ~/tmp
curl -O -L https://ja.osdn.net/projects/setofont/downloads/61995/setofont_v_6_20.zip
unzip setofont_v_6_20.zip
mkdir -p ~/.fonts/seto
cp ./setofont/*.ttf ~/.fonts/seto
fc-cache -f ~/.fonts
