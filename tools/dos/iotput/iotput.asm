; --------------------------------------------------------------------
;	IOTPUT <device path> <value>
; ====================================================================
;	2023/10/07	t.hara
; --------------------------------------------------------------------

bdos		:= 0x0005

		org			0x100

		ld			c, 0x00
		jp			bdos

; =============================================================================
;	_send_device_path
;	input:
;		HL ... �f�o�C�X�p�X������ (BASIC�`��)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		�f�o�C�X�p�X������𑗐M����B
; =============================================================================
			scope	_send_device_path
_send_device_path::
			ld		c, 8
			; �f�o�C�X�p�X���M�J�n�R�}���h
			ld		a, 0xe0
			out		[c], a
			ld		a, 1
			out		[c], a
			ld		a, 0x53
			out		[c], a
			; ���̂܂� _send_string �֑���
			endscope

; =============================================================================
;	_send_string
;	input:
;		HL ... ���M������ (BASIC�`��)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		���M������𑗐M����B
; =============================================================================
			scope	_send_string
_send_string::
			ld		a, 0xc0
			out		[c], a
			; ������̒������擾
			ld		a, [hl]
	_iot_send_string_loop1:
			ld		b, a
			cp		a, 64							; 64�����ȏ�̏ꍇ�͓��ʏ��������{����
			jr		c, _iot_send_string_skip
			sub		a, 63
			ld		b, 0x7f							; ���ʏ����������R�[�h
	_iot_send_string_skip:
			out		[c], b
			ld		d, a
			ld		a, b
			and		a, 0x3f
			ld		b, a
	_iot_send_string_loop2:
			inc		hl
			ld		a, [hl]
			out		[c], a
			djnz	_iot_send_string_loop2
			ld		a, d
			sub		a, 63
			jr		z, _iot_send_string_exit
			jr		nc, _iot_send_string_loop1
	_iot_send_string_exit:
			in		a, [c]
			rlca									; �G���[�Ȃ� cf = 1, ����Ȃ� cf = 0
			ret		nc
			; �G���[
			ld		de, device_io_error
			ld		c, 9
			call	bdos
			ret

device_io_error:
			db		"Device I/O error.", 10, 13, '$'

			endscope
