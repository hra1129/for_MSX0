コメントの長さが、実行速度に影響を及ぼすか。
下記のコードで検証する。

100 DEFINTA-Z:I=0
110 TIME=0:FORI=0TO10000:REM1
120 NEXT:PRINTTIME
130 TIME=0:FORI=0TO10000:REM123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
140 NEXT:PRINTTIME

turboR実行結果
98
306

メモリ上には、行頭に次の行のアドレスが格納されていますが、この値は活用されず、
REMから順次行末を探索するようですね。
コメント文字列の長さがそのまま遅さに響いてきます。
このことからも、速度が必要なループ内にコメントを記述するのはなるべく避けるべきですね。
