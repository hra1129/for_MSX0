100 DEFINTA-Z:SCREEN1,3,0:KEYOFF:COLOR15,4,4:BLOAD"FISH.BIN",S
110 _TURBOON
120 D$="host/accel/x":GOSUB1010:X=R\32
130 D$="host/accel/y":GOSUB1010:Y=R\32
140 REM ATAN2( Y, X )
150 SX=SGN(X):SY=SGN(Y):X=ABS(X):Y=ABS(Y):IF X=0 AND Y=0 THEN T=0:GOTO 260
160 IF X>Y THEN D=X:N=Y ELSE D=Y:N=X
170 R=N*128\D
180 IF R<=12 THEN T=0:GOTO 220
190 IF R<=39 THEN T=1:GOTO 220
200 IF R<=69 THEN T=2:GOTO 220
210 IF R<=106 THEN T=3 ELSE T=4
220 IF D=Y THEN T=8-T
230 IF SX=-1 THEN T=16-T
240 IF SY=-1 THEN T=32-T
250 T=T AND 31
260 IF STRIG(0) THEN END
265 LOCATE 0,10:PRINT T
270 PUTSPRITE0,(0,0),7,T:GOTO 120
1000 REM _IOTGET( D$, R )
1010 OUT8,&HAC:OUT8,1:L=LEN(D$)
1020 OUT8,L:FORI=1TOL:OUT8,ASC(MID$(D$,I,1)):NEXTI:OUT8,&HAB
1030 R=INP(8)+INP(8)*256:RETURN