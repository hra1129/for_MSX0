100 DEFINTA-Z:_KANJI:COLOR15,0,0:SCREEN5
110 FORI=0TO100:LINE(RND(1)*255,RND(1)*211)-(RND(1)*255,RND(1)*211),(IAND7)+2:NEXT
120 LOCATE0,0:PRINT"����BASIC�̓O���t�B�b�N��ʂł�OK"
130 LOCATE0,10:COLOR2,4:PRINT"�F���ς����܂�"
140 A$=INPUT$(1)