漢字BASICによるテキスト表示サンプル。

100 DEFINTA-Z:_KANJI:COLOR15,0,0
110 LOCATE0,0:PRINT "漢字のテストです"
120 FORI=0TO100:LOCATE0,1:PRINT"I=";I:NEXT
130 COLOR6:PRINT"漢";:COLOR9:PRINT"字"

漢字BASICでは、COLOR f,b,a の色指定は、その指定以降に反映され、
それ以前に表示した内容には影響を及ぼさない。
