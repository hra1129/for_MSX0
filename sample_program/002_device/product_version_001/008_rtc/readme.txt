MSX0では、時計アプリなんかは、定番アプリになりそうな気配。
そして、MSXべーしっ君はすでに定番になりつつあります。

そうなると、MSXべーしっ君で GETTIME T$:GETDATE D$ と実行
したくなるわけですが、残念ながらこの2つの命令はべーしっ君
は非対応。コンパイル時にエラーになります。

ということで、RTCにダイレクトにアクセスして、Date/Time を
受け取る処理を書いてみました。
これなら、べーしっ君で高速化できます。
