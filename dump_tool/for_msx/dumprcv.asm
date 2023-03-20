; --------------------------------------------------------------------
;	DUMPRCV
; ====================================================================
;	2023/3/20	t.hara(HRA!)
; --------------------------------------------------------------------

		org			0x100

; --------------------------------------------------------------------
;	main routine
; --------------------------------------------------------------------
		scope		main
main::
		; プロンプトを表示
		ld			de, prompt
		call		puts
		; ファイル名を入力
		call		get_file_name
		call		put_file_name
		; ファイルを開く
		call		open_file
		; 中身を書き出す
		call		fwrite_body
		; ファイルを閉じる
		call		close_file
		ld			c, D1F_TERM0
		jp			bdos
		endscope

; --------------------------------------------------------------------
		scope		get_file_name
get_file_name::
		ld			hl, fcb_name
	loop_file_name:
		push		hl
		call		getc
		pop			hl
		cp			a, '.'
		jr			z, input_file_ext
		cp			a, ':'
		jr			z, end_of_input_file_name
		call		check_name_char
		jp			nc, invalid_char
		ld			[hl], a
		inc			hl
		ld			a, l
		cp			a, fcb_name + 8
		jr			nz, loop_file_name
	input_file_ext:
		ld			hl, fcb_ext
	loop_file_ext:
		push		hl
		call		getc
		pop			hl
		cp			a, ':'
		jr			z, end_of_input_file_name
		call		check_name_char
		jp			nc, invalid_char
		ld			[hl], a
		inc			hl
		ld			a, l
		cp			a, fcb_ext + 3
		jr			nz, loop_file_ext
	end_of_input_file_name:
		ret

	invalid_char:
		ld			de, invalid_char
		call		puts
		ld			c, D1F_TERM0
		jp			bdos
		endscope

; --------------------------------------------------------------------
		scope		put_file_name
put_file_name::
		; プロンプト表示
		ld			de, s_file_name
		call		puts
		; ファイル名を表示
		ld			b, 8
		ld			hl, fcb_name
	loop_file_name:
		ld			[save_bc], bc
		ld			[save_hl], hl
		ld			a, [hl]
		cp			a, ' '
		jr			z, put_dot		; 途中で ' ' を発見したら拡張子の表示へ移る
		call		putc
		ld			hl, [save_hl]
		ld			bc, [save_bc]
		inc			hl
		djnz		loop_file_name
	put_dot:
		ld			a, '.'			; ファイル名と拡張子の区切りに '.' を表示
		call		putc
		; 拡張子を表示
		ld			b, 3
		ld			hl, fcb_ext
	loop_file_ext:
		ld			[save_bc], bc
		ld			[save_hl], hl
		ld			a, [hl]
		cp			a, ' '
		jr			z, put_end		; 途中で ' ' を発見したら表示を終了
		call		putc
		ld			hl, [save_hl]
		ld			bc, [save_bc]
		inc			hl
		djnz		loop_file_ext
	put_end:
		ld			a, '\r'
		call		putc
		ld			a, '\n'
		call		putc
		ret
		endscope

; --------------------------------------------------------------------
		scope		open_file
open_file::
		; fopen
		ld			de, fcb
		ld			c, D1F_FMAKE
		call		bdos
		or			a, a						; 00h 成功, FFh 失敗
		jp			nz, cannot_create_file
		ret
	cannot_create_file:
		ld			de, s_cannot_create_file
		call		puts
		ld			c, D1F_TERM0
		jp			bdos
		endscope

; --------------------------------------------------------------------
		scope		close_file
close_file::
		ld			de, fcb
		ld			c, D1F_FCLOSE
		jp			bdos
		endscope

; --------------------------------------------------------------------
		scope		fwrite_body
fwrite_body::
		; 1文字入力
		call		getc
		call		isdigit
		jp			c, get_one_byte_command
		call		is_A_to_F
		jp			c, get_one_byte_command
		; 終了記号
		cp			a, 'e'
		ret			z
		; ランレングス記号
		cp			a, 'r'
		jp			z, decompress_run_length
		; 他の記号は無視
		jp			fwrite_body

		; 1バイト受付
	get_one_byte_command:
		call		get_one_byte
		ld			[dta], a
		; - 1バイト書き出し
		ld			de, dta				; 転送元アドレスを指定
		ld			c, D1F_SETDTA
		call		bdos
	xxxxxxxxx::
		ld			hl, 1
		ld			[fcb_recode_size], hl

		ld			de, fcb
		ld			hl, 1				; 1レコード (1レコードは FCB で 1byte にしてある)
		ld			c, D1F_WRBLK
		call		bdos
		jp			fwrite_body

		; ランレングスデコード
	decompress_run_length:
		call		get_one_byte
		ld			[dta], a
		call		getc
		call		get_one_byte
		ld			b, a

	decompress_loop:
		push		bc
		; - 1バイト書き出し
		ld			de, dta				; 転送元アドレスを指定
		ld			c, D1F_SETDTA
		call		bdos

		ld			hl, 1
		ld			[fcb_recode_size], hl

		ld			de, fcb
		ld			hl, 1				; 1レコード (1レコードは FCB で 1byte にしてある)
		ld			c, D1F_WRBLK
		call		bdos
		pop			bc
		djnz		decompress_loop
		jp			fwrite_body
		endscope

; --------------------------------------------------------------------
		scope		get_one_byte
get_one_byte::
		add			a, -'0'
		cp			a, 10
		jr			c, skip_hex1
		add			a, '0'-'A'+10
	skip_hex1:
		add			a, a
		add			a, a
		add			a, a
		add			a, a
		ld			[save_bc], a
		call		getc
		add			a, -'0'
		cp			a, 10
		jr			c, skip_hex2
		add			a, '0'-'A'+10
	skip_hex2:
		ld			c, a
		ld			a, [save_bc]
		or			a, c
		ret
		endscope

; --------------------------------------------------------------------
		scope		is_A_to_F
is_A_to_F::
		cp			a, 'A'
		ccf
		ret			nc
		cp			a, 'F'+1
		ret
		endscope

; --------------------------------------------------------------------
		scope		check_name_char
check_name_char::
		call		isdigit
		ret			c
		call		isalpha
		ret			c
		cp			a, '_'
		jr			nz, is_not_valid_char
		scf						; Cy=1
		ret
	is_not_valid_char:
		or			a, a		; Cy=0
		ret
		endscope

; --------------------------------------------------------------------
;	include
; --------------------------------------------------------------------
		include		"MSXDOS1.ASM"
		include		"STDIO.ASM"
		include		"STRING.ASM"

; --------------------------------------------------------------------
;	datas
; --------------------------------------------------------------------
prompt::
		ds			"DUMPRCV v1.0\r\n"
		ds			"Programmed by (C)2023 HRA!\r\n"
		db			0

s_file_name::
		ds			"FILE NAME:"
		db			0

s_cannot_create_file::
		ds			"Cannot create the file.\r\n"
		db			0

save_bc::
		dw			0
save_hl::
		dw			0

fcb::
		db			0			; drive num
	fcb_name:
		ds			"        "	; file name
	fcb_ext:
		ds			"   "		; file ext.
		dw			0			; current block
	fcb_recode_size:
		dw			1			; recode size
		db			0,0,0,0		; file size
		dw			0			; date
		dw			0			; time
		db			0			; device ID
		db			0			; directory location
		dw			0			; start cluster
		dw			0			; end cluster
		dw			0			; offset
		dw			0			; current recode
		db			0,0,0,0		; random recode

dta::
		db			0
