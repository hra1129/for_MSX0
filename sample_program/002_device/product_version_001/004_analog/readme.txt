_IOTGET("sample/analog",A)
_IOTGET("sample/prm1",P1)
_IOTGET("sample/prm2",P2)

core2 の黒いポート (port.B) に接続するタイプのセンサーの値を
sample/analog で取得することが出来る。
prm1, prm2 は、現状 123 と 456 という適当な値が返ってくる模様。
以下は、analog について。

試作機とともに配られた Grove Beginner Kit for Arduino に入っている
温度/湿度センサーを繋げると 4095 が返ってくる。外すと 0

アナログボリュームつまみを繋げると、つまみを回すことで変化する値が
得られる。

光センサーは無反応。0固定。

マイクはランダムな値が返ってくる。反応を得られているのかは不明。
