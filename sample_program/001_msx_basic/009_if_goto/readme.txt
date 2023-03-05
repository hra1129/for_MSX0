IF文による条件分岐で、命令実行では無く即分岐する場合、
下記の2通りの書き方がある。

IF 条件式 THEN 行番号
IF 条件式 GOTO 行番号

普通に考えて、THEN の方は、下記の記述との区別が必要な分だけ遅そうな
イメージがあるが、それを確認する。

IF 条件式 THEN 命令

確認用のコードは下記になる。

100 DEFINTA-Z:I=0
110 TIME=0:FORI=0TO10000:IF1THEN120
120 NEXT:PRINTTIME
130 TIME=0:FORI=0TO10000:IF1GOTO140
140 NEXT:PRINTTIME
