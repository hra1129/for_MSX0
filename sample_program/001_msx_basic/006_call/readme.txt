■事前知識1
MSX-BASIC では、CALL XXXX という命令をサポートしている。
これは、ROMカートリッジなどから BASIC命令を拡張する場合に使用する仕組みであり、
例えば、Panasonic の FMPAC だと、MSX-MUSIC系の CALL MUSIC や、FMPAC固有の CALL FMPAC
等が、FMPACカートリッジを装着することによって使えるようになる。

MSX0 の IoT BASIC も、この仕組みを使って拡張されるようだ。
CALL IOTPUT, CALL IOTGET という命令を使うと言うことが公表されている。

https://twitter.com/nishikazuhiko/status/1601006722218622977

従って、MSX0 で MSX-BASIC を使ってIoTを利用する人たちは、必然的にこの CALL を
たくさん使うことになる。
そして、CALL は _ で代用することが出来る。

■事前知識2
MSX-BASIC は、BASICの入力画面で1行入力する度にテキスト文字列を中間コードへ
コンパイルする処理を実施している。
RAM上のプログラムコードは、全てこの中間コードに変換済みのものである。
事前に定型的な変換を行うことによって、インタプリターの実行時に少しでも速くする
仕掛けである。

下記のコードを入力してみると、LIST した時に CALL と _ は入力したとおりに
表示される。
一方で、PRINT は ? で代用できることも知られているが、こちらは ? が PRINT に
置き換わってしまう。

入力するコード
	100 CALL PAUSE(100)
	110 _ PAUSE(100)
	120 PRINT "HELLO"
	130 ? "HELLO"

LISTで表示されるコード
	100 CALL PAUSE(100)
	110 _ PAUSE(100)
	120 PRINT "HELLO"
	130 PRINT "HELLO"

? は、PRINT と同じ中間コードにコンパイルされるため、LIST すると PRINT と
表示されるのである。
一方、CALL の代用である _ は維持されることから、中間コードも別の値が割り
当てられていることがわかる。

	_ の中間コードは 05Fh
	CALL の中間コードは 0CAh

となると、インタープリターの処理も若干変わってくる。
どちらの方が速いのか？ turboR から追加された CALL PAUSE を使って計測してみる。

100 DEFINTA-Z:I=0
110 TIME=0:FORI=0TO30000:CALLPAUSE(0):NEXT:PRINTTIME
120 TIME=0:FORI=0TO30000:_PAUSE(0):NEXT:PRINTTIME

1885
1880

些細な違いだが、_ の方が微妙に速いようだ。
