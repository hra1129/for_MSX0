�����O�m��1
MSX-BASIC �ł́ACALL XXXX �Ƃ������߂��T�|�[�g���Ă���B
����́AROM�J�[�g���b�W�Ȃǂ��� BASIC���߂��g������ꍇ�Ɏg�p����d�g�݂ł���A
�Ⴆ�΁APanasonic �� FMPAC ���ƁAMSX-MUSIC�n�� CALL MUSIC ��AFMPAC�ŗL�� CALL FMPAC
�����AFMPAC�J�[�g���b�W�𑕒����邱�Ƃɂ���Ďg����悤�ɂȂ�B

MSX0 �� IoT BASIC ���A���̎d�g�݂��g���Ċg�������悤���B
CALL IOTPUT, CALL IOTGET �Ƃ������߂��g���ƌ������Ƃ����\����Ă���B

https://twitter.com/nishikazuhiko/status/1601006722218622977

�]���āAMSX0 �� MSX-BASIC ���g����IoT�𗘗p����l�����́A�K�R�I�ɂ��� CALL ��
��������g�����ƂɂȂ�B
�����āACALL �� _ �ő�p���邱�Ƃ��o����B

�����O�m��2
MSX-BASIC �́ABASIC�̓��͉�ʂ�1�s���͂���x�Ƀe�L�X�g������𒆊ԃR�[�h��
�R���p�C�����鏈�������{���Ă���B
RAM��̃v���O�����R�[�h�́A�S�Ă��̒��ԃR�[�h�ɕϊ��ς݂̂��̂ł���B
���O�ɒ�^�I�ȕϊ����s�����Ƃɂ���āA�C���^�v���^�[�̎��s���ɏ����ł���������
�d�|���ł���B

���L�̃R�[�h����͂��Ă݂�ƁALIST �������� CALL �� _ �͓��͂����Ƃ����
�\�������B
����ŁAPRINT �� ? �ő�p�ł��邱�Ƃ��m���Ă��邪�A������� ? �� PRINT ��
�u��������Ă��܂��B

���͂���R�[�h
	100 CALL PAUSE(100)
	110 _ PAUSE(100)
	120 PRINT "HELLO"
	130 ? "HELLO"

LIST�ŕ\�������R�[�h
	100 CALL PAUSE(100)
	110 _ PAUSE(100)
	120 PRINT "HELLO"
	130 PRINT "HELLO"

? �́APRINT �Ɠ������ԃR�[�h�ɃR���p�C������邽�߁ALIST ����� PRINT ��
�\�������̂ł���B
����ACALL �̑�p�ł��� _ �͈ێ�����邱�Ƃ���A���ԃR�[�h���ʂ̒l������
���Ă��Ă��邱�Ƃ��킩��B

	_ �̒��ԃR�[�h�� 05Fh
	CALL �̒��ԃR�[�h�� 0CAh

�ƂȂ�ƁA�C���^�[�v���^�[�̏������኱�ς���Ă���B
�ǂ���̕��������̂��H turboR ����ǉ����ꂽ CALL PAUSE ���g���Čv�����Ă݂�B

100 DEFINTA-Z:I=0
110 TIME=0:FORI=0TO30000:CALLPAUSE(0):NEXT:PRINTTIME
120 TIME=0:FORI=0TO30000:_PAUSE(0):NEXT:PRINTTIME

1885
1880

���ׂȈႢ�����A_ �̕��������ɑ����悤���B
