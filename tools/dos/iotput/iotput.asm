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
;		HL ... デバイスパス文字列 (BASIC形式)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		デバイスパス文字列を送信する。
; =============================================================================
			scope	_send_device_path
_send_device_path::
			ld		c, 8
			; デバイスパス送信開始コマンド
			ld		a, 0xe0
			out		[c], a
			ld		a, 1
			out		[c], a
			ld		a, 0x53
			out		[c], a
			; このまま _send_string へ続く
			endscope

; =============================================================================
;	_send_string
;	input:
;		HL ... 送信文字列 (BASIC形式)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		送信文字列を送信する。
; =============================================================================
			scope	_send_string
_send_string::
			ld		a, 0xc0
			out		[c], a
			; 文字列の長さを取得
			ld		a, [hl]
	_iot_send_string_loop1:
			ld		b, a
			cp		a, 64							; 64文字以上の場合は特別処理を実施する
			jr		c, _iot_send_string_skip
			sub		a, 63
			ld		b, 0x7f							; 特別処理を示すコード
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
			rlca									; エラーなら cf = 1, 正常なら cf = 0
			ret		nc
			; エラー
			ld		de, device_io_error
			ld		c, 9
			call	bdos
			ret

device_io_error:
			db		"Device I/O error.", 10, 13, '$'

			endscope
