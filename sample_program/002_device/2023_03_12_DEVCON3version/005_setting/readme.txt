_IOTPUT("settings/プロパティ名",値)

これで値を変更後に、

_IOTPUT("settings/save",1)

で setting の変更結果を保存＆再起動が出来るらしい。

_IOTGET("settings/brightness",A):?A

これで 2 が表示される状態で、

_IOTPUT("settings/brightness",1)
_IOTPUT("settings/save",1)

これで暗くなることを確認。

即時反映では無く、save すると保存の上に再起動がかかるというのが使いにくい。
